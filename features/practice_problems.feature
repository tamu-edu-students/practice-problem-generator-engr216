Feature: Select Category and Generate Problems

  As a student preparing for physics exams,
  So that I can focus on specific areas of physics I need to improve on,
  I want to select the category of practice problems to generate targeted multiple choice questions.

  Scenario: View available categories
    Given I am on the practice problem generator page and I am logged in as a student
    Then I see a list of physics categories, including "Mechanics" "Thermodynamics" "Electromagnetism"  etc.

  Scenario: Select a category and generate problems
    Given I am on the practice problem generator page and I am logged in as a student
    When I select the "Mechanics" category
    And I click on the "Generate Problems" button
    Then I am presented with a set of multiple-choice questions from the "Mechanics" category.

