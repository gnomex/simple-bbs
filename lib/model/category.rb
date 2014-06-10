module BBS
  class Category < ActiveRecord::Base
    has_many :posts

    validates :name, presence: true

    default_scope { order('created_at DESC') }

    # Named scopes
    class <<self
      def by_name(name)
        find_by(name: name)
      end
    end
  end
end
