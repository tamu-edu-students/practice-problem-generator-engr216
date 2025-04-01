# Team Bulbasaur Sprint 4 Plan

**Team Roles:**

| Sprint | Scrum Master | Product Owner | Developers |
| :---: | :---: | :---: | :---: |
| 4 | Dhruv | Kevin | Nick, Vivek, Kevin, Cooper, Jordan |

**Sprint Goal:**  Students will be able to practice dynamically generating all problem categories. Students session variables will be stored when using google OAuth. 

**Which stories were pulled into the Sprint?**

* Create Sessions \- 1  
* Fixing Cucumber \- 1  
* Styling Uniformity \- 1
* Student History Added with Each Answer Attempt \- 1  
* Measurement & Error \- 2  
* Universal Counting Equation \- 2  
* Finite Differences \- 2  
* Engineering Ethics \- 2   
* Particle Statics \- 2  
* Propagation of Error \- 2  
* Harmonic Motion \- 2  
* Rigid Body Statistics \- 2  
* Angular Momentum Problem Generation \- 2  
* Momentum & Collisions Problem Generations \- 2

**How many points were pulled into the Sprint?**

* 24

**Which Stories are the 4 Developers starting with, and what are their time estimates / points?**

* Jordan **\- Create Sessions**  
  * Setup/write Cucumber & Rspec tests \- 2 hr  
  * Implement session \- 3 hr  
  * Implement session check \- 3 hr  
  * Acceptance Criteria:

	Feature: Student Session Variables for Problem Generator  
  As a student  
  I want session variables tied to my user account  
  So that I can manipulate them across different features

  Scenario: Create a new session with variables  
    Given I am on the Problem Dashboard page as a logged-in student  
    When I select a problem type and start a session  
    Then a new session should be created with variables tied to my account

* Vivek \- **Engineering Ethics**  
  * Write at least 10 engineering ethics problems \- 1 hr  
  * Implement logic for question generation and answer verification \- 1 hr  
  * Acceptance Criteria:  
      
    Feature: Engineering Ethics Problem Generator  
      As a student  
      I want a page that dynamically generates engineering ethics problems for me to attempt  
      So that I can practice engineering ethics  
      
      Scenario: Generate new Problem  
        Given I am on the "Engineering Ethics" page  
        When I click the "new problem" button  
        Then a new "Engineering Ethics" problem should be dynamically generated  
      
      Scenario: Answer Submission  
        Given I am on the "Engineering Ethics" page  
        When I submit an answer  
        Then I should receive feedback on my answer

* Nick \- **Measurement & Error**   
  * Write at least 10 problems \- 1 hr  
  * Implement logic for question generation and answer verification \- 1 hr  
  * Acceptance Criteria:

  Feature: Measurement & Error Problem Generator

    As a student

    I want a page that dynamically generates measurement and error problems for me to attempt

    So that I can practice measurement and error


    Scenario: Generate new Problem

      Given I am on the "Measurement & Error" page

      When I click the "new problem" button

      Then a new "Measurement & Error" problem should be dynamically generated


    Scenario: Answer Submission

      Given I am on the "Measurement & Error" page

      When I submit an answer

      Then I should receive feedback on my answer


* Cooper \- **Universal Accounting Equation**   
  * Write at least 10 problems \- 1 hr  
  * Implement logic for question generation and answer verification \- 1 hr  
  * Acceptance criteria:

    Feature: Universal Accounting Equation Problem Generator

      As a student

      I want a page that dynamically generates universal accounting equation problems for me to attempt

      So that I can practice the universal accounting equation

    

      Scenario: Generate new Problem

        Given I am on the "Universal Accounting Equation" page

        When I click the "new problem" button

        Then a new "Universal Accounting Equation" problem should be dynamically generated

    

      Scenario: Answer Submission

        Given I am on the "Universal Accounting Equation" page

        When I submit an answer

        Then I should receive feedback on my answer

**Links:**

* Github Repo \-[https://github.com/tamu-edu-students/practice-problem-generator-engr216](https://github.com/tamu-edu-students/practice-problem-generator-engr216)  
* Github Project Board \- [https://github.com/orgs/tamu-edu-students/projects/87](https://github.com/orgs/tamu-edu-students/projects/87)  
* Slack Channel \- [https://join.slack.com/t/teambulbasaur431/shared\_invite/zt-2xqwi5eld-TGti6LUVSiQfk7aAkST5Ew](https://join.slack.com/t/teambulbasaur431/shared_invite/zt-2xqwi5eld-TGti6LUVSiQfk7aAkST5Ew)