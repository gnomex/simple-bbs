require 'rubygems'
require 'active_record'
require 'eventmachine'
require 'yaml'

require './bbs/echo_server'
require './bbs/simple_chat_server'
#Models
require './model/user'
require './model/category'
require './model/post'

dbconfig = YAML::load(File.open('db/database.yml'))
ActiveRecord::Base.establish_connection(dbconfig)
ActiveRecord::Base.logger = Logger.new(STDERR)

module BBS
  VERSION = "0.0.1"

  def BBS.run_echo_server
    EventMachine.run do
      # hit Control + C to stop
      Signal.trap("INT")  { EventMachine.stop }
      Signal.trap("TERM") { EventMachine.stop }

      EventMachine.start_server("localhost", 10000, EchoServer)
    end
  end

  def BBS.simple_chat_server
    EventMachine.run do
      # hit Control + C to stop
      Signal.trap("INT")  { EventMachine.stop }
      Signal.trap("TERM") { EventMachine.stop }

      EventMachine.start_server("localhost", 10000, SimpleChatServer)
    end
  end
end
