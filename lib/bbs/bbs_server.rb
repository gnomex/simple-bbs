module BBS
  # The BBS Server
  # => Class is the eventmachine runner
  class BBSServer < EM::Connection
    attr_reader :user

    # Must be need a class variable!
    @@connected_clients = Array.new

    #
    # EventMachine handlers
    #

    # Handle the TCP SYN flag
    def post_init
      puts "TCP connection attempt completed successfully and a new client has connected."
      ask_username
    end

    # Handle the TCP FIN flag
    def unbind
      notify "TCP connection closed successfully. Come back soon"
      @@connected_clients.delete(@user)
    end

    # Handle the TCP PUSH flag
    def receive_data(data)
      # remove white spaces and downcase
      data = data.downcase

      if active_user?
        handle_raw_data(data)
      else
        handle_username(data.strip)
      end
    end

    #
    # Username handling
    #

    # User have an session?
    def active_user?
      !@user.nil?
    end

    # Handle the user name for a new connection
    def handle_username(input)
      if input.empty?
        send_line("Blank usernames are not allowed. Try again.")
        ask_username
      else
        @user = UsersController.new.check_user(input)

        unless other_peers
          @@connected_clients.push(@user)
          send_line("-> Welcome #{@user.username}. You have #{@user.how_many_posts?} publications")
          send_line("See the available categories")
          show_categories
        else
          puts " #{@user.username}_two have two connections, kill one!"
          handle_close
        end
      end
    end

    # Ask a name for a new connection
    def ask_username
      send_line("--  Enter your username:")
    end

    #
    # Actions handling
    #

    # Handle the JSON actions
    # => Hash is a ruby Hash with all keys
    def handle_actions(hash)
      case hash['action']
      when "create" then handle_create(hash)
      when "show" then handle_show(hash)
      when "delete" then handle_delete(hash)
      when "marmota" then handle_close
      when "status" then status
      else self.send_line "What? I cannot understand you, bro!"
      end
    end

    # Receive a String and convert to a hash
    # => Hash is a pure String
    def handle_raw_data(data)
      # Try convert to a JSON
      begin
        # All data is parsed to a JSON, making a ruby Hash
        data_hash = JSON.parse(data)
        # After parse, if can parse, handle the action method
        handle_actions(data_hash)
      rescue Exception => error
        # if cannot parse the JSON, show the error
        send_line "What? I cannot understand you, bro!"
        puts "Error #{error.inspect}"
      end
    end

    #
    # Helpers
    #

    # Sent the status of the server
    def status
      notify "It's #{Time.now}, and there are #{@@connected_clients.length} marmots"
    end # announce(msg)

    # Server emit a message for users
    def notify(msg = nil, prefix = "[BBS server]")
      send_line("#{prefix} #{msg}")
    end

    # Another way to Server emit a message for users
    def broadcast_notify(msg = nil, prefix = "[BBS server]")
      @@connected_clients.each { send_line("#{prefix} #{msg}") } unless msg.empty?
    end

    # Count the number of connections
    def number_of_connected_clients
      @@connected_clients.size
    end # number_of_connected_clients

    # Verify if user have a active connection
    def other_peers
      @@connected_clients.include?(@user)
    end

    # Sent data for socket
    def send_line(line)
      self.send_data("#{line}\n")
    end

    private
    # Handle create
    # => Create a new post or category
    # => data_hash is a ruby Hash with what and data keys
    def handle_create(data_hash)
      case data_hash['what']
      when 'post' then create_a_post(data_hash['data'])
      when 'category' then create_a_category(data_hash['data'])
      else send_line "What?"
      end
    end

    # Create a new post
    # => Call the Posts controller to make all work
    # => data_hash is a ruby Hash with data keys
    def create_a_post(data_hash)
      begin
        @post = PostsController.new.create(data_hash, @user)
      rescue Exception => e
        puts e.inspect
      end

      unless @post.nil?
        send_line "successfully created, see: #{@post.to_json}"
      else
        send_line "Post cannot be created"
      end
    end

    # Create a new post
    # => Call the Categories controller to make all work
    # => data_hash is a ruby Hash with data keys
    def create_a_category(data_hash)
      @category = CategoriesController.new.create(data_hash['name'])

      unless @category.nil?
        send_line "successfully created, see: #{@category.to_json}"
      else
        send_line "Category cannot be created"
      end
    end

    # Handle show actions
    # => Redirect actions to especific methods
    # => data_hash is a ruby Hash with what and data keys
    def handle_show(data_hash)
      case data_hash['what']
      when 'users' then show_users
      when 'posts' then show_posts_by_filter(data_hash['data'])
      when 'categories' then show_categories
      else self.send_line "What? I cannot understand you, bro!"
      end
    end

    # Show users
    def show_users
      users = UsersController.new.all_users(@user)
      send_line "#{users.to_json}"
    end

    # Show Categories
    def show_categories
      categories = CategoriesController.new.all_categories

      if categories.empty?
        send_line "Nothing found."
      else
        send_line "#{categories.to_json}"
      end
    end

    # Show posts, by filter if provided
    # => hash is a ruby Hash with data keys
    def show_posts_by_filter(hash)
      begin
        @posts = PostsController.new.search(hash['user'], hash['category'])

        if @posts.empty?
          send_line "Nothing found."
        else
          send_line "#{@posts.to_json}"
        end
      rescue Exception => e
        puts "An error has ocurred. See: #{e.message}"
      end
    end

    # Handle the delete action
    # => data_hash is a ruby Hash with what and data keys
    def handle_delete(data_hash)
      case data_hash['what']
      when 'post' then delete_a_post(data_hash['data'])
      when 'category' then delete_a_category(data_hash['data'])
      else send_line "What?"
      end
    end

    # Calls Categories controller to delete a post
    # => hash is a ruby Hash with data keys
    def delete_a_post(hash)
      message = PostsController.new.delete(hash['post_id'], @user)
      send_line "#{message.to_json}"
    end

    # Calls Categories controller to delete a category
    # => hash is a ruby Hash with data keys
    def delete_a_category(hash)
      message = CategoriesController.new.delete(hash['category'])
      send_line "#{message.to_json}"
    end

    # Close the connection for a user
    def handle_close
      send_line "Closing the server. Come back later #{@user.username}"
      puts " #{@user.username} has left."
      self.close_connection
    end
  end
end
