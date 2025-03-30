Feature: Measurement & Error Problem Generator
  As a student
  I want a page that dynamically generates measurement and error problems for me to attempt
  So that I can practice measurement and error

  Scenario: Generate new Problem
    Given I am on the measurement and error page
    When I click the measurement error "Generate New Problem" button
    Then a new measurement error problem should be dynamically generated

  Scenario: Answer Submission
    Given I am on the measurement and error page
    When I select a measurement answer and submit the form
    Then I should receive measurement feedback

