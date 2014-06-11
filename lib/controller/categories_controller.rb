module BBS
  class CategoriesController

    def create(name)
      @category = Category.find_by(name: name)

      if @category.nil?
        @category = Category.new(name: name)
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
      @category = Category.find_by(category_id: category.id)
      unless @category
        @category.destroy
        "Deleted!"
      else
        "Nothing found"
      end
    end
  end
end
