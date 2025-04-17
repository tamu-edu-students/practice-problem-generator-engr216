Feature: Problem Answer Interaction

  As a student
  I want to either view the correct answer or check my input
  So that I can learn effectively while retaining control over my attempts

  Background:
    Given I am on a problem page
    And the problem has not been solved

  Scenario: Clicking "View Answer"
    When I click the "View Answer" button
    Then the correct solution should be displayed
    And the "Check Answer" button should be disabled

  Scenario: Clicking "Check Answer"
    When I enter a response in the input field
    And I click the "Check Answer" button
    Then the system should evaluate my response
    And provide feedback without showing the correct solution
    And I should still be able to modify my answer and try again
    And the "View Answer" button should remain active