# README

## Practice Problem Generator for ENGR216
We will be creating a Practice Problem Generator for ENGR 216. This application will allow students to log in with their @tamu Google accounts and choose a practice problem category related to ENGR 216. After a category has been chosen the students will receive a randomly generated problem on a selected topic. The student will then submit their attempt and receive feedback on correctness and explanation. Students using the application will be able to generate as many problems as they would like, as well as review their history in the form of a “report card.” If identified, their teacher will be able to view this report card. 
## Getting Started
Follow the steps below to set up and run this project on your local development environment.

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
heroku git:remote -a whispering-reaches-02252
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

## Contact
#### Phone: 512-975-6499
#### Email: vivek.somarapu@tamu.edu

### Current deployment: 
https://whispering-reaches-02252-73f884c5e5f0.herokuapp.com/
