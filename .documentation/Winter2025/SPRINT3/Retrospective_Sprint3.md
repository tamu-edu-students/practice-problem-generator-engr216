# Sprint Review Report

## Sprint Overview

- **Sprint Number:** 3
- **Sprint Dates:** 02/24/25 - 03/07/25
  
### Team Members and Roles:

| Role               | Name              | Points Completed |
|--------------------|-------------------|------------------|
| Product Owner (PO) | Jordan Daryanani           | N/A              |
| Scrum Master (SM)  | Cooper Calk            | N/A              |
| Developer (Dev)    | Dhruv Manihar| 1         |
| Developer (Dev)    | Kevin Shi| 4        |
| Developer (Dev)    | Vivek Somarapu| 4         |
| Developer (Dev)    | Nicholas Turoci| 3        |

**Total Points Completed:** 12 Points

---

## Sprint Goal

Students will be able to practice dynamically generated Confidence Interval and Experimental Statistics problems. Teachers will be able to see what problems their students have finished. Students will be able to select their teacher. 
---

## Achievements in the Sprint

### Summary of Implemented User Stories:

1. **Confidence Interval Problems**  
   - **Developer:** Vivek Somarapu
   - **Status:** Completed  
   - **Test Cases:** [Link](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/62)  
   - **Changes Made:** Logic to generate several types of confidence interval word problems. Answer verification (logic to compute true answers) and feedback for wrong answers. Some debugging logic that shows true answers for devs.
   - **Reason for Changes:** Students must be able to answer unlimited confidence interval problems. Students need to know if their answer is correct or why there answer may be incorrect. Makes it easier for developers to test answer verification.

2. **Experimental Statistics Problems**  
   - **Developer:** Vivek Somarapu
   - **Status:** Completed  
   - **Test Cases:** [Link](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/61)  
   - **Changes Made:** New templated page for practice problems. Implemented logic to generate and render two types of statistics problems (word problems, pure number problems with grid form) with multiple versions of each, along with random variable generation. Answer verification (logic to compute true answers) and feedback for wrong answers.
   - **Reason for Changes:** Students must be able to answer unlimited statistics problems. Students need to know if their answer is correct or why there answer may be incorrect.

3. **Create Database Schema**
   - **Developer:** Nicholas Turoci
   - **Status:** Completed  
   - **Test Cases:** [Link](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/60)  
   - **Changes Made:**   Created a Database Schema we will use for all our querying requests. Consists of a teacher, student, question, and answers table. 
   - **Reason for Changes:**  We needed a clean database organization so we can begin implementing our querying functions in an appropriate manner.

4. **Students Choose a Teacher**  
   - **Developer:** Dhruv Manihar 
   - **Status:** Complete 
   - **Test Cases:** [Link](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/63)  
   - **Changes Made:** Student can view a list of all possible teachers in a dropdown
   - **Reason for Changes:** Student needs to be able to view all the possible teachers and select one

5. **Teacher Can View Student History**  
   - **Developer:** Kevin Shi 
   - **Status:** Completed  
   - **Test Cases:** [Link](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/64)  
   - **Changes Made:** Designed and implemented a page that allows for teachers to view individual students’ problem history with category and correctness attributes. 
   - **Reason for Changes:** Useful for teachers to view as well as set up more statistic features in the future. 

6. **Add Back Buttons**  
   - **Developer:** Nicholas Turoci
   - **Status:** Completed  
   - **Test Cases:** [Link](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/66)  
   - **Changes Made:** Added back buttons to teacher pages as well as student pages, along with this I changed some routing and minor design improvements.   
   - **Reason for Changes:** Make our webpage more intuitive and easily navigable.  

7. **Teacher Can View Overall Class Performance**  
   - **Developer:** Kevin Shi 
   - **Status:** Completed  
   - **Test Cases:** [Link](https://github.com/tamu-edu-students/practice-problem-generator-engr216/issues/65)  
   - **Changes Made:** Class performance statistics are made accessible from the teacher’s dashboard pages. There is a table with attempts made, correct, and incorrect statistics sorted by category.
   - **Reason for Changes:** Teacher may want to see general statistics regarding the class as a whole rather than individual students.




---

## Sprint Backlog Items, Status, and Testing

Testing covers: code smells, style offenses, and coverage.

| Item # | User Story                          | Status       | Notes                                                                 |
|--------|-------------------------------------|--------------|-----------------------------------------------------------------------|
| 1      | Confidence Interval Problems                     | Completed    | Coding Smells: None<br>Style Offenses: None<br>Coverage: 96%  |
| 2      | Experimental Statistics Problems                     | Completed    | Coding Smells: None<br>Style Offenses: None<br>Coverage: 100%  |
| 3      | Create Database Schema                              | Completed    | Coding Smells: None<br>Style Offenses: None<br>Coverage: 100%  |
| 4      | Students Can Choose a Teacher                           | Completed    | Coding Smells: None<br>Style Offenses: None<br>Coverage: 100%  |
| 5      | Teacher Can View Student History                     | Completed    | Coding Smells: None<br>Style Offenses: None<br>Coverage: 100%  |
| 6      | Add Back Buttons                                      | Completed    | Coding Smells: None <br>Style Offenses: None<br>Coverage: 100%  |
| 7      | Teacher Can View Overall Class Performance              | Completed    | Coding Smells: None<br>Style Offenses: None<br>Coverage: 100%  |

---

## Burn Down Chart

![Burndown Chart](/.documentation/Winter2025/Images/sprint3Burndown.png)



---

## **Design Diagram**

**Design before Implementation:**

| Feature | Lo-Fi Mock-Up View |
| :---- | :---- |
| Settings Page for Student | ![](/.documentation/Winter2025/Images/Lo-Fi/Student_To_Settings.png) |
| Teacher and Stats View |  ![](/.documentation/Winter2025/Images/Lo-Fi/All_Teacher.png) |


**Changes Made to Design During the Sprint:**

- No changes to Design yet

---


## Legacy Code Refactoring (if applicable)

- N/A

---

## Customer Feedback

- **Customer Meeting Date & Time:** [Meeting planned 3/20/25 due to Spring Break scheduling conflicts]
- **Summary of Discussion and Feedback:**
    Pending meeting


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
