module BBS
  class CategoriesController

    def create(name = nil)
      @category = Category.find_by(name: name)

      if @category.nil?
        @category = Category.new(name: name)
        @category if @category.save
      else
        "Category already exists"
      end
    end

    def search(category)
      @categories = Category.by_name(category)
    end

    def categories
      @categories = Category.all
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
