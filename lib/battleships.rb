#require "socket"
require "singleton"
require "eventmachine"

module Battleships

  module IoStreams
    #TODO consider refactoring this module
    #sets the output stream
    attr_writer :output_stream

    def output_stream
      @output_stream ||= STDOUT 
    end
  end

  module GameBroker
    include EM::Protocols::Stomp
    include IoStreams

    # The instance of game
    attr_accessor :backend

    def post_init
      output_stream.puts "Starting a new game..."
    end
    
    def connection_completed
      connect :player => "test" #self.nickname 
      get_input
    end

    def receive_msg msg
      case msg.command
        when "CONNECT"
          player = msg.headers['plyaer'] || "Unknown player"
          output_stream.puts "#{player} offers to play a new game. Accept?"
        when "SEND"
          output_stream.puts "Received Salvo: #{msg.body}"
          get_input
      end
    end

    def get_input
      output_stream.puts "Enter 3 co-ordinates to attack (or CLOSE to end game):"
      user_input = gets.rstrip

      unless user_input == "CLOSE"
        send_salvo(user_input)
      else
        close_connection
      end
    end

    def send_salvo(points)
      send "salvo", points, {"content-length" => points.size}
    end

    def unbind
      output_stream.puts "Game Halted!"
    end

  end

  class Game
    #include Singleton
    include IoStreams

    attr_accessor :nickname

        # Sets up as a server and waits for a game request 
    def start(host="localhost", port=2230)
      output_stream.puts "waiting till an opponent connect..."
      EventMachine::run {
        EventMachine::start_server host, port, GameBroker, &method(:setup_handler) 
      }
    end

    # Connect a client to an available server
    def connect(host="localhost", port=2230)
      output_stream.puts "sending request for a new game..."
      EventMachine::run {
        EventMachine::connect host, port, GameBroker, &method(:setup_handler)
      }
    end

    protected
    def setup_handler(connection)
      connection.backend = self
      connection.output_stream = self.output_stream
    end


  end

end

