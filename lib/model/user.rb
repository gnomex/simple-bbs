module BBS
  class User < ActiveRecord::Base
    has_many :posts

    def admin?
      check_admin
    end

    private

    def check_admin
      false
    end
  end
end
