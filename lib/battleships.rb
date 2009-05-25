#require "socket"
require "eventmachine"

class Game

  #Starts a new game as a server waiting for someone to connect
  # or as a client connecting to already avaialable server
  def initialize(options = {})
    unless options.empty?
      #setup the server 
      @server = TCPServer.new(options.fetch(:host){"localhost"}, options[:port])
    end
    @last_salvo_targets = []
  end

  def standby
   @thread = Thread.new {
    while session = @server.accept
      msg = session.gets
      self.last_salvo_targets = msg

      data = get_salvo  #"[{}, ['A2', 'B2', 'C2']]"
      session.puts(data)
    end
   }
  end

  def close
    @server.close
    @thread.kill
  end

  def fire(salvo)
    @connection.puts serialized_salvo(salvo) 

    response = @connection.gets
    self.last_salvo_targets = response
  end

  def connect(host, port)
    @connection = TCPSocket.new(host, port)
  end

  def show_last_salvo
    "Received Salvo: #{self.last_salvo_targets}"
  end

  def last_salvo_targets=(response)
    @last_salvo_targets = eval(response.rstrip)[1]
  end

  def last_salvo_targets
    @last_salvo_targets.join(", ")
  end

  def get_salvo
    puts "Enter 3 targets to aim (eg: A1, B1, C1):"
    targets = gets
    puts targets
    #salvo = serialized_salvo(input.rstrip.split(", ")) 
  end

  private
  def serialized_salvo(salvo) 
    puts salvo
    string_values = salvo.map{|s| "'#{s}'"}.join(", ")
    "[{}, [#{string_values}]]"
  end

end

class Salvo < Array

end
