module BBS
  class Category < ActiveRecord::Base
    has_many :posts

  end
end
