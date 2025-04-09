

# Team Bulbasaur Sprint 5 Plan

**Team Roles:**

| Sprint | Scrum Master | Product Owner | Developers |
| :---: | :---: | :---: | :---: |
| 1 | Nick | Vivek | Dhruv, Jordan, Cooper, Kevin |
| 2 | Jordan | Cooper | Dhruv, Nick, Vivek, Kevin |
| 2 | Cooper | Jordan | Dhruv, Nick, Vivek, Kevin |
| 4 | Dhruv | Kevin | Jordan, Nick, Vivek, Cooper |
| 5 | Kevin | Dhruvn | Jordan, Nick, Vivek, Cooper |

### Sprint Goal
Students will be able to manage details about themselves including email, full name, section, and teacher. Students will be able to effectively view answers as a separate function from submitting their answer.
Teachers will be able to manage and view students by new attributes such as semester, section, and email. Teachers will be able to see participation and category difficulty statistics.
<br>


**Which stories were pulled into the Sprint?**

| Name                               | Assigned   | Points | Acceptance Criteria                                                                                                             |
|------------------------------------|------------|--------|---------------------------------------------------------------------------------------------------------------------------------|
| Settings and Form Field Fix for the Student View (chore)           |  Nick  | 2      | [Acceptance Criteria]()                                                                       |
| Remove Unneeded Elements from App (chore)         |  Vivek  | 1      | [Acceptance Criteria]()                                                                         |
| User Friendly Error Handling for Teacher and Student Login (chore)              |  Jordan  | 1      | [Acceptance Criteria]()                                                                                                       |
| Response Grading and Show Answer Logic Fix (chore)               |  Cooper  | 2      | [Acceptance Criteria]()                                                |
|  Rspec & Cucumber Testing Fixes (chore) | Kevin  | 1      | [Acceptance Criteria]()                                                                                                       |
| Participation Statistics for the Teacher View        |    | 2      | [Acceptance Criteria]()                                                                                                       |
| Category Difficulty Statistic for the Teacher View          |    | 2      | [Acceptance Criteria]()                                                                                                       |           
| Organize Student Statistics by Semester |   | 2 | [Acceptance Criteria]() |
| Manage Students by Semester |   | 2 | [Acceptance Criteria]() |
|
| Total Points|    | 15      |                                                                                                      |





**Which Stories are the 4 Developers starting with, and what are their time estimates / points?**
 
* Nick   
  * **Settings and Form Field Fix for the Student View (chore)r**, 2.5 Hours
     * Tests - 1 HR
     * Create migration to semester attributes to student - 0.5hr
     * Fix Teacher Authentication Functionality - 0.5hr
     * Adjust view, controller, and model to use email and section  - 1hr
     * Change the settings page to match the form field - 1hr

* Vivek  
  * **Remove Unneeded Elements from App (chore)**, 3 Hours
     * Remove UIN dependency from MVC across the application - 2 hrs
     * Remove Art in Engineering - 0.5 hr
     * Remove Dashboard button  - 0.5 hr

* Jordan   
  * **User Friendly Error Handling for Teacher and Student Login (chore)**, 3 Hours
     * Tests - 0.5 hr
     * Write controller logic to redirect false teachers to the login page - 1 hr
     * Create response in the view stating the error - 2 hrs
     
* Cooper 
  * **Response Grading and Show Answer Logic Fix (chore)**, 7 Hours
     * Tests - 1 hr
     * Alter existing submit buttons to grade the response but not show the answer for all category pages - 3 hrs
     * Add a button to reveal an answer that shows the answer but disallows any more responses for all category pages - 3 hrs

**Links:**

* Github Repo \-[https://github.com/tamu-edu-students/practice-problem-generator-engr216](https://github.com/tamu-edu-students/practice-problem-generator-engr216)  
* Github Project Board \- [https://github.com/orgs/tamu-edu-students/projects/87](https://github.com/orgs/tamu-edu-students/projects/87)  
* Slack Channel \- [https://join.slack.com/t/teambulbasaur431/shared\_invite/zt-2xqwi5eld-TGti6LUVSiQfk7aAkST5Ew](https://join.slack.com/t/teambulbasaur431/shared_invite/zt-2xqwi5eld-TGti6LUVSiQfk7aAkST5Ew)
* Deployment Link \-[https://whispering-reaches-02252-73f884c5e5f0.herokuapp.com/login](https://whispering-reaches-02252-73f884c5e5f0.herokuapp.com/login)
