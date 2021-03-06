require 'rubygems'
require 'active_record'
require 'eventmachine'
require 'yaml'
require 'json'

require './bbs/echo_server'
require './bbs/simple_chat_server'
require './bbs/bbs_server'
#Models
require './model/user'
require './model/category'
require './model/post'
#Controllers
require './controller/users_controller'
require './controller/categories_controller'
require './controller/posts_controller'

dbconfig = YAML::load(File.open('db/database.yml'))
ActiveRecord::Base.establish_connection(dbconfig)
ActiveRecord::Base.logger = Logger.new(STDERR)

module BBS
  VERSION = "0.0.1"

  # Run the event machine and start the server socket
  def BBS.start_bbs_server
    EventMachine.run do
      # hit Control + C to stop
      Signal.trap("INT")  { EventMachine.stop }
      Signal.trap("TERM") { EventMachine.stop }

      puts "Starting a server..."

      EventMachine.start_server('0.0.0.0', 10000, BBSServer)
    end
  end
end
