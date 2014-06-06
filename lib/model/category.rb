module BBS
  class Category < ActiveRecord::Base
    has_many :posts

    def initialize(args)

    end
  end
end
