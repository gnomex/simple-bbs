module BBS
  class User < ActiveRecord::Base
    attr_accessor :name

    has_many :posts

    def initialize(args = {})

    end

    def admin?
      check_admin
    end

    private

    def check_admin
      false
    end
  end
end