module BBS
  class Post < ActiveRecord::Base

    attr_accessor :title, :body, :created_at

    belongs_to :user
    belongs_to :category

    def initialize(args = {})

    end

    def owner
      "Marmot"
    end
  end
end
