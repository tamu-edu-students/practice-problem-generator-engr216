

# Team Bulbasaur Sprint 1 Plan

**Team Roles:**

| Sprint | Scrum Master | Product Owner | Developers |
| :---: | :---: | :---: | :---: |
| 1 | Nick | Vivek | Dhruv, Jordan, Cooper, Kevin |

**Sprint Goal:** Our first sprint we are going to create a deployed web application. It will have a Log-In for students and teachers. Users can navigate between pages.

**Which stories were pulled into the Sprint?**

* Log-In as a Teacher \- 2
Acceptance Criteria

```gherkin
Feature: Log-In
    Scenario: Successful Log In for Teachers
        Given Mary is a teacher in the system
        When Mary attempts to log in with her username and password
        And the credentials are correct
        Then she will successfully enter webpage
    Scenario: Unsuccessful Log In for Students
        Given Nick is not a teacher in the system
        When Nick attempts to log in with a username and password
        And the credentials are incorrect
        Then he will be prompted "Invalid Credentials" and not enter webpage
```

- [ ] coverage &ge; 90%
- [ ] etc.

* Log-In as a Student \- 2
Acceptance Criteria

```gherkin
Feature: Log-In
    Scenario: Successful Log In for Students
        Given John is a student in the system
        When John attempts to log in with his username and password
        And the credentials are correct
        Then he will successfully enter webpage
    Scenario: Unsuccessful Log In for Students
        Given Mike is not a student in the system
        When Mike attempts to log in with a username and password
        And the credentials are incorrect
        Then he will be prompted "Invalid Credentials" and not enter webpage
```

- [ ] coverage &ge; 90%
- [ ] etc. 

* Github Actions \- 2
Acceptance Criteria(Chore)

Rubocop is working, Rspec is working, Cucumber is working, all backend facing

* Deploy Web Page \- 2
Acceptance Criteria (Chore)

    Scenario: MVC and Route Generation
        Given user wants to visit a webpage
        When user visits respective template pages
        Then the page should load that page without errors

    Scenario: Deployment on Heroku
        Given user wants to visit webpage
        When user visits respective Heroku deployment link
        Then the Heroku page should load version in main/master without errors
     
     Scenario: Database
         Given user wants to query the database
         When the user queries the database
         Then the user should be able to view seeded data in the database without errors

- [ ] Basic Ruby generation
- [ ] Heroku Deployment
- [ ] Database setup

* Select Problem Category \- 1
Acceptance Criteria:

```gherkin
  Scenario: View available categories
    Given I am on the practice problem generator page and I am logged in as a student
    Then I see a list of physics categories, including "Mechanics," "Thermodynamics," "Electromagnetism,"  etc.

  Scenario: Select a category and generate problems
    Given I am on the practice problem generator page and I am logged in as a student
    When I select the "Mechanics" category
    And I click on the "Generate Problems" button
    Then I am presented with a set of multiple-choice questions from the "Mechanics" category.
```

- [ ] coverage &ge; 90%

* Return Home from Page \- 1
Acceptance Criteria

```gherkin
Feature: Return Home
    Scenario: Return Home from the Problem's page
        Given I am on the Problem's page
        When I click on the "Home" button 
        Then I should be redirected to the Student Home view

```

- [ ] coverage &ge; 90%
- [ ] etc. 


* View List of Students as a Teacher \- 1
Acceptance Criteria

```gherkin
Feature: View List of Students as Teacher
    Scenario: Access list of students from the Teacher's home page
        Given I am logged in as a teacher user
        And I am on the teacher Home Page
        When I navigate to the "Students" section
        Then I should see a list of all student users
```

- [ ] coverage &ge; 90%
- [ ] etc. 



**How many points were pulled into the Sprint?**

* 11

**Which Stories are the 4 Developers starting with, and what are their time estimates / points?**

* Kevin   
  * **Deployment**, 1 day work time, setting up environment deployment and deployment to Heroku. 
      
* Jordan   
  * **Log-In as a Student**, 3 days work time, have to add google oauth, @tamu sso, middleware, detecting student vs teacher  
  * Acceptance Criteria:   
    Feature: Log-In  
        Scenario: Successful Log In for Students  
            Given John is a student in the system  
            When John attempts to log in with his username and password  
            And the credentials are correct  
            Then he will successfully enter webpage  
        Scenario: Unsuccessful Log In for Students  
            Given Mike is not a student in the system  
            When Mike attempts to log in with a username and password  
            And the credentials are incorrect  
            Then he will be prompted "Invalid Credentials" and not enter webpage  
*  coverage ≥ 90%


* Cooper  
  * **Select Problem Category**, 3 days work time, have to create front end page for student with dummy buttons and categories based on info from client  
  * Acceptance Criteria:   
    Feature: Select Problem Category  
    Scenario: View available categories  
        Given I am on the practice problem generator page and I am logged in as a student  
        Then I see a list of physics categories, including "Mechanics," "Thermodynamics," "Electromagnetism,"  etc.  
      
      Scenario: Select a category and generate problems  
        Given I am on the practice problem generator page and I am logged in as a student  
        When I select the "Mechanics" category  
        And I click on the "Generate Problems" button  
        Then I am presented with a set of multiple-choice questions from the "Mechanics" category.  
      
*  coverage ≥ 90%  
* Dhruv   
  * **Github Action**, 3 days work time, adding automation for test coverage checking, rubocop, rspec, cucumber, commit deployment, etc.  
  * Acceptance Criteria: Rubocop is working, Rspec is working, Cucumber is working, all backend facing

**Links:**

* Github Repo \-[https://github.com/tamu-edu-students/practice-problem-generator-engr216](https://github.com/tamu-edu-students/practice-problem-generator-engr216)  
* Github Project Board \- [https://github.com/orgs/tamu-edu-students/projects/87](https://github.com/orgs/tamu-edu-students/projects/87)  
* Slack Channel \- [https://join.slack.com/t/teambulbasaur431/shared\_invite/zt-2xqwi5eld-TGti6LUVSiQfk7aAkST5Ew](https://join.slack.com/t/teambulbasaur431/shared_invite/zt-2xqwi5eld-TGti6LUVSiQfk7aAkST5Ew)
