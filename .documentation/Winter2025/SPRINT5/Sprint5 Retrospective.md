# **Sprint Review Report**

## **Sprint Overview**

* Sprint Number: 5  
* Sprint Dates: 04/02/25 - 04/25/25

### **Team Members and Roles:**

| Role | Name | Points Completed |
| ----- | ----- | ----- |
| Product Owner (PO) | Dhruv Manihar | 3 |
| Scrum Master (SM) | Kevin Shi | 2 |
| Developer (Dev) | Cooper Calk | 4 |
| Developer (Dev) | Jordan Daryanani | 2 |
| Developer (Dev) | Vivek Somarapu | 7 |
| Developer (Dev) | Nicholas Turoci | 9 |

Total Points Completed: 27  
---

## **Sprint Goal**

Students can manage personal details (email, name, section, teacher). Students can view answers separately from submitting. Teachers can manage/view students by semester, section, email, and see participation/category difficulty statistics.  
---

## **Achievements in the Sprint**

### **Summary of Implemented User Stories:**

1. **Participation Statistics for the Teacher View**  
   * Developer: Nicholas Turoci  
   * Status: Completed  
   * Test Cases: [https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/142](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/142)  
   * Changes Made: Added teacher page to filter by semester, student, category for holistic participation statistics.  
   * Reason for Changes: Enables teachers to track student progress and study effort.  

2. **Settings and Form Field Fix for the Student View**  
   * Developer: Nicholas Turoci  
   * Status: Completed  
   * Test Cases: [https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/131](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/131)  
   * Changes Made: Enhanced settings page for students to update teacher, semester, view name, email.  
   * Reason for Changes: Allows students to manage personal information.  

3. **Category Difficulty Statistic for the Teacher View**  
   * Developer: Nicholas Turoci  
   * Status: Completed  
   * Test Cases: [https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/143](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/143)  
   * Changes Made: Extended teacher page to filter by semester, student, category for correctness statistics.  
   * Reason for Changes: Helps teachers assess student performance on practice problems.  

4. **Manage Students by Semester**  
   * Developer: Vivek Somarapu  
   * Status: Completed  
   * Test Cases: [https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/144](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/144)  
   * Changes Made: Added logic for teachers to filter students by semester and drop all students from a semester.  
   * Reason for Changes: Simplifies student management for current and past semesters.  

5. **Organize Student Statistics by Semester**  
   * Developer: Vivek Somarapu  
   * Status: Completed  
   * Test Cases: [https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/138](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/138)  
   * Changes Made: Implemented logic to generate performance statistics for specific semester filters on student historyPrinciple of the student history dashboard.  
   * Reason for Changes: Enables teachers to view semester-specific performance data.  

6. **Response Grading and Show Answer Logic Fix**  
   * Developer: Cooper Calk  
   * Status: Completed  
   * Test Cases: [https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/139](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/139)  
   * Changes Made: Added View Answer/give up button, saved answers only if correct or student gives up, disabled Check Answer after viewing.  
   * Reason for Changes: Reduces history clutter, allows students to learn from correct answers.  

7. **Adding Teacher**  
   * Developer: Cooper Calk  
   * Status: Completed  
   * Test Cases: [https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/170](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/170)  
   * Changes Made: Added button and page on teacher dashboard to add another teacher with name and email.  
   * Reason for Changes: Simplifies adding new teachers to the database.  

### **Summary of Implemented Chores (bugs & client-requested changes):**

1. **User Friendly Error Handling for Teacher and Student Login**  
   * Developer: Jordan Daryanani  
   * Status: Completed  
   * Test Cases: [https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/140](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/140)  
   * Changes Made: Improved error explanations for OAuth login failures.  
   * Reason for Changes: Enhances usability and reduces login confusion.  

2. **Student Problem History Styling & Navbar Fixes**  
   * Developer: Dhruv Manihar  
   * Status: Completed  
   * Test Cases: [https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/150](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/150)  
   * Changes Made: Minor history styling tweaks, consistent navbar styling.  
   * Reason for Changes: Ensures styling uniformity.  

3. **Sortable Columns Manage Students**  
   * Developer: Dhruv Manihar  
   * Status: Completed  
   * Test Cases: [https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/165](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/165)  
   * Changes Made: Enabled table sorting by column attributes.  
   * Reason for Changes: Improves student management and UI intuitiveness.  

4. **Question ID**  
   * Developer: Nicholas Turoci  
   * Status: Completed  
   * Test Cases: [https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/153](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/153)  
   * Changes Made: Added unique question IDs for each question within categories, updated save answer functions.  
   * Reason for Changes: Enables teachers to filter statistics by unique problems.  

5. **Remove Unneeded Elements from the App**  
   * Developer: Vivek Somarapu  
   * Status: Completed  
   * Test Cases: [https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/136](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/136)  
   * Changes Made: Removed UIN prompting, Art in Engineering category, dashboard button from student view.  
   * Reason for Changes: Client-requested removals for security and relevance.  

