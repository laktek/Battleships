$:.unshift File.expand_path(File.dirname(__FILE__)) + '/../../lib'

require 'spec'
require 'battleships'

module TestBattleShips
  class TestGame < Game
    attr_writer :default_return_salvo

    def get_salvo
      return @default_return_salvo if @default_return_salvo

      super
    end
  end
end

class BattleShipsWorld
  include TestBattleShips

  def initialize
    start_server
  end

  private
  def start_server
    @receiver = TestGame.new :host => "localhost", :port => 2206
    @receiver.default_return_salvo = "[{}, ['A2', 'B2', 'C2']]"

    @receiver.standby
  end
end

World do
  BattleShipsWorld.new
end

After do
  @receiver.close
end
