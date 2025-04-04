# **Sprint Review Report**

## **Sprint Overview**

* Sprint Number: 4  
* Sprint Dates: 03/11/25 \- 04/01/25


### **Team Members and Roles:**

| Role | Name | Points Completed |
| ----- | ----- | ----- |
| Product Owner (PO) | \[Kevin Shi\] | 1 |
| Scrum Master (SM) | \[Dhruv Manihar\] | 1 |
| Developer (Dev) | \[Cooper Calk\] | 5 |
| Developer (Dev) | \[Jordan Daryanani\] | 5 |
| Developer (Dev) | \[Vivek Somarapu\] | 6 |
| Developer (Dev) | \[Nicholas Turoci\] | 6 |

Total Points Completed: 24  
---

## **Sprint Goal**

Students will be able to practice dynamically generating **all** problem categories. Students session variables will be stored when using google OAuth.  
---

## 

## 

## **Achievements in the Sprint**

### **Summary of Implemented User Stories:**

1. \[Create Sessions\]  
   * Developer: Jordan Daryanani  
   * Status: Complete  
   * Test Cases:   
     https://github.com/orgs/tamu-edu-students/projects/87/views/1?pane=issue\&itemId=102594117\&issue=tamu-edu-students%7Cpractice-problem-generator-engr216%7C93  
   * Changes Made: Added generation of students upon login with a valid @tamu email login, as well as checking for UIN / Teacher and allowing users to fill out.  
   * Reason for Changes: More seamless experience for students as well as filling out vital information for function of application.  
2. \[Fixing Cucumber\]  
   * Developer: Kevin Shi  
   * Status: Complete  
   * Test Cases: https://github.com/orgs/tamu-edu-students/projects/87/views/1?pane=issue\&itemId=102595506\&issue=tamu-edu-students%7Cpractice-problem-generator-engr216%7C129  
   * Changes Made: Fixed several Cucumber failures.  
   * Reason for Changes: Some cucumber tests and Rspec tests failed from custom CSS and tailwind styling incongruences.  
3. \[Styling Uniformity\]  
   * Developer: Dhruv Manihar  
   * Status: Complete  
   * Test Cases: https://github.com/orgs/tamu-edu-students/projects/87/views/1?pane=issue\&itemId=102622160\&issue=tamu-edu-students%7Cpractice-problem-generator-engr216%7C105  
   * Changes Made: More consistent styling throughout pages. Added title to login page.  
   * Reason for Changes: Keep a uniform look throughout the website with similar styles and colors.   
4. \[Student History Added with Each Answer Attempt\]  
   * Developer: Cooper Calk  
   * Status: Complete  
   * Test Cases: https://github.com/orgs/tamu-edu-students/projects/87/views/1?pane=issue\&itemId=102594055\&issue=tamu-edu-students%7Cpractice-problem-generator-engr216%7C90  
   * Changes Made: Sent question and answer information to the database when a student submits an answer to a question. Added this history to student history page and to teacher view of a student’s history  
   * Reason for Changes: This allows a student to see what problems they have done and how they did on them, and it allows a teacher to see these things for their students.  
