module BBS
  class Post < ActiveRecord::Base
    belongs_to :user
    belongs_to :category

    def initialize(args = {})

    end

    def owner
      "Marmot"
    end
  end
end
