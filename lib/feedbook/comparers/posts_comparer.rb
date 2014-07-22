module Feedbook
  module Comparers
    module PostsComparer
      def self.get_new_posts(old_posts, new_posts)
        new_posts.select { |post| old_posts.all? { |opost| opost.url != post.url } }
      end
    end
  end
end