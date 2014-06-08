module BBS
  class User < ActiveRecord::Base
    has_many :posts

    before_create :set_default_role

    def initialize
      self.admin = false
    end

    def admin?
      check_admin
    end

    def make_admin!
      make_admin
    end

    def username
      ["@", self.name].join()
    end

    private
    def check_admin
      self.admin
    end

    def make_admin
      self.admin = true
    end

    def set_default_role
      self.admin = false
      nil
    end
  end
end
