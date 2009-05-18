Given /^I have connected with an opponent$/ do
  setup_game
end

When /^(.+) a salvo targetting (.+)$/ do |actor, squares|
  @salvo = Salvo.new squares.split(", ")
  @sender.fire @salvo
end

Then /^Opponent show the received salvo$/ do
  @receiver.show_last_salvo.should == "Received Salvo: A1, B1, C1"
end

Then /^send a salvo back targetting (.+)$/ do |squares|
  #We set this using a before hook which runs before the scenario
end

Then /^I show the received salvo$/ do
  @sender.show_last_salvo.should == "Received Salvo: A2, B2, C2"
end

Given /^An opponent is connected with me$/ do
  setup_game
end

private
def setup_game
  @sender = Game.new
  @sender.connect("localhost", 2206)
end
