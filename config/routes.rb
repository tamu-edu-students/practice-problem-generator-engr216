Rails.application.routes.draw do
  # get "history/show"
  root to: redirect("/login")
  get 'history', to: 'history#show', as: 'student_history2'
  

  # Login routes
  get 'login', to: 'pages#login'
  get 'student_oauth', to: 'pages#student_oauth', as: 'student_oauth'
  get 'teacher_oauth', to: 'pages#teacher_oauth', as: 'teacher_oauth'
  get 'student_home', to: 'pages#student_home', as: 'student_home'
  get 'teacher_home', to: 'pages#teacher_home', as: 'teacher_home'
  get 'problem_type1', to: 'pages#problem_type1', as: 'problem_type1'

  # Student and Teacher routes
  resources :students
  resources :teachers

  # Update student UIN + teacher
  post '/update_uin', to: 'students#update_uin', as: :update_uin

  # Routes for Measurements & Error Problems
  get 'measurements_and_error_problems/generate', to: 'measurements_and_error_problems#generate',
                                                  as: :generate_measurements_and_error_problems
  post 'measurements_and_error_problems/check_answer', to: 'measurements_and_error_problems#check_answer',
                                                       as: :check_measurements_and_error_answer

  # Redirecting after successful login
  get '/auth/google_oauth2/callback', to: 'sessions#omniauth'
  get '/logout', to: 'sessions#logout', as: 'logout'
  get '/auth/failure', to: 'sessions#auth_failure', as: 'auth_failure'

  # Set Role Routes
  get '/set_role/:role', to: 'sessions#set_role', as: :get_set_role
  post '/set_role/:role', to: 'sessions#set_role', as: :post_set_role

  # Teacher Dashboard Routes
  get '/teacher_dashboard', to: 'teacher_dashboard#index', as: :teacher_dashboard
  get 'teacher_dashboard/manage_students', to: 'teacher_dashboard#manage_students', as: :manage_students
  post 'teacher_dashboard/delete_semester_students', to: 'teacher_dashboard#delete_semester_students', as: :delete_semester_students

  # Teacher View: Student History Routes
  get 'teacher_dashboard/student_history_dashboard', to: 'teacher_dashboard#student_history_dashboard',
                                                     as: :student_history_dashboard
  get 'teacher_dashboard/student_history/:student_email', to: 'teacher_dashboard#student_history', as: :student_history

  # Practice Problem Dashboard Routes
  # get '/practice_problems', to: 'practice_problem_dashboard#index', as: :practice_problems

  # Add the settings route
  get 'settings', to: 'settings#show', as: 'settings'
  put 'settings', to: 'settings#update'


  # Add the history route
  get 'history', to: 'history#show', as: 'history'
  get 'history/teacher_view', to: 'history#teacher_view', as: 'teacher_view'

  # Practice Problem Routes
  resources :practice_problems, only: [:index] do
    collection do
      get 'generate'
      post 'check_answer'
    end
  end
  resources :harmonic_motion_problems, only: [] do
    collection do
      get 'generate'
      post 'check_answer'
    end
  end
  resources :rigid_body_statics_problems, only: [] do
    collection do
      get 'generate'
      post 'check_answer'
    end
  end
  resources :angular_momentum_problems, only: [] do
    collection do
      get 'generate'
      post 'check_answer'
    end
  end
  resources :particle_statics_problems do
    collection do
      post :check_answer
      get :generate
    end
  end
  
  resources :rigid_body_statics_problems, only: [] do
    collection do
      get 'generate'
      post 'check_answer'
    end
  end

  get '/teacher_dashboard/student_history', to: 'teacher_dashboard#student_history'

  # Add these routes if they don't exist already
  get 'practice_problems/engineering_ethics', to: 'practice_problems#engineering_ethics',
                                              as: :engineering_ethics_problems
  get 'practice_problems/finite_differences', to: 'practice_problems#finite_differences',
                                              as: :finite_differences_problems
end
