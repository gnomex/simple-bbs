module BBS
 class PostsController

    def create(hash, user)
      if validate_params(hash)

        category = CategoriesController.new.create(hash["category"])
        hash.delete("category")

        puts hash.inspect

        @post = Post.new(hash)
        @post.category = category
        @post.user = user

        @post if @post.save
      else
        nil
      end
    end

    def delete(post_id, user)
      @post = Post.find_by(post_id: post_id)

      unless @post.nil?
        if @post.is_owner?(user) or user.admin?
          @post.destroy
          "Deleted!"
        else
          "You do not have permission to delete!"
        end
      else
        "Nothing found for #{post.title}"
      end
    end

    def posts
      @posts = Post.all
    end

    def search(user = nil, category = nil)
      @posts = Post.all

      unless category.nil?
        @posts = @posts.by_category(category)
      end

      unless user.nil?
        @posts = @posts.by_owner(user)
      end

      @posts
    end

    private
    def validate_params(hash)
      hash.include?('title') and hash.include?('body') and hash.include?('category')
    end
  end
end
