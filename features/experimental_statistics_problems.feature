Feature: Experimental Statistics Problems

    As a student
    So that I can practice experimental statistics
    I want a page that dynamically generates experimental statistics problems for me to attempt

    Scenario: Generate new Problem
        Given I am on the Experimental Statistics Page
        When I click the new experimental statistics problem button
        Then a new Experimental Statistics problem should be dynamically generated
    Scenario: Answer Submission
        Given I am on the Experimental Statistics Page
        When I submit an experimental statistics answer
        Then I should be given feedback on my experimental statistics answer
    