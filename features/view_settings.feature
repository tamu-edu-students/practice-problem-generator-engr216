Feature: View Settings Page

  As a student,
  So that I can change settings for the application,
  I want to visit a settings page from the student home page.

  Scenario: See settings page button
    Given I am on the student dashboard and I am logged in as a student
    Then I should see a settings button.

  Scenario: Navigate to the settings page
    Given I am on the student dashboard and I am logged in as a student
    When I click the settings button
    Then I should be on a page where I can see and edit my settings.

  Scenario: Navigate home from the settings page
    Given I am on the student settings page and I am logged in as a student
    When I click the Problem Select button
    Then I should be on the student dashboard.