@history
Feature: Teacher Views Student Problem History
  As a teacher
  I want to access and view a student's problem history
  So that I can track their progress and issues

  Scenario: Access Student Statistics Page
    Given I am on the Teacher Dashboard page
    When I click the "Student Statistics & History" button
    Then I should be brought to the student statistics page

  Scenario: View Student's Past Problems
    Given I am on the student statistics page
    When I click on a student’s name
    Then I should see a summary of the student's past problems