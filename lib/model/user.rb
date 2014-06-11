module BBS
  class User < ActiveRecord::Base
    has_many :posts

    validates :name, presence: true
    validates :admin, inclusion: { in: [true, false] }

    default_scope { order('created_at DESC') }

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

    def how_many_posts?
      self.posts.count
    end

    private
    def check_admin
      self.admin
    end

    def make_admin
      self.admin = true
    end
  end
end
