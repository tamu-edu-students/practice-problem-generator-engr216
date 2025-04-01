Feature: Particle Statics Problem Generator
  As a student
  I want a page that dynamically generates particle statics problems for me to attempt
  So that I can practice particle statics

  Scenario: Generate new Problem
    Given I am on the "Particle Statics" page
    When I click the "new problem" button
    Then a new "Particle Statics" problem should be dynamically generated

  Scenario: Answer Submission
    Given I am on the "Particle Statics" page
    When I submit an answer
    Then I should receive feedback on my particle statics answer