Feature: Angular Momentum Problem Generator
  As a student
  I want a page that dynamically generates angular momentum problems for me to attempt
  So that I can practice angular momentum

  Scenario: Generate new Problem
    Given I am on the "Angular Momentum" page for momentum
    When I click the angular momentum new problem button
    Then a new "Angular Momentum" problem should be dynamically generated for momentum

  Scenario: Answer Submission
    Given I am on the "Angular Momentum" page for momentum
    When I submit an angular momentum answer
    Then I should receive feedback on my angular momentum answer
