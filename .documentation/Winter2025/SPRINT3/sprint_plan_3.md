

# Team Bulbasaur Sprint 3 Plan

**Team Roles:**

| Sprint | Scrum Master | Product Owner | Developers |
| :---: | :---: | :---: | :---: |
| 1 | Nick | Vivek | Dhruv, Jordan, Cooper, Kevin |
| 2 | Jordan | Cooper | Dhruv, Nick, Vivek, Kevin |
| 2 | Cooper | Jordan | Dhruv, Nick, Vivek, Kevin |


### Sprint Goal
Students will be able to practice dynamically generated Confidence Interval and Experimental Statistics problems. Teachers will be able to see what problems their students have finished. Students will be able to select their teacher. <br>


**Which stories were pulled into the Sprint?**

| Name                               | Assigned   | Points | Acceptance Criteria                                                                                                             |
|------------------------------------|------------|--------|---------------------------------------------------------------------------------------------------------------------------------|
| Create Database Schema           |  Nick  | 2      | [Acceptance Criteria](https://github.com/orgs/tamu-edu-students/projects/87/views/1?pane=issue&itemId=98971555&issue=tamu-edu-students%7Cpractice-problem-generator-engr216%7C60)                                                                       |
| Experimental Statistics Problems         |  Vivek  | 2      | [Acceptance Criteria](https://github.com/orgs/tamu-edu-students/projects/87/views/1?pane=issue&itemId=98971573&issue=tamu-edu-students%7Cpractice-problem-generator-engr216%7C61)                                                                         |
| Confidence Interval Problems              |    | 2      | [Acceptance Criteria](https://github.com/orgs/tamu-edu-students/projects/87/views/1?pane=issue&itemId=98971575&issue=tamu-edu-students%7Cpractice-problem-generator-engr216%7C62)                                                                                                       |
| Teacher Can View Student History               |  Kevin  | 2      | [Acceptance Criteria](https://github.com/orgs/tamu-edu-students/projects/87/views/1?pane=issue&itemId=98971594&issue=tamu-edu-students%7Cpractice-problem-generator-engr216%7C64)                                                |
| Add Back Buttons |    | 1      | [Acceptance Criteria](https://github.com/orgs/tamu-edu-students/projects/87/views/1?pane=issue&itemId=98971610&issue=tamu-edu-students%7Cpractice-problem-generator-engr216%7C66)                                                                                                       |
| Teacher Can View Overall Class Performance        |    | 2      | [Acceptance Criteria](https://github.com/orgs/tamu-edu-students/projects/87/views/1?pane=issue&itemId=98971604&issue=tamu-edu-students%7Cpractice-problem-generator-engr216%7C65)                                                                                                       |
| Students Choose a Teacher          |  Dhruv  | 1      | [Acceptance Criteria](https://github.com/orgs/tamu-edu-students/projects/87/views/1?pane=issue&itemId=98971583&issue=tamu-edu-students%7Cpractice-problem-generator-engr216%7C63)                                                                                                       |                                                                                                  |
| Total Points|    | 12      |                                                                                                      |





**Which Stories are the 4 Developers starting with, and what are their time estimates / points?**
 
* Dhruv   
  * **Students Choose Teacher**, 2.5 Hours
     * Tests - 1 HR
        * Button logic - 30 min
        * Database test - 30 min
     * UI Design - 30 min
     * Backend logic - 1 HR
        * Database interaction - 30 min
        * Routing logic - 30 min

* Vivek  
  * **Experimental Statistics Problems**, 4 Hours
     * Design problem page layout specifically for experimental statistics problems - 30 Minutes
     * Write logic to generate unlimited experimental statistics problems - 3.5 Hours
        * Implement templates for statistics questions - 2 HR
        * Logic for new variable generation - 1 HR
        * Log for answer verification - 30 min

* Nick   
  * **Create Database Schema**, 2.5 Hours
     * Map out database features and needs - 1 HR
        * Students - 20 min
        * Teachers - 20 min
        * Problems - 20 min
     * Approve database with team - 30 min
     * Implement database in Ruby and Heroku - 1 Hours
     
* Kevin   
  * **Teacher Can View Student History**, 8 Hours
     * 
     * Setup and write Cucumber and Rspec - 2 HR
     * Write migration and seeds for database schema for aggregated statistics - 1 HR
     * Connect student view problem buttons to database statistics table - 1 HR
     * Create student statistics page with students and the statistics view - 2 HR
     * Create graphic representation of student statistics - 1 HR
     * Add category, correctness, and other attributes to student statistics - - 1 HR

**Links:**

* Github Repo \-[https://github.com/tamu-edu-students/practice-problem-generator-engr216](https://github.com/tamu-edu-students/practice-problem-generator-engr216)  
* Github Project Board \- [https://github.com/orgs/tamu-edu-students/projects/87](https://github.com/orgs/tamu-edu-students/projects/87)  
* Slack Channel \- [https://join.slack.com/t/teambulbasaur431/shared\_invite/zt-2xqwi5eld-TGti6LUVSiQfk7aAkST5Ew](https://join.slack.com/t/teambulbasaur431/shared_invite/zt-2xqwi5eld-TGti6LUVSiQfk7aAkST5Ew)
* Deployment Link \-[https://whispering-reaches-02252-73f884c5e5f0.herokuapp.com/login](https://whispering-reaches-02252-73f884c5e5f0.herokuapp.com/login)
