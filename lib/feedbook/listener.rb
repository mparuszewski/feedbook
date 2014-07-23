require 'yaml'
require 'timeloop'
require 'feedbook/feed'
require 'feedbook/configuration'
require 'feedbook/comparers/posts_comparer'

module Feedbook
  class Listener

    def self.start(path)
      print "Loading configuration from file #{path}... "
      feeds, configuration = load_configuration(path)
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

    private

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
    end

  end
end