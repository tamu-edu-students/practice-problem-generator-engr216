Feature: Universal Accounting Equation Problem Generator
    As a student
    I want a page that dynamically generates universal accounting equation problems for me to attempt
    So that I can practice the universal accounting equation

  Scenario: Generate new Problem
    Given I am on the Universal Accounting Equation problem page
    When I click the "new problem" button for Universal Accounting Equation
    Then a new universal accounting equation problem should be generated

  Scenario: Answer Submission
    Given I am on the Universal Accounting Equation problem page
    When I submit an answer for Universal Accounting Equation
    Then I should receive feedback on my answer for Universal Accounting Equation