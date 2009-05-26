Given /^I have not already connected to a game$/ do
  @server = Battleships::Game.new
  @output = StringIO.new
  @server.output_stream = @output 
end

When /^I register myself on "([^\"]*)" and port (.*)$/ do |host, port|
  Thread.new {
    @server.start(host, port)
  }
end

Then /^I should see "([^\"]*)"$/ do |message|
  @output.string.rstrip.should == message
end

Given /^a server is registered on "([^\"]*)" and port (.*)$/ do |host, port|
    @server = Battleships::Game.new 
    Thread.new { @server.start host, port } 
end

When /^I connect to "([^\"]*)" and port (.*)$/ do |host, port|
  @client = Battleships::Game.new
  @output = StringIO.new
  @client.output_stream = @output 

  Thread.new { @client.connect host, port }
end

