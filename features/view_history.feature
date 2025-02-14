Feature: View History Page

    As a Student
    So that I can get feedback on my progression
    I want to visit a feedback page from the student home page

   Scenario: View history page
    Given I am on the student dashboard
    When I select the history button
    Then I should be on the history page

  Scenario: View problem history
    Given I am on the history page
    Then I should see problems I have done
    And I should see how I did on them
    
  Scenario: Go home from history page
    Given I am on the history page
    When I click the Problem Select button on the history page
    Then I should be on the student dashboard