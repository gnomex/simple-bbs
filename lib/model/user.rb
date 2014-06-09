module BBS
  class User < ActiveRecord::Base
    has_many :posts

    after_initialize :set_default_role

    validates :name, presence: true
    validates :admin, inclusion: { in: [true, false] }

    def admin?
      check_admin
    end

    def make_admin!
      make_admin
    end

    def username
      ["@", self.name].join()
    end

    def username?
      !self.name.empty?
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
    end
  end
end
