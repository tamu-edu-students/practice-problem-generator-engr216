# CSCE 431 Team Bulbasaur

**Team Roles:**

| Sprint | Scrum Master | Product Owner |
| :---: | :---: | :---: |
| 1 | Nick | Vivek |
| 2 | Jordan | Cooper |
| 3 | Cooper | Jordan |
| 4 | Dhruv | Kevin |
| 5 | Kevin | Dhruv |

**Customer Meeting:**  
Jan. 9 2025, 9:00 AM CST on Zoom Client Meeting Notes:   
We must include much more features for the teacher's view. Teachers should be able to check statistics from the teacher view such as the count for the number of students that have attempted problems per topic, as well as this represented as a percentage out of all students. They should also have the count and percentage for the correctly submitted answers per topic. Teachers should have a list of users with around 2 summary statistics such as how many students the student has answered and the percentage of correct answers. When you click on a user, more complicated statistics can come up such as attempted topics and percentage correct per topic. Teachers should be able to add more questions for all users (everyone has the same problems) and should have the ability to add new users as teachers. Teachers must be able to remove users who may be abusing the system, and they must be able to remove all users at the end of a semester. Finally, for users who have not selected an instructor or do not want their teacher to see their report, they will show up as anonymous to the instructor. 

As for students, we must create settings that allow them to select their instructor and give permission for them to see their scores. Other general notes include that the client is looking for functionality, not prettiness, nothing specific is expected for sprint 1 and a fully functional backend is not required, and each sprint report must be shared to the client. As for notes related to problems, problems must be split by units, there should be no cap on the number of attempts a student can have, there must only be a single answer (not a correct range of answers), and there must not be more answer feedback than an answer being higher or lower. 

Default regular meeting not set yet. 

**Summary:**  
We will be creating a Practice Problem Generator for ENGR 216\. This application will allow students to log in with their @tamu Google accounts and choose a practice problem category related to ENGR 216\. After a category has been chosen the students will receive a randomly generated problem on a selected topic. The student will then submit their attempt and receive feedback on correctness and explanation. Students using the application will be able to generate as many problems as they would like, as well as review their history in the form of a “report card.” If identified, their teacher will be able to view this report card. 

**User Stories:** 

| Student |
| :---- |
| Feature: Log-In as a student **(in lofi-mockup)** As a student So that I can use the app I want to Log-In with Google Oauth |
| Feature: Unlimited Problem Generator **(in lofi-mockup)** As a student So that I can keep practicing I want to generate a new problem |
| Feature: Answer check/feedback **(in lofi-mockup)** As a student,  So that I can improve my answer, I want to see feedback on my submitted solution |
| Feature: Invalid Answer Submission Prevention  As a student,  So that I can have higher quality attempts, I want to be prevented from submitting accidental/invalid answers |
| Feature: Problem History **(in lofi-mockup)** As a student user, So that I can see problems I have done in the past, I want to access a view that includes each previously submitted problem title and preview along with their timestamp |
| Feature: Problem-type Filter in Problem History  As a student, So that I can see past problems of the same type, I want to sort by problem type |
| Feature: Problem-time filter in problem history As a student, So that I can see past problems of the same time range, I want to sort by problem time |
| Feature: Problem-score filter in problem history As a student, So that I can see past problems of the same score, I want to sort by problem score |
| Feature: Problem-type Navigation As a student user,  So that I can choose a type of problem,  I want to easily choose the problem type from the home page |
| Feature: View List of Students as a Teacher **(in lofi-mockup)** Given I am a teacher user, So that I can see all my students, I want to access a list of all student users |
| Feature: Identify Teacher as a Student As a student So that my teacher can view my report card I want to identify my teacher |
| Feature: Opt-in to teacher viewing report card **(in lofi-mockup)** As a student So that I can have my selected teacher review my scores I want to opt-in to them having score access |
| Feature: Return home from page **(in lofi-mockup)** As a student So that I can return to home view I want to access the home view at any point |
| Feature: Log-In as a teacher **(in lofi-mockup)** As a teacher So that I can view report cards I want to Log-In with Google OAuth |
| Feature: Remove Student  As a Teacher So that I can remove a student I want to select a student from a list and remove them as a user |
| Feature: Teacher-view Filter **(in lofi-mockup)** As a Teacher So that I can view specific data topics I want a filter view to alter the table view |
| Feature: Attempt count per topic **(in lofi-mockup)** As a Teacher So that I can view how many students attempted the topic I want a count of the number of students who have answered problems per topic in the form of a list |
| Feature: Percent correct **(in lofi-mockup)** As a Teacher So that I can see what percent of students that got the problems correct per topic I want to see what percent of students got the problem topic correct |
| Feature: Section Filter **(in lofi-mockup)** As a Teacher So that I can filter students and their data by section I want to be able to filter table view by section |
| Feature: Problems Attempted  As a teacher So that I can view how many problems a student attempted I want to see the count of problems a student has attempted as a summary statistic count in the list of users |
| Feature: Split Problems by Units  As a StudentSo that I can attempt problems filtered by unit I want to select which unit my problems will be given from |
| Feature: Settings Page for Student **(in lofi-mockup)** As a Student So that I can change settings for the application I want to visit a settings page from the student home page |
| Feature: Anonymous Student As a Teacher So that I can see a student’s performance who is not linked to a professor I want to see students as anonymous users if they have not selected their professor. |

**Notecard version of user stories: ![][image1]**

| Feature | Lo-Fi Mock-Up View |
| :---- | :---- |
| Overview | ![][image2] |
| Log-In as a teacher | ![][image3] |
| Log-In as a student | ![][image4] |
| Return home from page | ![][image5] |
| Unlimited Problem Generator  | **![][image6]** |
| Settings Page for Student | **![][image7]** |
| Problem History  | ![][image8] |
| Teacher-view Filter | ![][image9] |
| Opt-in to teacher viewing report card | ![][image10] |
| Answer check/feedback | ![][image11] |
| Attempt count per topic, Percent correct, Section Filter  | ![][image12] |

**Links:**

* Github Repo \-[https://github.com/tamu-edu-students/practice-problem-generator-engr216](https://github.com/tamu-edu-students/practice-problem-generator-engr216)  
* Github Project Board \- [https://github.com/orgs/tamu-edu-students/projects/87](https://github.com/orgs/tamu-edu-students/projects/87)  
* Slack Channel \- [https://join.slack.com/t/teambulbasaur431/shared\_invite/zt-2xqwi5eld-TGti6LUVSiQfk7aAkST5Ew](https://join.slack.com/t/teambulbasaur431/shared_invite/zt-2xqwi5eld-TGti6LUVSiQfk7aAkST5Ew)
