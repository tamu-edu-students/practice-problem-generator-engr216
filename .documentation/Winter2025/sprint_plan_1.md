

# Team Bulbasaur Sprint 1 Plan

**Team Roles:**

| Sprint | Scrum Master | Product Owner | Developers |
| :---: | :---: | :---: | :---: |
| 1 | Nick | Vivek | Dhruv, Jordan, Cooper, Kevin |

**Sprint Goal:** Our first sprint we are going to create a deployed web application. It will have a Log-In for students and teachers. Users can navigate between pages.

**Which stories were pulled into the Sprint?**

* Log-In as a Teacher \- 2  
* Log-In as a Student \- 2  
* Github Actions \- 2  
* Deploy Web Page \- 2  
* Select Problem Category \- 1  
* Return Home from Page \- 1  
* View List of Students as a Teacher \- 1

**How many points were pulled into the Sprint?**

* 11

**Which Stories are the 4 Developers starting with, and what are their time estimates / points?**

* Kevin   
  * **Deployment**, 1 day work time, setting up environment deployment and deployment to Heroku.  
  * Acceptance Criteria:   
      
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
