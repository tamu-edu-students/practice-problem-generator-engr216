Feature: Filter Student Statistics by Semester
  As a teacher
  I want to filter student statistics by semester
  So that I can analyze class performance for specific academic terms

  Background:
    Given I am logged in as a teacher
    And I have a semester named "Fall 2024"
    And I have students enrolled in "Fall 2024"
    And I am on the student history dashboard

  Scenario: View statistics for all semesters
    When I select "All Semesters" from the semester dropdown
    Then I should see statistics for students across all semesters

  Scenario: Filter statistics by specific semester
    When I select "Fall 2024" from the semester dropdown
    Then I should see statistics only for students in "Fall 2024"
    And the class performance data should reflect only "Fall 2024" students

  Scenario: View individual student history with semester filter
    When I select "Fall 2024" from the semester dropdown
    And I click on a student name
    Then I should see that student's history filtered for "Fall 2024"
    And the back button should maintain the semester filter

  Scenario: Search within a semester filter
    When I select "Fall 2024" from the semester dropdown
    And I search for "Smith" in the search field
    Then I should see only "Fall 2024" students with "Smith" in their name or email
    And the semester filter should be maintained