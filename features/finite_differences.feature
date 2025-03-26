Feature: Finite Differences Problem Generator
  As a student
  I want a page that dynamically generates finite differences problems for me to attempt
  So that I can practice finite differences

  Scenario: Generate new Problem
    Given I am on the "Finite Differences" page
    When I click the finite differences new problem button
    Then a new "Finite Differences" problem should be dynamically generated

  Scenario: Answer Submission
    Given I am on the "Finite Differences" page
    When I submit a finite differences answer
    Then I should receive feedback on my finite differences answer