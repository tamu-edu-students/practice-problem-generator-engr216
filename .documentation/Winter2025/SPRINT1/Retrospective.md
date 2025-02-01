# Sprint Review Report

## Sprint Overview

- **Sprint Number:** 1
- **Sprint Dates:** 01/10/25 - 01/24/25
  
### Team Members and Roles:

| Role               | Name              | Points Completed |
|--------------------|-------------------|------------------|
| Product Owner (PO) | Vivek Somarapu            | N/A              |
| Scrum Master (SM)  | Nicholas Turoci            | N/A              |
| Developer (Dev)    | Dhruv Manihar| 2         |
| Developer (Dev)    | Kevin Shi| 2        |
| Developer (Dev)    | Cooper Calk| 2         |
| Developer (Dev)    | Jordan Daryanani| 4        |

**Total Points Completed:** 10 Points

---

## Sprint Goal

Students can log in and view problem types. Teachers can log in and view a student list. Users can navigate between pages. 

---

## Achievements in the Sprint

### Summary of Implemented User Stories:

1. **Deploy Web Page**  
   - **Developer:** Kevin Shi  
   - **Status:** Completed  
   - **Test Cases:** [Link](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/2)  
   - **Changes Made:** Basic setup of rails environment with Heroku deployment.  
   - **Reason for Changes:** Setup and viewing for the future.

2. **Select Problem Category**  
   - **Developer:** Cooper Calk  
   - **Status:** Completed  
   - **Test Cases:** [Link](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/4)  
   - **Changes Made:** Created a page with feature and backend/db for a student to select a category of problem to work on, which then redirects to a page currently with a dummy question.  
   - **Reason for Changes:** To enable users to choose a specific problem type to practice rather than always having a random one.

3. **Github Actions**
   - **Developer:** Dhruv Manihar
   - **Status:** Completed  
   - **Test Cases:** [Link](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/7)  
   - **Changes Made:** Implemented CI/CD rules for the repo such as auto test coverage and rubocop checks when building on push in GitHub. Also set up auto deployment to Heroku when changes are made to main.  
   - **Reason for Changes:** Streamline development and ensure code quality.

4. **View List of Students as a Teacher**  
   - **Developer:** Cooper Calk  
   - **Status:** In Progress  
   - **Test Cases:** [Link](https://github.com/orgs/tamu-edu-students/projects/87/views/1?pane=issue&itemId=93213056)  
   - **Changes Made:** Made list of students available to teachers to view.  
   - **Reason for Changes:** To allow teacher users to see the students using the app and enable future interactions.

5. **Log-In as a Student**  
   - **Developer:** Jordan Daryanani 
   - **Status:** Completed  
   - **Test Cases:** [Link](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/6)  
   - **Changes Made:** Changed the login page buttons to link to OAuth. Set up OAuth tokens, automatically creating Student users if a student is not already created. Added middleware (students can not view teacher pages). This allows for additional security and confidentiality as students cannot view each other’s scores.
   - **Reason for Changes:** Allows teachers and students to be separated into their respective pages and allows for additional security.

6. **Return Home from Page**  
   - **Developer:** Kevin Shi
   - **Status:** Completed  
   - **Test Cases:** [Link](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/3)  
   - **Changes Made:** Created problems page and student home view, and respective buttons to navigate back and forth. Added routing between them based on Rspec and Cucumber tests.  
   - **Reason for Changes:** To provide proper navigation for the student user.

7. **Log-In as a Teacher**  
   - **Developer:** Jordan Daryanani  
   - **Status:** Completed  
   - **Test Cases:** [Link](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/5)  
   - **Changes Made:** Added middleware (Teacher’s cannot view student pages as a student). Teacher login button logs in as a teacher and correctly brings them to their page.
   - **Reason for Changes:** Allows teachers and students to be separated into their respective pages and allows for additional security.


---

## Sprint Backlog Items, Status, and Testing

Testing covers: code smells, style offenses, and coverage.

| Item # | User Story                          | Status       | Notes                                                                 |
|--------|-------------------------------------|--------------|-----------------------------------------------------------------------|
| 1      | Deploy Web Page                     | Completed    | Coding Smells: None<br>Style Offenses: None<br>Coverage: 100%          |
| 2      | Select Problem Category             | Completed    | Coding Smells: None<br>Style Offenses: Small offenses (spacing, quotes), autofixed by RuboCop<br>Coverage: 100% with RSpec and Cucumber |
| 3      | Github Actions                      | Completed    | Coding Smells: None<br>Style Offenses: None (Duplicate gem in Gemfile removed)<br>Coverage: No coverage check, tested manually |
| 4      | View List of Students as a Teacher  | Completed | Coding Smells: None<br>Style Offenses: None<br>Coverage: 97.59% (Not started, waiting on Item 7) |
| 5      | Log-In as a Student                 | Completed    | Coding Smells: None<br>Style Offenses: None<br>Coverage: 97.6% with RSpec and Cucumber |
| 6      | Return Home from Page               | Completed    | Coding Smells: None<br>Style Offenses: None<br>Coverage: 100%          |
| 7      | Log-In as a Teacher                 | Completed    | Coding Smells: None<br>Style Offenses: None<br>Coverage: 97.6% with RSpec and Cucumber |

---

## Burn Down Chart

![Burndown Chart](/.documentation/Winter2025/Images/output.png)



---

## **Design Diagram**

**Design before Implementation:**

| Feature | Lo-Fi Mock-Up View |
| :---- | :---- |
| Log-In as a teacher | ![](/.documentation/Winter2025/Images/Lo-Fi/Login_To_Teacher.png) |
| Log-In as a student | ![](/.documentation/Winter2025/Images/Lo-Fi/Login_To_Student.png) |

**Changes Made to Design During the Sprint:**

- No changes to Design yet

---


## Legacy Code Refactoring (if applicable)

- Not Applicable for Sprint 1

---

## Customer Feedback

- **Customer Meeting Date & Time:** [Jan 30, 2024, 1:00 P.M, Zach 425 F]
- **Summary of Discussion and Feedback:**
  - Client prioritizes ui/ux and would like to see a user friendly interface that is easy to interact with
  - Specific features to add: Track the time it takes for students to finish a problem type, back buttons for every page rather than just a home button
  - We will focus the design of pages rather than full implementations of features for the next sprint. 

## Deployment and Environment Setup

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/tamu-edu-students/practice-problem-generator-engr216.git
   cd practice-problem-generator-engr216
   ```

2. **Install Dependencies:**
   ```bash
   bundle install
   rails db:migrate
   rails db:seed
   ```

3. **Create a `.env` File with Google Credentials:**
   ```bash
   GOOGLE_CLIENT_ID=497801265275-2ee9flnfs8sn8lkip8l50q1c8v42solo.apps.googleusercontent.com
   GOOGLE_CLIENT_SECRET=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
   ```

4. **Login to Heroku:**
   ```bash
   heroku login
   ```

5. **Create a New Heroku App:**
   ```bash
   heroku create temp-app
   ```

6. **Push the Code to Heroku:**
   ```bash
   git push heroku main
   ```

7. **Run Migrations on Heroku:**
   ```bash
   heroku run rails db:migrate
   heroku run rails db:seed
   ```

8. **Open the App:**
   ```bash
   heroku open
   ```


