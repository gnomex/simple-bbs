module BBS
  # Only a code example
  class EchoServer < EM::Connection
    def receive_data(data)
      puts data.to_s
      if data.strip =~ /exit$/i
        EventMachine.stop
      else
        send_data(data)
      end
    end
  end
end
