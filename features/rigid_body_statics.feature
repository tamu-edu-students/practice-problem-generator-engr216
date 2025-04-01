Feature: Rigid Body Statics Problem Generator
  As a student
  I want a page that dynamically generates rigid body statics problems for me to attempt
  So that I can practice rigid body statics

  Scenario: Generate new Problem
    Given I am on the "Rigid Body Statics" page for bodies
    When I click the "new problem" button for bodies
    Then a new "Rigid Body Statics" problem should be dynamically generated

  Scenario: Answer Submission
    Given I am on the "Rigid Body Statics" page for bodies
    When I submit a Rigid Body Statics answer
    Then I should receive feedback on my Rigid Body Statics answer