# Sprint Review Report

## Sprint Overview

- **Sprint Number:** X
- **Sprint Dates:** [Start Date] - [End Date]
- 
### Team Members and Roles:

| Role               | Name              | Points Completed |
|--------------------|-------------------|------------------|
| Product Owner (PO) | Vivek Somarapu            | N/A              |
| Scrum Master (SM)  | Nicholas Turoci            | N/A              |
| Developer (Dev)    | Dhruv Manihar| 2         |
| Developer (Dev)    | Kevin Shi| 2        |
| Developer (Dev)    | Cooper Calk| 1         |
| Developer (Dev)    | Jordan Daryanani| 4        |

**Total Points Completed:**[9 Points

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

5. **View List of Students as a Teacher**  
   - **Developer:** Cooper Calk  
   - **Status:** In Progress  
   - **Test Cases:** [Link](https://github.com/orgs/tamu-edu-students/projects/87/views/1?pane=issue&itemId=93213056)  
   - **Changes Made:** Made list of students available to teachers to view.  
   - **Reason for Changes:** To allow teacher users to see the students using the app and enable future interactions.

6. **Log-In as a Student**  
   - **Developer:** Jordan Daryanani 
   - **Status:** Completed  
   - **Test Cases:** [Link](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/6)  
   - **Changes Made:** [Not provided]  
   - **Reason for Changes:** [Not provided]

7. **Return Home from Page**  
   - **Developer:** Kevin Shi
   - **Status:** Completed  
   - **Test Cases:** [Link](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/3)  
   - **Changes Made:** Created problems page and student home view, and respective buttons to navigate back and forth. Added routing between them based on Rspec and Cucumber tests.  
   - **Reason for Changes:** To provide proper navigation for the student user.

8. **Log-In as a Teacher**  
   - **Developer:** Jordan Daryanani  
   - **Status:** Completed  
   - **Test Cases:** [Link](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/5)  
   - **Changes Made:** [Not provided]  
   - **Reason for Changes:** [Not provided]

---

## Sprint Backlog Items and Status

| Item # | User Story                          | Status     | Notes |
|--------|-------------------------------------|------------|-------|
| 1      | Deploy Web Page                  | Completed  | [Details] |
| 2      | Select Problem Category           | Completed  | [Details] |
| 3      | Github Actions                    | Completed  | [Details] |
| 4      | View List of Students as a Teacher | In Progress| [Details] |
| 5      | Log-In as a Student               | Completed  | [Details] |
| 6      | Return Home from Page             | Completed  | [Details] |
| 7      | Log-In as a Teacher               | Completed  | [Details] |


---

## Burn Down Chart

[Include a chart showing the progress of the sprint over time.]

---

## Design Diagram

**Design before Implementation:**

[Include UML Class Diagram or another design format with relationships of the app's entities.]

**Changes Made to Design During the Sprint:**

- [If any changes occurred, describe the changes made and the reason behind them.]

---

## Legacy Code Refactoring (if applicable)

- Not Applicable for Sprint 1

---

## Customer Feedback

- **Customer Meeting Date & Time:** [Date, Time, Location]
- **Summary of Discussion and Feedback:**
  - [Provide details of the feedback received during the customer demo and meeting.]
  - [Explain how this feedback will affect the next sprint.]

---

## Testing

- **Smells:** [List any potential code smells identified during testing]
- **Style Offenses:** [List any style offenses encountered]
- **Coverage:** [Provide details on test coverage, including Cucumber and RSpec results]

---

## Deployment and Environment Setup

1. **Clone the Repository:**
   ```bash
   git clone [Repo URL]