6. **Fix Logout to Reset Session Variables**  
   * Developer: Kevin Shi  
   * Status: Completed  
   * Test Cases: [https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/130](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/130)  
   * Changes Made: Restored logout functionality with session variable reset.  
   * Reason for Changes: Fixes accidental removal from previous demo.  

7. **Updated Styling for Student Management Pages, Styling Consistency, Route Fixes**  
   * Developer: Vivek Somarapu  
   * Status: Completed  
   * Test Cases: [https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/155](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/155)  
   * Changes Made: Unified styling for student management pages, secured routes post-deletion.  
   * Reason for Changes: Ensures consistent styling and secure routing.  

8. **Settings Page Fixes, Client and PO Added to DB**  
   * Developer: Nicholas Turoci  
   * Status: Completed  
   * Test Cases: [https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/171](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/171)  
   * Changes Made: Fixed settings view, added client and PO to database.  
   * Reason for Changes: Eliminates bugs, enables client/PO feature access.  

9. **Styling Consistency, Contrast Errors, Problem History Text, Debug Statements**  
   * Developer: Vivek Somarapu  
   * Status: Completed  
   * Test Cases: [https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/160](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/160)  
   * Changes Made: Fixed contrast issues, restyled history page, added time submitted column, removed debug statements.  
   * Reason for Changes: Improves readability, usability, and removes debug artifacts.  

10. **Pi Chart Fixes**  
    * Developer: Nicholas Turoci  
    * Status: Completed  
    * Test Cases: [https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/176](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/176)  
    * Changes Made: Fixed pi chart data refresh to display graphs correctly.  
    * Reason for Changes: Ensures accurate statistics visualization.  

11. **View Answer Warning**  
    * Developer: Cooper Calk  
    * Status: Completed  
    * Test Cases: [https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/178](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/178)  
    * Changes Made: Added confirmation pop-up for viewing answers, disabled button after correct answer.  
    * Reason for Changes: Prevents accidental answer reveals, reduces history clutter.  

12. **Student Answering Question Glitches**  
    * Developer: Jordan Daryanani  
    * Status: Completed  
    * Test Cases: [https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/161](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/161)  
    * Changes Made: Randomized multiple-choice options, updated answer saving, refactored RSpec.  
    * Reason for Changes: Improves user experience and question effectiveness.  

---

## **Sprint Backlog Items, Status, and Testing**

Testing covers: smells, style offenses, and coverage

| Item # | User Story | Status | Notes |
| ----- | ----- | ----- | ----- |
| 1 | Participation Statistics for the Teacher View | Completed | Coding Smells: None, Style Offenses: None, Coverage: ~95% |
| 2 | Settings and Form Field Fix for the Student View | Completed | Coding Smells: None, Style Offenses: None, Coverage: 100% |
| 3 | Category Difficulty Statistic for the Teacher View | Completed | Coding Smells: None, Style Offenses: None, Coverage: ~95% |
| 4 | Manage Students by Semester | Completed | Coding Smells: None, Style Offenses: None, Coverage: ~97% |
| 5 | Organize Student Statistics by Semester | Completed | Coding Smells: None, Style Offenses: None, Coverage: ~97% |
| 6 | Response Grading and Show Answer Logic Fix | Completed | Coding Smells: None, Style Offenses: None, Coverage: ~93% |

---

## **Legacy Code Refactoring**

* Refactored style on every view.  
* Refactored answer submission to account for unique IDs per problem.  
* Refactored settings page for holistic student management (teacher, semester).  
* Refactored answer submission and database saving logic for problem history.  

---

## **Customer Feedback**

* Meeting on 4/24/25 at 1:30 PM, ZACH 424  
  * Client satisfied with website progress and requested changes implemented.  
  * Minor change: Add warning message for "View Answer" to confirm marking as incorrect.  
  * Client requests deployed version for student testing in coming weeks.  

---

## **Testing**

* Smells: None  
* Style Offenses: None  
* Coverage: Cucumber: 65.67%, RSpec: 93.51%, Combined: 95.3%  

---

# Deployment and Environment Setup

## Prerequisites
- **Ruby**: 3.3.4
- **Rails**: 8.0.1

## Setup
Clone the repository:
```bash
$ git clone https://github.com/tamu-edu-students/practice-problem-generator-engr216.git
$ cd practice-problem-generator-engr216
```

Install Dependencies:
```bash
$ bundle install
$ rails db:migrate
$ rails db:seed
```

## Setting up Environment Variables
Create a `.env` file in the root of the project directory. Contact our team for more details.

## View page
```bash
$ rails server
```

## Running Tests
```bash
$ bundle exec rspec
$ bundle exec cucumber
```

## Deployment
```bash
$ heroku login
$ heroku create temp-app
$ git push heroku main
$ heroku run rails db:migrate
$ heroku run rails db:seed
$ heroku open
```
