Feature: Manage Student Page for Teacher
    As a teacher
    So that I can see how students are doing
    I want to see a manage students page where I can view all students

     Scenario: View student management page
        Given I am on the teacher dashboard
        When I click student management
        Then I should be on the student management page
    Scenario: View list of students
        Given I am on the student management page
        Then I should see all of the students
    Scenario: Manage a student
        Given I am on the student management page
        When I click on a student
        Then I should see their information
        And I should be able to edit their information