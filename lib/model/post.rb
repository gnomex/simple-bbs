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
      def by_category(category_name)
        # Category.where(categories: { name: category_name }).joins(:posts)
        joins(:category).where(categories: { name: category_name })
      end

      def by_owner(user_name)
        # User.where(users: { name: user_name }).joins(:posts)
        joins(:user).where(users: { name: user_name })
      end
    end
  end
end
