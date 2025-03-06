Feature: Back Button

    As a User
    So that I can easily navigate the website
    I want back buttons that help me navigate between pages.

    Scenario: Individual Student Page Back Button
        Given I am on the Show Page for Individual Student Management 
        When I click the Back button
        Then I should be brought back to the Student Management Page
    Scenario: Student Management Page Back Button
        Given I am on the Student Management Page 
        When I click the Back button on this page
        Then I should be brought back to the Teacher dashboard