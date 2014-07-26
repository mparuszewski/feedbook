require 'yaml'
require 'timeloop'
require 'feedbook/feed'
require 'feedbook/errors'
require 'feedbook/configuration'
require 'feedbook/comparers/posts_comparer'

module Feedbook
  class Listener

    # Starts listening on feeds and notifies if there is new post.
    # @param path [String] configuration file path
    def self.start(path)
      handle_exceptions do
        print "Loading configuration from file #{path}... "
        feeds, configuration = load_configuration(path)
        feeds.each { |feed| feed.valid? }
        puts 'completed.'

        print 'Loading notifiers... '
        configuration.load_notifiers
        puts 'completed.'

        print 'Fetching feeds for the first use... '
        observed_feeds = feeds.map do |feed|
          {
            feed: feed,
            old_posts: feed.fetch,
            new_posts: [] 
          }
        end
        puts 'completed.'

        puts 'Listener started...'
        every configuration.interval do
          
          puts 'Fetching feeds...'
          observed_feeds.each do |feed|
            new_posts = feed[:feed].fetch

            difference = Comparers::PostsComparer.get_new_posts(feed[:old_posts], new_posts)
            
            if difference.empty?
              puts 'No new posts found.'
            else
              puts "#{difference.size} new posts found."
              print 'Started sending notifications... '
            end

            difference.each do |post|
              feed[:feed].notifications.each do |notification|
                notification.notify(post)
              end
            end

            unless difference.empty?
              puts 'completed.'
            end

            feed[:old_posts] = new_posts
            feed[:new_posts] = []
          end
        end
      end
    end

    private

    # Handle exceptions rescued from given block 
    def self.handle_exceptions
      yield if block_given?
    rescue Errors::InvalidFeedUrlError
      abort 'feed url collection is not valid (contains empty or invalid urls)'
    rescue Errors::InvalidIntervalFormatError
      abort 'interval value in configuration is not valud (should be in format: "(Number)(TimeType)" where TimeType is s, m, h or d)'
    rescue Errors::InvalidVariablesFormatError
      abort 'invalid variables format in configuration (should be a key-value pairs)'
    rescue Errors::NoConfigurationFileError => e
      abort "configuration file could not be loaded: #{e.message}"
    rescue Errors::NotifierConfigurationError => e
      abort "notifier #{e.notifier} has invalid configuration (#{e.message})."
    rescue Errors::NotifierNotifyError => e
      p     "notifier #{e.notifier} did not notify because of client error (#{e.message})."
    rescue Errors::ParseFeedError => e
      p     "feed on #{e.url} could not be parsed because of fetching/parsing error."
    rescue Errors::UnsupportedNotifierError => e
      abort "notifier #{e.notifier} is not supported by Feedbook."
    rescue Errors::TemplateSyntaxError
      abort "one of your templates in configuration file is not valid."
    end

    # Load configuration from given path
    # @param path [String] configuration file path
    # 
    # @return [[Array, Feedbook::Configuration]] feeds and Configuration instance 
    # @raise [Feedbook::Errors::NoConfigurationFileError] if path to config file is invalid of configuration file is missing
    def self.load_configuration(path)
      config = YAML.load_file(path)

      feeds = config.fetch('feeds', []).map do |feed|
        Feed.new(
          urls:          feed['url'],
          variables:     feed['variables'],
          notifications: feed['notifications']
        )
      end
      
      configuration_hash = config.fetch('configuration', {})

      configuration = Configuration.new(
        twitter:     configuration_hash['twitter'],
        facebook:    configuration_hash['facebook'],
        interval:    configuration_hash['interval'],
      )

      [feeds, configuration]
    rescue Errno::ENOENT => e
      raise Errors::NoConfigurationFileError.new(e)
    end

  end
end