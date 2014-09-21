module Feedbook
  module Comparers
    module PostsComparer
      # Returns only posts from new posts list that does not exist in old posts list.
      # @param old_posts [Array] list of old posts
      # @param new_posts [Array] list of new posts
      #
      # @return [type] [description]
      def self.get_new_posts(old_posts, new_posts)
        new_posts.select { |post| old_posts.all? { |opost| opost.url != post.url } }
      end

      # Returns only posts from new posts list that exists in old posts list, but title has changed.
      # @param old_posts [Array] list of old posts
      # @param new_posts [Array] list of new posts
      #
      # @return [type] [description]
      def self.get_updated_posts(old_posts, new_posts)
        existing_posts = new_posts.select { |post| post.any? { |opost| opost.url == post.url } }

        existing_posts.select do |post|
          old_post = old_posts.find { |opost| opost.url == post.url }

          old_post.title != post.title ||
          old_post.published != post.published
        end
      end
    end
  end
end
