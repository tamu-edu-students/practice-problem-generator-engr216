Rails.application.routes.draw do
  get "login", to: "pages#login", as: "login"
  root to: "pages#login"

  get "teacher_oauth", to: "pages#teacher_oauth", as: "teacher_oauth"
  get "student_oauth", to: "pages#student_oauth", as: "student_oauth"

  get "student_home", to: "pages#student_home", as: "student_home"
  get "teacher_home", to: "pages#teacher_home", as: "teacher_home"
  get "problem_type_1", to: "pages#problem_type_1", as: "problem_type_1"
end
