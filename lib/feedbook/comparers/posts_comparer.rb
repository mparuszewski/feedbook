module Feedbook
  module Comparers
    module PostsComparer

      # Returns only posts from new posts list that does not exists in old posts list. 
      # @param old_posts [Array] list of old posts
      # @param new_posts [Array] list of new posts
      # 
      # @return [type] [description]
      def self.get_new_posts(old_posts, new_posts)
        new_posts.select { |post| old_posts.all? { |opost| opost.url != post.url } }
      end
    end
  end
end