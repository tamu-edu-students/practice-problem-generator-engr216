Feature: Generate Problems

    As a Student
    So that I can do practice problems in a certain category
    I want to generate a practice problem for that category.
  
    Scenario: View generate problem page
        Given I am on the select problem category page
        When I select a category
        Then I should be on the generate problem page
    Scenario: Generate a problem
        Given I am on the generate problems page
        When I click generate problem
        Then I should see a problem
    Scenario: Generate a different problem
        Given I am on the generate problems page
        And I have already generated a problem
        When I click generate problem
        Then I should see a different problem
    Scenario: Select different category
        Given I am on the generate problems page
        When I click change category
        Then I should be on the select problem category page