Feature: Form and Settings Field Behavior

  As a student
  I want to update my profile information
  So that my data is accurate and I can continue using the system properly

  Background:
    Given I am logged in as a student on settings test
    And I am on my profile or settings page

  Scenario: Semester field is optional
    When I view my profile
    Then I should see the "Semester" field
    And I should be able to save my profile without filling it in

  Scenario: Email field is optional
    When I view my profile
    Then I should see the "Email" field
    And I should be able to save my profile without entering an email

  Scenario: Updating my teacher saves the change
    When I change my assigned teacher from the dropdown
    And I click "Save"
    Then my new teacher should be saved in the system

  Scenario: Updating my semester saves the change
    When I select a different semester from the dropdown
    And I click "Save"
    Then my new semester should be saved in the system
