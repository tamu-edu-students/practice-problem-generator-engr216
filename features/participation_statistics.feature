Feature: Participation Statistics and Visuals

  As a teacher
  I want to see how many problems students have completed
  So that I can understand participation levels across my class

  Background:
    Given I am logged in as a teacher
    And I am on the student history dashboard
    And I have selected "All" for both student and category

  Scenario: View percentage statistics of student participation
    Then I should see total completed, correct, and incorrect
    And I should see bar charts labeled "Attempted" and "Correct"

  Scenario: View holistic participation grouped by attempt ratio
    Then I should see participation grouped by percentage buckets
    And I should see labels like "<25%", "25–50%", "50–75%", "75–99%", and "100%"

  Scenario: View per-category participation bucket stats
    Then I should see a per-category breakdown
    And each category card should display attempted and correct bar charts

  Scenario: Layout includes visual charts together
    Then the participation layout should display both summary stats and charts side by side
