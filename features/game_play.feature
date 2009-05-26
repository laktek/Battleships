Feature: Starting a new game 
  In order to have fun 
  As a battleships player
  I need a way to start a new game

  Scenario: Registering as a server 
    Given I have not already connected to a game 
    When I register myself on "localhost" and port 2230
    Then I should see "waiting for a new game request..." 

  Scenario: Connecting with a registered server
    Given Matt is registered on "localhost" and port 2230
    When I connect to "localhost" and port 2230
    Then I should see "sending request for a new game..."

  Scenario: Accepting a new game offer
    Given I am registered on "localhost" and port 2230
    When John connects to "localhost" and port 2230
    Then I should see "John offers to play a new game. Accept?"
    And I should send the acceptance

  Scenario: Getting the invitation accepted
    Given Matt is registered on "localhost" and port 2230
    When I connect to "localhost" and port 2230
    And server accepts the offer  
    Then I should see "Matt accepted your offer"
    And I should send the first salvo
    
