module BBS
  class Post < ActiveRecord::Base
    belongs_to :user
    belongs_to :category

    validates :title, :body, :user_id, :category_id, presence: true

    default_scope { order('created_at DESC') }

    def is_owner?(user)
      self.user.name == user.name
    end

    # Named Scopes
    class << self
      def by_category(category)
        joins(:category).find_by(name: category.name)
      end

      def by_owner(user)
        joins(:user).find_by(name: user.name)
      end
    end
  end
end
