# Sprint Review Report

## Sprint Overview

- **Sprint Number:** 2
- **Sprint Dates:** 01/30/25 - 02/14/25
  
### Team Members and Roles:

| Role               | Name              | Points Completed |
|--------------------|-------------------|------------------|
| Product Owner (PO) | Cooper Calk           | N/A              |
| Scrum Master (SM)  | Jordan Daryanani            | N/A              |
| Developer (Dev)    | Dhruv Manihar| 2         |
| Developer (Dev)    | Kevin Shi| 2        |
| Developer (Dev)    | Vivek Somarapu| 2         |
| Developer (Dev)    | Nicholas Turoci| 2        |

**Total Points Completed:** 8 Points

---

## Sprint Goal

Students can view a non-functional student dashboard. Teachers can view a non-functional teacher dashboard. Users can login and be brought to their respective dashboard. 
---

## Achievements in the Sprint

### Summary of Implemented User Stories:

1. **Design Teacher Dashboard**  
   - **Developer:** Kevin Shi  
   - **Status:** Completed  
   - **Test Cases:** [Link](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/54)  
   - **Changes Made:** Migration/schema update to database + seeds for testing, Barebones “teacher dashboard” page, Routing based on roles.
   - **Reason for Changes:** Allows for more identification elements for teacher and students, Lays foundation for teacher statistics and other teacher-related settings, For security, strictly prevents students from accessing the teacher page. Strictly tested using omniauth mock users.

2. **History Page for Student**  
   - **Developer:** Nicholas Turoci
   - **Status:** Completed  
   - **Test Cases:** [Link](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/55)  
   - **Changes Made:** Added a designated page where students can view past problems they have completed along with feedback.  
   - **Reason for Changes:** In order to have a Physics review app, students need to see their progress as well as feedback to ensure growth.

3. **Manage Student Page for Teacher**
   - **Developer:** Vivek Somarapu
   - **Status:** Completed  
   - **Test Cases:** [Link](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/56)  
   - **Changes Made:** Designed and implemented a page for students to manage students in the form of a table, with the ability to view, edit, delete, and create a student 
   - **Reason for Changes:** Teachers must be able to view all their students and they need a centralized place to manage each of these students. 

4. **Styling Login page**  
   - **Developer:** Dhruv Manihar 
   - **Status:** Complete 
   - **Test Cases:** [Link](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/26)  
   - **Changes Made:** Added styling to login page that was plain html using tailwinds/rails ui
   - **Reason for Changes:** Better UI experience for student/teacher logging in

5. **Design Practice Problem Dashboard**  
   - **Developer:** Vivek Somarapu 
   - **Status:** Completed  
   - **Test Cases:** [Link](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/57)  
   - **Changes Made:** Designed and implemented a page that allows for students to view and select problem categories with appropriate nav bar. 
   - **Reason for Changes:** Students must be able to view options for which types of problems they may want to generate. 

6. **Return Home from Page**  
   - **Developer:** Dhruv Manihar
   - **Status:** Completed  
   - **Test Cases:** [Link](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/37)  
   - **Changes Made:** Added “dummy problems” that show up when selecting the practice category. Allows to generate a new problem while on the page as well.  
   - **Reason for Changes:** Creating the basic interface for showing a problem to a student. 

7. **Log-In as a Teacher**  
   - **Developer:** Nicholas Turoci 
   - **Status:** Completed  
   - **Test Cases:** [Link](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/58)  
   - **Changes Made:** Added a settings page for students to authenticate teacher or reset data.
   - **Reason for Changes:** Students need to connect a teacher to their account as well as indicate whether they want their teacher to track their progress. In order to do this they need a page to indicate these preferences.

7. **Student Statistic Page for Teacher**  
   - **Developer:** Kevin Shi 
   - **Status:** Incomplete
   - **Test Cases:** [Link](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/39)  
   - **Changes Made:**
   - **Reason for Changes:** 




---

## Sprint Backlog Items, Status, and Testing

Testing covers: code smells, style offenses, and coverage.

| Item # | User Story                          | Status       | Notes                                                                 |
|--------|-------------------------------------|--------------|-----------------------------------------------------------------------|
| 1      | Design Teacher Dashboard               | Completed    | Coding Smells: None<br>Style Offenses: None<br>Coverage: 100%  |
| 2      | History Page for Student               | Completed    | Coding Smells: None<br>Style Offenses: None<br>Coverage: 100%  |
| 3      | Manage Student Page for Teacher        | Completed    | Coding Smells: None<br>Style Offenses: None<br>Coverage: 100%  |
| 4      | Styling Login Page                     | Completed    | Coding Smells: None<br>Style Offenses: None<br>Coverage: 100%  |
| 5      | Design Practice Problem Dashboard      | Completed    | Coding Smells: None<br>Style Offenses: None<br>Coverage: 100%  |
| 6      | Generate Problem Page for Student      | Completed    | Coding Smells: Nothing currently, but could cause databse generation in the future. <br>Style Offenses: None<br>Coverage: 100%  |
| 7      | Settings Page for Student              | Completed    | Coding Smells: None<br>Style Offenses: None<br>Coverage: 100%  |
| 8      | Student Statistic Page for Teacher     | Incomplete    | Moved to Sprint 3  |

---

## Burn Down Chart

![Burndown Chart](/.documentation/Winter2025/Images/Sprint2Burndown.PNG)



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

- Recreated/Refactored the styling on every page from Sprint1.

---

## Customer Feedback

- **Customer Meeting Date & Time:** [Jan 30, 2024, 1:00 P.M, Zach 425 F]
- **Summary of Discussion and Feedback:**
  - Client prioritizes ui/ux and would like to see a user friendly interface that is easy to interact with
  - Specific features to add: Track the time it takes for students to finish a problem type, back buttons for every page rather than just a home button
  - We will focus the design of pages rather than full implementations of features for the next sprint. 

## Deployment and Environment Setup
## Prerequisites
- Ruby: 3.3.4 
- Rails: 8.0.1

## Setup
### Clone the repository:

```bash
$ git clone https://github.com/tamu-edu-students/practice-problem-generator-engr216.git
$ cd practice-problem-generator-engr216
```
### Install Dependencies:
```bash
bundle install
rails db:migrate
rails db:seed
```
### Setting up Environment Variables
Create a `.env` file in the root of the project directory. Contact our team for more details.

### View page
```bash
rails server
```

## Running Tests
```bash
bundle exec rspec
```
```bash
bundle exec cucumber
```

## Deployment

```bash
heroku login
```
```bash
heroku create temp-app
```
```bash
git push heroku main
```
```bash
heroku run rails db:migrate
```
```bash
heroku run rails db:seed
```
```bash
heroku open
```


**Links:**

* Github Repo \-[https://github.com/tamu-edu-students/practice-problem-generator-engr216](https://github.com/tamu-edu-students/practice-problem-generator-engr216)  
* Github Project Board \- [https://github.com/orgs/tamu-edu-students/projects/87](https://github.com/orgs/tamu-edu-students/projects/87)  
* Slack Channel \- [https://join.slack.com/t/teambulbasaur431/shared\_invite/zt-2xqwi5eld-TGti6LUVSiQfk7aAkST5Ew](https://join.slack.com/t/teambulbasaur431/shared_invite/zt-2xqwi5eld-TGti6LUVSiQfk7aAkST5Ew)
