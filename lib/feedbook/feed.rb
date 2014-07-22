require 'feedjira'
require 'feedbook/post'
require 'feedbook/notification'
require 'feedbook/errors/parse_feed_error'

module Feedbook
  class Feed

    attr_reader :urls, :notifications, :variables 

    def initialize(opts = {})
      @urls          = opts.fetch(:urls, '').split
      @variables     = opts.fetch(:variables, {})
      @notifications = opts.fetch(:notifications, []).map do |notification|
        Notification.new(
          type:      notification['type'],
          template:  notification['template'],
          variables: variables
        )
      end
    end

    def fetch
      urls
      .map do |url|
        parse_feed(Feedjira::Feed.fetch_and_parse(url))
      end
      .inject :+
    end

    private

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

    def on_failure(url)
      raise Error::ParseFeedError.new(url)
    end

  end
end