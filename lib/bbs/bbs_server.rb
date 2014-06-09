module BBS
  class BBSServer < EM::Connection
    attr_accessor :connected_clients
    attr_reader :user

    # Must be need a class variable!
    @@connected_clients = Array.new

    #
    # EventMachine handlers
    #
    def post_init
      puts "TCP connection attempt completed successfully and a new client has connected."
      ask_username
    end

    def unbind
      puts "TCP connection closed successfully. Come back soon #{@user.username}"
      @connected_clients.delete(self)
    end

    def receive_data(data)
      # remove white spaces and downcase
      data = data.strip.downcase

      if active_user?
        handle_raw_data(JSON.parse(data))
      else
        handle_username(data)
      end
    end

    #
    # Username handling
    #
    def active_user?
      !@user.nil?
    end

    def handle_username(input)
      if input.empty?
        send_line("Blank usernames are not allowed. Try again.")
        ask_username
      else
        username = input

        @user = UsersController.new.check_user(username)

        self.send_line("-> Welcome #{@user.username}")
      end
    end # handle_username(input)

    def ask_username
      self.send_line("[info] Enter your username:")
    end # ask_username

    #
    # Actions handling
    #

    def handle_actions(action)
      case action['action']
      when "create"
      when "show"
      when "delete"
      when "marmota"
      end
    end

    def handle_raw_data(msg)
      if command?(msg)
        self.handle_command(msg)
      else
        if direct_message?(msg)
          self.handle_direct_message(msg)
        else
          self.announce(msg, "#{@username}:")
        end
      end
    end

    def handle_direct_message(input)
      username, message = parse_direct_message(input)

      if connection = @connected_clients.find { |c| c.username == username }
        puts "[dm] @#{@username} => @#{username}"
        connection.send_line("[dm] @#{@username}: #{message}")
      else
        send_line "@#{username} is not in the room. Here's who is: #{usernames.join(', ')}"
      end
    end # handle_direct_message(input)

    def parse_direct_message(input)
      return [$1, $2] if input =~ DM_REGEXP
    end # parse_direct_message(input)


    #
    # Commands handling
    #

    def command?(input)
      input =~ /(exit|status)$/i
    end # command?(input)

    def handle_command(cmd)
      case cmd
      when /exit$/i   then self.close_connection
      when /status$/i then self.send_line("[chat server] It's #{Time.now.strftime('%H:%M')} and there are #{self.number_of_connected_clients} people in the room")
      end
    end # handle_command(cmd)


    #
    # Helpers
    #
    def announce(msg = nil, prefix = "[chat server]")
      @connected_clients.each { |c| c.send_line("#{prefix} #{msg}") } unless msg.empty?
    end # announce(msg)

    def number_of_connected_clients
      @connected_clients.size
    end # number_of_connected_clients

    def other_peers
      @connected_clients.reject { |c| self == c }
    end # other_peers

    def send_line(line)
      self.send_data("#{line}\n")
    end # send_line(line)

    def usernames
      @connected_clients.map { |c| c.username }
    end # usernames
  end
end
