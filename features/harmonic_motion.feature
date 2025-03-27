Feature: Harmonic Motion Problem Generator
  As a student
  I want a page that dynamically generates harmonic motion problems for me to attempt
  So that I can practice harmonic motion

  Scenario: Generate new Problem
    Given I am on the Harmonic Motion Problem Generator page
    When I click the New Problem button
    Then a new Harmonic Motion problem should be dynamically generated

  Scenario: Answer Submission
    Given I am on the Harmonic Motion Problem Generator page
    When I submit a Harmonic Motion answer
    Then I should receive feedback on my Harmonic Motion answer
