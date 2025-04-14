Feature: Organize Students by Semester

  As a teacher
  I want to organize students by semester
  So that I can easily manage and view student records by term

  Background:
    Given I am logged in as a teacher
    And I am on the student management page

  Scenario: View students grouped by semester
    When I select the "Group by Semester" option
    Then I should see students grouped under their respective semesters

  Scenario: Switch between semesters
    Given students are grouped by semester
    When I select "Fall 2024" from the semester dropdown
    Then I should see only students enrolled in Fall 2024

  Scenario: Students without a semester
    When a student does not have a semester assigned
    Then they should appear under a "No Semester Assigned" section
    
  Scenario: Delete all students in a semester
    Given there are students in the "Fall 2024" semester
    When I select "Fall 2024" from the semester dropdown
    And I click the "Drop All Students in Fall 2024" button
    Then all students in the "Fall 2024" semester should be deleted 