5. \[Measurement & Error\]  
   * Developer: Nicholas Turoci  
   * Status: Complete  
   * Test Cases: [https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/97\#issue-2930318088](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/97#issue-2930318088)   
   * Changes Made: Added a model, controller, view, and testing for the measurement and error physics category. I added functionality to generate infinite physics problems to practice.   
   * Reason for Changes: Students need to practice measurement and error in physics to accurately solve problems and measure variables.   
6. \[Universal Accounting Equation\]  
   * Developer: Cooper Calk  
   * Status: Complete  
   * Test Cases: https://github.com/orgs/tamu-edu-students/projects/87/views/1?pane=issue\&itemId=102594999\&issue=tamu-edu-students%7Cpractice-problem-generator-engr216%7C96  
   * Changes Made: Implemented the problem generator and answer checking for universal accounting equation problems with multiple variations of problem type.  
   * Reason for Changes: Students need to practice universal accounting equation problems with different numbers and variations to get better at solving them.  
7. \[Finite Differences\]  
   * Developer: Vivek Somarapu  
   * Status: Complete  
   * Test Cases: https://github.com/orgs/tamu-edu-students/projects/87/views/1?filterQuery=sprint%3A%22Sprint+4%22+assignee%3A%22vivek-somarapu%22\&pane=issue\&itemId=102594958\&issue=tamu-edu-students%7Cpractice-problem-generator-engr216%7C100  
   * Changes Made: Implemented unlimited problem generation and answer checking for several types of finite differences question types (polynomial, data tables, trig, quadratic, natural log, exponential) with several variations   
   * Reason for Changes: Students need to practice several types of finite differences questions with unlimited versions and attempts for each.  
8. \[Engineering Ethics\]  
   * Developer: Vivek Somarapu  
   * Status: Complete   
   * Test Cases: https://github.com/orgs/tamu-edu-students/projects/87/views/1?filterQuery=sprint%3A%22Sprint+4%22+assignee%3A%22vivek-somarapu%22\&pane=issue\&itemId=102594970\&issue=tamu-edu-students%7Cpractice-problem-generator-engr216%7C95  
   * Changes Made: Implemented problem generation and answer checking with a variety of engineering ethics problems, including questions provided by the client and generated questions inspired by the questions provided by the client.   
   * Reason for Changes: Students should be able to practice core engineering ethics problems provided by the client  
9. \[Particle Statics\]  
   * Developer: Jordan Daryanani  
   * Status: Complete  
   * Test Cases:   
     https://github.com/orgs/tamu-edu-students/projects/87/views/1?pane=issue\&itemId=102594983\&issue=tamu-edu-students%7Cpractice-problem-generator-engr216%7C103  
   * Changes Made:  Implemented problem generation for Particle statistics that allows for checking of questions and dynamic generation. Based on the client’s sent questions.  
   * Reason for Changes: Students are able to test themselves and practice particle statics problems.  
10. \[Propagation of Error\]  
    * Developer: Vivek Somarapu  
    * Status: Complete  
    * Test Cases: https://github.com/orgs/tamu-edu-students/projects/87/views/1?filterQuery=sprint%3A%22Sprint+4%22+assignee%3A%22vivek-somarapu%22\&pane=issue\&itemId=102594967\&issue=tamu-edu-students%7Cpractice-problem-generator-engr216%7C102  
    * Changes Made: Implemented problem generation for several single and multivariable problems, as well as fractional error problems.   
    * Reason for Changes: Students should be able to practice unlimited questions for each major type of error propagation problem type with several variations.   
11. \[Rigid Body Statics\]  
    * Developer: Nicholas Turoci   
    * Status: Complete  
    * Test Cases: [https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/99\#issue-2930367563](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/99#issue-2930367563)   
    * Changes Made: Added a model, controller, view, and testing for the Rigid Body Statics physics category. I added functionality to generate infinite physics problems to practice.   
    * Reason for Changes: Students should be able to view and solve rigid body statics problems to better understand physics and succeed on their final.   
12. \[Harmonic Motion\]  
    * Developer: Nicholas Turoci   
    * Status: Complete  
    * Test Cases: [https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/101\#issue-2930367667](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/101#issue-2930367667)   
    * Changes Made: Added a model, controller, view, and testing for the Harmonic Motion physics category. I added functionality to generate infinite physics problems to practice.   
    * Reason for Changes: Students should be able to solve harmonic motion problems to better understand physics and succeed on their final.   
13. \[Angular Momentum Problem Generation\]  
    * Developer: Jordan Daryanani  
    * Status: Complete  
    * Test Cases:   
      https://github.com/orgs/tamu-edu-students/projects/87/views/1?pane=issue\&itemId=102594711\&issue=tamu-edu-students%7Cpractice-problem-generator-engr216%7C92  
    * Changes Made: Problem generation for students that dynamically generates angular momentum problems. Includes checking if the answer is correct / incorrect and adds them to history.  
    * Reason for Changes: Allows students to test and practice angular momentum problems\!  
14. \[Momentum & Collisions Problem Generations\]  
    * Developer: Cooper Calk  
    * Status: Complete  
    * Test Cases: https://github.com/orgs/tamu-edu-students/projects/87/views/1?pane=issue\&itemId=102594818\&issue=tamu-edu-students%7Cpractice-problem-generator-engr216%7C98  
    * Changes Made: Implemented the problem generator, answer checker, and view for collision problems.  
    * Reason for Changes: These changes were made so students can practice collision problems of different types so they can learn to solve them better.

---

## 

## 

## 

## 

## 

## **Sprint Backlog Items, Status, and Testing**

	Testing covers: smells, style offenses: and coverage

| Item \# | User Story | Status | Notes |
| ----- | ----- | ----- | ----- |
| 1 | Create Sessions | Completed | Coding Smells: None Style Offenses: None Coverage: 85% |
| 2 | Fixing Cucumber | Completed | Coding Smells: N/A Style Offenses: N/A Coverage: 95.37% |
| 3 | Styling Uniformity | Completed | Coding Smells: None Style Offenses: None Coverage: 96% |
| 4 | Student History Added with Each Answer Attempt | Completed | Coding Smells: None Style Offenses: None Coverage: 86.64% |
| 5 | Measurement & Error | Completed | Coding Smells: None Style Offenses: None Coverage: 98% |
| 6 | Universal Accounting Equation | Completed | Coding Smells: None Style Offenses: None Coverage: 100% |
| 7 | Finite Differences | Completed | Coding Smells: None Style Offenses: None Coverage: 100% |
| 8 | Engineering Ethics | Completed | Coding Smells: None Style Offenses: None Coverage: 100% |
| 9 | Particle Statics | Complete | Coding Smells: None Style Offenses: None Coverage: 95.925% |
| 10 | Propagation of Error | Complete | Coding Smells: None Style Offenses: None Coverage: 100% |
| 11 | Harmonic Motion | Complete | Coding Smells: None Style Offenses: None Coverage: 99.6% |
| 12 | Rigid Body Statistics | Complete | Coding Smells: None Style Offenses: None Coverage: 98.75% |
| 13 | Angular Momentum Problem Generation | Complete | Coding Smells: None Style Offenses: None Coverage: 96.14% |
| 14 | Momentum & Collisions Problem Generations | Complete | Coding Smells: None Style Offenses: None Coverage: 94.43% |

---

## **Burn Down Chart**

---

## **Design Diagram**

* No new design diagrams for this sprint, continued from previous. 

---

## **Legacy Code Refactoring** 

* No legacy code was refactored.

---

## **Customer Feedback**

* Meeting on 4/03/25 at 2:15 PM, ZACH 424-F  
  * Customer was pleased with progress made overall from the last demo that was made. Customers want mostly enhancements to previous features implemented. These enhancements include the following:  
    * Customer wanted to see more visuals and better metrics for the student statistics  
    * Customer wanted a semester attribute to student management and statistic pages  
    * Customer wanted to change the grading logic from the student view side.  
  * Some features that we felt were not needed were confirmed with the customer to be removed for the final sprint. The customer also included other things to be removed as well which included the following:  
    * UIN details of the student  
    * Performance table  
    * Art in Engineering problem category

---

## **Testing**

* Smells: N/A  
* Style Offenses: N/A  
* Coverage: 95.38% Rspec \+ Cucumber Line Coverage

---

## **Deployment and Environment Setup**

1. Clone the Repository:

git clone [https://github.com/tamu-edu-students/practice-problem-generator-engr216.git](https://github.com/tamu-edu-students/practice-problem-generator-engr216.git)

