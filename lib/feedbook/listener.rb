require 'yaml'
require 'timeloop'
require 'feedbook/feed'
require 'feedbook/plugins_manager'
require 'feedbook/errors'
require 'feedbook/configuration'
require 'feedbook/comparers/posts_comparer'

module Feedbook
  class Listener

    # Starts listening on feeds and notifies if there is new post.
    # @param path [String] configuration file path
    # @param plugins_path [String] plugins directory path
    def self.start(path, plugins_path)
      handle_exceptions do
        feeds, configuration = initialize_listener(path, plugins_path)

        print 'Fetching feeds for the first use... '
        observed_feeds = feeds.map do |feed|
          {
            feed:  feed,
            posts: feed.fetch
          }
        end
        puts 'completed.'

        puts 'Listener started...'
        every configuration.interval do
          
          puts 'Fetching feeds...'
          observed_feeds.each do |feed|
            observe_and_notify(feed)
          end
        end
      end
    end

    # Starts listening on feeds and notifies if there is new post (offline mode).
    # @param path [String] configuration file path
    # @param plugins_path [String] plugins directory path
    def self.start_offline(path, archive_path, plugins_path)
      handle_exceptions do
        feeds, configuration = initialize_listener(path, plugins_path)

        observed_feeds = load_feeds_archive(archive_path)

        if observed_feeds.blank?
          print 'Fetching feeds for the first use... '
          observed_feeds = feeds.map do |feed|
            {
              feed: feed,
              posts: feed.fetch
            }
          end
          puts 'completed.'
        end

        puts 'Fetching feeds...'
        observed_feeds.each do |feed|
          observe_and_notify(feed)
        end

        save_feeds_archive(archive_path, observed_feeds)
      end
    end

    # Load feeds from serialized YAML file.
    # @param [String] path to YAML file with serialized objects
    #
    # @return [Array] Array of feeds with archived posts
    def self.load_feeds_archive(path)
      print 'Reading feeds from file... '

      if File.exist? path
        puts 'completed.'
        YAML::load(File.read(path))
      else
        puts 'canceled. File does not exist.'
        []
      end
    end

    # Saves feeds into serialized YAML file
    # @param path [String] path to file
    # @param feeds [Array] Array with feeds to be saved
    # 
    # @return [NilClass] nil
    def self.save_feeds_archive(path, feeds)
      print 'Saving feeds to file... '

      File.open(path, 'w') do |f|
        f.write YAML::dump(feeds)
      end

      puts 'completed.'
    end

    # Single run of loop for listening for changes in RSS feeds and notifies about updates
    # @param feed [Feedbook::Feed] requested feed to be observed (hash with feed and posts)
    #
    # @return [NilClass] nil
    def self.observe_and_notify(feed)
      new_posts = feed[:feed].fetch

      difference = Comparers::PostsComparer.get_new_posts(feed[:posts], new_posts)

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

      feed[:posts] = new_posts

      feed
    end

    private

    # Handle exceptions rescued from given block 
    def self.handle_exceptions
      yield if block_given?
    rescue Errors::InvalidFeedUrlError
      abort 'feed url collection is not valid (contains empty or invalid urls)'
    rescue Errors::InvalidIntervalFormatError
      abort 'interval value in configuration is not valid (should be in format: "(Number)(TimeType)" where TimeType is s, m, h or d)'
    rescue Errors::InvalidVariablesFormatError
      abort 'invalid variables format in configuration (should be a key-value pairs)'
    rescue Errors::NoConfigurationFileError => e
      abort "configuration file could not be loaded: #{e.message}"
    rescue Errors::NotifierConfigurationError => e
      abort "notifier #{e.notifier} has invalid configuration (#{e.message})."
    rescue Errors::ParseFeedError => e
      p     "feed on #{e.url} could not be parsed because of fetching/parsing error."
    rescue Errors::TemplateSyntaxError
      abort "one of your templates in configuration file is not valid."
    end

    # Initializes listener configuration, loads plugins and notifiers.
    # @param path [String] config file path
    # @param plugins_path [String] plugins directory path
    # 
    # @return [[Array, Feedbook::Configuration]] feeds and Configuration instance 
    def self.initialize_listener(path, plugins_path)
      print "Loading configuration from file #{path}... "
      feeds, configuration = load_configuration(path)
      feeds.each { |feed| feed.valid? }
      puts 'completed.'

      Feedbook::PluginsManager.load_plugins(plugins_path)

      puts 'Loading notifiers... '
      configuration.load_notifiers
      puts 'completed.'

      [feeds, configuration]
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

      configuration = Configuration.new(configuration_hash)

      [feeds, configuration]
    rescue Errno::ENOENT => e
      raise Errors::NoConfigurationFileError.new(e)
    end
  end
end
