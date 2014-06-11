module BBS
  class Category < ActiveRecord::Base
    has_many :posts

    validates :name, presence: true

    default_scope { order('created_at DESC') }
  end
end
