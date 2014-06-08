module BBS
  class UsersController
    def initialize(args = {})
      @user = User.new
    end

    def create

    end

    def make_admin!
      @user = User.find(:id)
      @user.make_admin!
      @user.update
    end

    def delete
      User.find(:id).destroy
    end
  end
end
