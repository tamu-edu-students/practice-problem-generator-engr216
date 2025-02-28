Feature: Select Teacher as Student 
  
    As a Student
    So that my teacher can see my progress
    I want to chose my teacher.
  
    Scenario: Access Setting
        Given I am on Settings Page
        Then I should see a dropdown input that allows me to select a teacher to link my account to
    Scenario: Link Student in Database
        Given I am on the Settings Page
        When I select a teacher from the dropdown input
        And I save my settings
        Then I should be linked to the teacher through the database.