module BBS
  class Category < ActiveRecord::Base

    attr_accessor :name, :description

    def initialize(args)

    end
  end
end
