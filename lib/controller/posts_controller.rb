module BBS
  class PostsController
    def initialize(args = {})
      @post = Post.new(args)
    end

    def delete(user)
      if @post.is_owner?(user) || user.admin?
        @post.destroy
      else
        "You do not have permission to delete!"
      end
    end

    def search(user = nil, category = nil)
      @posts = Post.all

      unless category.nil?
        @posts = @posts.by_category(category)
      end

      unless user.nil?
        @posts = @posts.by_owner(user)
      end

      @posts.order
    end

    def assign_owner(user)
      @post.user_id = user.id
    end

    def assign_category(category)
      @post.category_id = category.id
    end
  end
end
