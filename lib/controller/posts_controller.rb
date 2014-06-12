module BBS
  # Manage the post model
  class PostsController

    # Create a new user
    # => hash contains the data
    # => User is the owner
    def create(hash, user)
      if validate_params(hash)

        # Find the category
        category = CategoriesController.new.create(hash["category"])
        hash.delete("category") #Remove from the hash

        @post = Post.new(hash)
        @post.category = category
        @post.user = user

        @post if @post.save
      else
        nil
      end
    end

    # Delete a post
    # => post_id a id of post
    # => User is a current user
    def delete(post_id, user)
      @post = Post.find_by(id: post_id)

      unless @post.nil?
        # User can be owner or admin to delete
        if @post.is_owner?(user) or user.admin?
          @post.destroy
          "Deleted!"
        else
          "You do not have permission to delete!"
        end
      else
        "Nothing found for #{post_id}"
      end
    end

    # All posts
    def posts
      Post.all
    end

    # Search posts by filter
    # => User are optional
    # => Category are optional
    # Default is all posts
    def search(user = nil, category = nil)
      @posts = Post.all

      # Apply the category scope
      unless category.nil?
        @posts = @posts.by_category(category)
      end

      # Apply the owner scope
      unless user.nil?
        @posts = @posts.by_owner(user)
      end

      @posts
    end

    private
    # Validate the presence params to create a new post
    def validate_params(hash)
      hash.include?('title') and hash.include?('body') and hash.include?('category')
    end
  end
end
