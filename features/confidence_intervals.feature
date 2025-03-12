Feature: Confidence Intervals
    As a student
    So that I can practice confidence intervals
    I want a page that dynamically generates confidence interval problems for me to attempt

  Scenario: Generate new Problem
    Given I am on the Confidence Interval Page
    When I click the new confidence interval problem button
    Then a new Confidence Interval problem should be dynamically generated
  Scenario: Answer Submission
    Given I am on the Confidence Interval Page
    When I submit a confidence interval answer
    Then I should be given feedback on my confidence interval answer