Feature: Practice Problem Dashboard
    As a Student
    So that I can see practice problems
    I need a dashboard to view all practice problems.

    Scenario: View problem dashboard
        Given I am on the log in page
        When I log in as a student
        Then I should be on the practice problems.
    Scenario: No access if not student
        I am not logged in as a student
        When I navigate to the dashboard link
        Then I should not be on the problem dashboard