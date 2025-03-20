Feature: Engineering Ethics Problem Generator
  As a student
  I want a page that dynamically generates engineering ethics problems for me to attempt
  So that I can practice engineering ethics

  Scenario: Generate new Problem
    Given I am on the "Engineering Ethics" page
    When I click the "new problem" button
    Then a new "Engineering Ethics" problem should be dynamically generated

  Scenario: Answer Submission
    Given I am on the "Engineering Ethics" page
    When I submit an answer
    Then I should receive feedback on my answer