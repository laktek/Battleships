$:.unshift File.expand_path(File.dirname(__FILE__)) + '/../../lib'

require 'spec'
require 'battleships'

class BattleShipsWorld
  def initialize
    start_server
  end

  private
  def start_server
    @receiver = Game.new :host => "localhost", :port => 2206
    @receiver.standby
  end

end

World do
  BattleShipsWorld.new
end

Before do
  @receiver.default_return_salvo = "[{}, ['A2', 'B2', 'C2']]"
end

After do
  @receiver.close
end
