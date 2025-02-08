  Feature: Only Teachers Navigate Dashboard 

  Scenario: View teacher dashboard
    Give there exists a teacher
    And I am on the log in page
    When I log in as a teacher
    Then I should be on the teacher dashboard

  Scenario: No access if not teacher
    Given I am not logged in
    When I navigate to the teacher dashboard link
    Then I should not be on the teacher dashboard