Feature: Add New Teacher from Dashboard

  As a teacher
  I want to add another teacher to the system
  So that they can access and use the platform with their own login

  Background:
    Given I am logged in as a teacher
    And I am on the teacher dashboard

  Scenario: Open popup to add a new teacher
    When I click the "Add New Teacher" button
    Then I should be on the add teacher page
    And the form should include fields for name and email

  Scenario: Successfully add a new teacher
    Given I am on the add teacher page
    And I fill in "Name" with "Jane Doe"
    And I fill in "Email" with "jane.doe@tamu.edu"
    And I click "Create Teacher"
    Then the new teacher should be added to the database
    And I should see a confirmation message
    And I should be on the teacher dashboard

  Scenario: Submit form with missing required fields
    Given I am on the add teacher page
    When I leave one or more fields blank
    And I click "Create Teacher"
    Then I should see error messages
    And the teacher should not be added