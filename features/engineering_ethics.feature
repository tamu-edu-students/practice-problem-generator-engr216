Feature: Engineering Ethics Problem Generator
  As a student
  I want a page that dynamically generates engineering ethics problems for me to attempt
  So that I can practice engineering ethics

  Scenario: Generate new Problem
    Given I am on the Engineering Ethics problem page
    When I click the engineering ethics new problem button
    Then a new engineering ethics problem should be generated

  Scenario: Answer Submission
    Given I am on the Engineering Ethics problem page
    When I submit an engineering ethics answer
    Then I should receive feedback on my answer