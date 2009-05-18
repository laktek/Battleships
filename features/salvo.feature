Feature: Firing Salvos
  In order to defeat my opponent 
  As a battleships player
  I need to send and receive salvos with my opponent 

  Scenario: Firing Salvos
    Given I have connected with an opponent
    When I send him a salvo targetting A1, B1, C1
    Then Opponent show the received salvo
    And send a salvo back targetting A2, B2, C2
    And I show the received salvo 

  
