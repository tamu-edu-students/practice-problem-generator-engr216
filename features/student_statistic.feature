Feature: View Student Statistics
  As a teacher
  I want to view student statistics
  So that I can track student performance

  Scenario: View student statistics page
    Given I am on the teacher dashboard
    When I click student statistics
    Then I should be on the student statistics page

  Scenario: View all student statistics
    Given I am on the student statistics page
    Then I should see statistics for all students

  Scenario: View a specific student's statistics
    Given I am on the student statistics page
    When I click on a student
    Then I should see their specific statistics
