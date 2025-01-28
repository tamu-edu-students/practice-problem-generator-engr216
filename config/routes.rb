Rails.application.routes.draw do
  get "sessions/logout"
  get "sessions/omniauth"
  get "teachers/show"
  resources :students
  root to: redirect("/login")

  get "login", to: "pages#login"
  get "teacher_oauth", to: "pages#teacher_oauth", as: "teacher_oauth"
  get "student_oauth", to: "pages#student_oauth", as: "student_oauth"

  get "student_home", to: "pages#student_home", as: "student_home"
  get "teacher_home", to: "pages#teacher_home", as: "teacher_home"
  get "problem_type_1", to: "pages#problem_type_1", as: "problem_type_1"


  get '/teachers/:id', to: 'teachers#show', as: 'teacher'
  get '/logout', to: 'sessions#logout', as: 'logout'
  get '/auth/google_oauth2/callback', to: 'sessions#omniauth'
  resources :teachers 

get '/set_role/:role', to: 'sessions#set_role', as: :get_set_role
post '/set_role/:role', to: 'sessions#set_role', as: :post_set_role


  resources :practice_problems, only: [ :index ] do
    post :generate, on: :collection
  end
end
