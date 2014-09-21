require 'uri'
require 'feedjira'
require 'feedbook/post'
require 'feedbook/notification'
require 'feedbook/errors/parse_feed_error'
require 'feedbook/errors/invalid_feed_url_error'
require 'feedbook/errors/invalid_variables_format_error'

module Feedbook
  class Feed

    attr_reader :urls, :notifications, :variables 

    # Initializes new Feed instance for given configuration
    # @param opts = {} [Hash] Hash with configuration options for feed
    # 
    # @return [NilClass] nil
    def initialize(opts = {})
      @urls          = opts.fetch(:urls, '').split
      @variables     = opts.fetch(:variables, {})
      @notifications = opts.fetch(:notifications, []).map do |notification|
        Notification.new(
          type:            notification['type'],
          template:        notification['template'],
          update_template: notification['update_template'],
          variables:       variables
        )
      end
    end

    # Fetches and parses all feed and merges into single array.
    # 
    # @return [Array] array of Posts
    def fetch
      urls
      .map do |url|
        parse_feed(Feedjira::Feed.fetch_and_parse(url))
      end
      .inject :+
    end

    # Validates if given parameters are valid
    # 
    # @return [NilClass] nil
    # @raise [Feedbook::Errors::InvalidVariablesFormatError] if variables parameter is not a Hash
    # @raise [Feedbook::Errors::InvalidFeedUrlError] if url collection is not a empty and contains valid urls 
    def valid?
      if urls.empty? || urls.any? { |url| url !~ /\A#{URI::regexp}\z/ }
        raise Errors::InvalidFeedUrlError.new
      end

      unless variables.is_a? Hash
        raise Errors::InvalidVariablesFormatError.new
      end

      notifications.each { |notification| notification.valid? }
    end

    private

    # Parses feetched feed into Feedbook::Post 
    # @param feed [Feedjira::Parser::Atom] Atom/RSS feed 
    # 
    # @return [Array] array of Posts created from feed entries
    def parse_feed(feed)
      feed.entries.map do |entry|
        Post.new(
           author:     entry.author,
           published:  entry.published,
           url:        entry.url,
           title:      entry.title,
           feed_title: feed.title
        )
      end
    end

    # Determines behavior of failure in fetching feeds
    # @param url [String] requested url
    # 
    # @raise [Feedbook::Error::ParseFeedError] if fetching and parsing feed was unsuccessful
    def on_failure(url)
      raise Error::ParseFeedError.new(url)
    end

  end
end