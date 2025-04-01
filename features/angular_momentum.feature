Feature: Angular Momentum Problem Generator
  As a student
  I want a page that dynamically generates angular momentum problems for me to attempt
  So that I can practice angular momentum

  Scenario: Generate new Problem
    Given I am on the "Angular Momentum" page
    When I click the "new problem" button
    Then a new "Angular Momentum" problem should be dynamically generated

  Scenario: Answer Submission
    Given I am on the "Angular Momentum" page
    When I submit an answer
    Then I should receive feedback on my angular momentum answer
