module BBS
  class CategoriesController

    def create(category)
      @category = Category.find_by(name: category)

      if @category.nil?
        @category = Category.new(name: category)
        return @category if @category.save
      else
        @category
      end
    end

    def all_categories
      Category.all
    end

    def search(category)
      @categories = Category.by_name(category)
    end

    def categories
      @categories = Category.all.order
    end

    def delete(category)
      @category = Category.find_by(name: category)

      unless @category
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
