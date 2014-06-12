module BBS
  # Manage the user model
  class UsersController
    # Check if user exists
    # => Create if not
    def check_user(username)
      @user = User.find_by(name: username)

      unless @user.nil?
        @user
      else
        @user = User.new(name: username)

        @user if @user.save
      end
    end

    # All users
    def all_users(user)
      if user.admin?
        User.all
      else
        "You do not have permission"
      end
    end

    # Make a user an admin :)
    def make_admin!
      @user = User.find(:id)
      @user.make_admin!
      @user.update
    end
  end
end
