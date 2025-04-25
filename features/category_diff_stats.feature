Feature: Category Difficulty Statistics and Visualization

  As a teacher
  I want to see which categories are hardest and easiest for students
  So that I can focus instruction and review where it's most needed

  Background:
    Given I am logged in as a teacher
    And I have a semester named "Fall 2024"
    And I am on the student history dashboard
    And I have selected "All" for both student and category

  Scenario: Show hardest and easiest categories
    Then I should see a per-category difficulty breakdown
    And each category should show a total number of problems
    And each section should reflect overall student performance

  Scenario: Visualize category difficulty
    Then I should see one bar chart for attempted per category
    And I should see one bar chart for correct per category
    And each bar should represent a specific category

  Scenario: Display difficulty stats instead of old table
    Then I should not see a performance summary table
    And I should see category-level difficulty charts instead
