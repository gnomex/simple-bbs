module BBS
  class Category < ActiveRecord::Base

    attr_accessor :name

    has_many :posts

    def initialize(args)

    end
  end
end
