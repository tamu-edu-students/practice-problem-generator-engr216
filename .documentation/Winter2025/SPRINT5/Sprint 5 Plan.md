

# Team Bulbasaur Sprint 5 Plan

**Team Roles:**

| Sprint | Scrum Master | Product Owner | Developers |
| :---: | :---: | :---: | :---: |
| 5 | Kevin | Dhruv | Jordan, Nick, Vivek, Cooper |

**Sprint Goal:** 

- Students will be able to manage details about themselves including email, full name, section, and teacher. Students will be able to effectively view answers as a separate function from submitting their answer.  
- Teachers will be able to manage and view students by new attributes such as semester, section, and email. Teachers will be able to see participation and category difficulty statistics.

**Which stories were pulled into the Sprint?**

* Rspec & Cucumber Testing Fixes (chore) \- 2  
* Logout Session Variable Reset and Redirection Fix (chore) \- 2  
* User Friendly Error Handling for Teacher and Student Login (chore) \- 2  
* Response Grading and Show Answer Logic Fix (chore) \- 2  
* Settings and Form Field Fix for the Student View (chore) \- 2  
* Remove Unneeded Elements from App (chore) \- 2   
* Participation Statistics for the Teacher View \- 3  
* Category Difficulty Statistic for the Teacher View \- 2  
* Organize Students by Semester \- 3

**How many points were pulled into the Sprint?**

* 20 

**Which Stories are the 4 Developers starting with, and what are their time estimates / points?**

* Jordan \- **Settings and Form Field Fix for the Student View (chore)** \- 2.5 hrs  
  * Create migration to add email and section attributes to student \- 0.5hr   
  * Adjust view, controller, and model to use email and section 1hr  
  * Change the settings page to match the form field \- 1hr  
  * *Acceptance Criteria*  
    * *All scenarios passing using Cucumber testing*  
    * *Code Coverage does not go down*  
* Vivek \- **Remove Unneeded Elements from App (chore)** \- 3.5 hours  
  * Remove UIN dependency from MVC across the application \- 2 hrs  
  * Create a migration to remove UIN from the app’s DB schema \- 0.5 hr  
  * Remove Art in Engineering \- 0.5 hr  
  * Remove Dashboard button  \- 0.5 hr  
  * *Acceptance Criteria*  
    * *All scenarios still passing using Cucumber testing*  
    * *Code Coverage does not go down*  
* Nick \- **Logout Session Variable Reset and Redirection Fix (chore)** \- 3hrs  
  * Write controller logic that resets session variables \- 2hrs  
  * Write controller logic that redirects logout page to login page \- 1hr  
  * *Acceptance Criteria*  
    * *All scenarios passing using Cucumber testing*  
    * *Code Coverage does not go down*  
* Cooper \- **Response Grading and Show Answer Logic Fix (chore)** \- 7 hrs  
  * Alter existing submit buttons to grade the response but not show the answer for all category pages \- 3 hrs  
  * Add a button to reveal an answer that shows the answer but disallows any more responses for all category pages \- 4 hrs  
  * *Acceptance Criteria*  
    * *All scenarios passing using Cucumber testing*  
    * *Code Coverage does not go down*  
* Dhruv \- **User Friendly Error Handling for Teacher and Student Login (chore)** \- 3 hrs  
  * Write controller logic to redirect false teachers to the login page \- 1 hr  
  * Create response in the view stating the error \- 2 hrs  
    * *All scenarios passing using Cucumber testing*  
    * *Code Coverage does not go down*  
* Kevin \-  **Rspec & Cucumber Testing Fixes (chore)** \- 10 hrs  
  * Write missing tests in Rspec and Cucumber \- 3 hrs  
  * Fix remaining tests in Rspec and Cucumber \- 6 hrs  
  * Remove extraneous Rspec tests that belong as Cucumber tests \- 1 hr  
    * *All scenarios passing using Cucumber testing*  
    * *Code Coverage improves*

**Links:**

* Github Repo \-[https://github.com/tamu-edu-students/practice-problem-generator-engr216](https://github.com/tamu-edu-students/practice-problem-generator-engr216)  
* Github Project Board \- [https://github.com/orgs/tamu-edu-students/projects/87](https://github.com/orgs/tamu-edu-students/projects/87)  
* Slack Channel \- [https://join.slack.com/t/teambulbasaur431/shared\_invite/zt-2xqwi5eld-TGti6LUVSiQfk7aAkST5Ew](https://join.slack.com/t/teambulbasaur431/shared_invite/zt-2xqwi5eld-TGti6LUVSiQfk7aAkST5Ew)

