module BBS
  # Manage the category model
  class CategoriesController

    # Create a new category
    def create(category)
      @category = Category.find_by(name: category)

      if @category.nil?
        @category = Category.new(name: category)
        return @category if @category.save
      else
        @category
      end
    end

    # Return all categories
    def all_categories
      Category.all
    end

    # Search a category
    # => Apply the name filter
    def search(category)
      Category.find_by(name: category)
    end

    # Return all categories ordened
    def categories
      Category.all.order
    end

    # Delete a category
    # => Do not remove if category has associated
    def delete(category)
      @category = Category.find_by(name: category)

      unless @category.nil?
        how_many = @category.posts.count
        if how_many == 0
          @category.destroy
          "Deleted!"
        else
          "Category has #{how_many} posts associated, cannot remove"
        end
      else
        "Nothing found"
      end
    end
  end
end
