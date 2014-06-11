module BBS
  class UsersController
    def have_name?
      @user.username?
    end

    def check_user(username)
      @user = User.find_by(name: username)

      unless @user.nil?
        @user
      else
        @user = User.new(name: username)

        @user if @user.save
      end
    end

    def all_users(user)
      if user.admin?
        User.all
      else
        "You do not have permission"
      end
    end

    def make_admin!
      @user = User.find(:id)
      @user.make_admin!
      @user.update
    end

  end
end
