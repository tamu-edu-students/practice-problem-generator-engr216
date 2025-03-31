Feature: Propagation of Error Problem Generator
  As a student
  I want a page that dynamically generates propagation of error problems for me to attempt
  So that I can practice propagation of error

  Scenario: Generate new Problem
    Given I am on the Propagation of Error problem page
    When I click the propagation of error "New Problem" button
    Then a new propagation of error problem should be generated

  Scenario: Answer Submission
    Given I am on the Propagation of Error problem page
    When I submit an answer for propagation of error
    Then I should receive feedback on my propagation of error answer 