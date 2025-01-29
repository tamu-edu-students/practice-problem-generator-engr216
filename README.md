# README

Practice Problem Generator for ENGR216

Getting Started
Follow the steps below to set up and run this project on your local development environment.

Prerequisites
Ruby: 3.3.4 
Rails: 8.0.1

Setup
Clone the repository:
$ git clone https://github.com/tamu-edu-students/practice-problem-generator-engr216.git
$ cd practice-problem-generator-engr216
$ bundle install
$ rails db:migrate
$ rails db:seed
$ rails server

Running Tests

$ bundle exec rspec 
$ bundle exec cucumber

Deployment
$ heroku login
$ git push heroku main
$ heroku run rails db:migrate
$ heroku run rails db:seed
$ heroku open

Current deployment: https://whispering-reaches-02252-73f884c5e5f0.herokuapp.com/students
