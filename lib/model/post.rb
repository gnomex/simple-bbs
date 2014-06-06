module BBS
  class Post < ActiveRecord::Base

    attr_accessor :owner, :title, :body, :created_at

    def initialize(args = {})

    end
  end
end
