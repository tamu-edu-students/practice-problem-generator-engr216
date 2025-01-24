Feature: Return Home

  Scenario: Return Home from the Problem's page
    Given I am on the Problem's page
    When I click on the "Home" button 
    Then I should be redirected to the Student Home view
