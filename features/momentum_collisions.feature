Feature: Momentum & Collisions Problem Generator
  As a student
  I want a page that dynamically generates momentum and collisions problems for me to attempt
  So that I can practice momentum and collisions

  Scenario: Generate new Problem
    Given I am on the "Momentum & Collisions" page for collision problems
    When I click the generate new problem button for collisions
    Then a new "Momentum & Collisions" problem should be dynamically generated for collisions

  Scenario: Answer Submission
    Given I am on the "Momentum & Collisions" page for collision problems
    When I submit an answer for collisions
    Then I should receive feedback on my answer for collisions