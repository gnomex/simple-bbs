module BBS
  class User < ActiveRecord::Base
    has_many :posts

    before_create :set_default_role

    def admin?
      check_admin
    end

    def username
      ["@", self.name].join()
    end

    private
    def check_admin
      self.admin
    end

    def set_default_role
      self.admin = false
      nil
    end
  end
end
