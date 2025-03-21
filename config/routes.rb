Rails.application.routes.draw do
  get "history/show"
  root to: redirect("/login")

  # Login routes
  get "login", to: "pages#login"
  get "student_oauth", to: "pages#student_oauth", as: "student_oauth"
  get "teacher_oauth", to: "pages#teacher_oauth", as: "teacher_oauth"

  # Student and Teacher routes
  resources :students
  resources :teachers

  # Redirecting after successful login
  get '/auth/google_oauth2/callback', to: 'sessions#omniauth'
  get '/logout', to: 'sessions#logout', as: 'logout'

  # Set Role Routes
  get '/set_role/:role', to: 'sessions#set_role', as: :get_set_role
  post '/set_role/:role', to: 'sessions#set_role', as: :post_set_role
  
  # Teacher Dashboard Routes
  get '/teacher_dashboard', to: 'teacher_dashboard#index', as: :teacher_dashboard
  get 'teacher_dashboard/manage_students', to: 'teacher_dashboard#manage_students', as: :manage_students

  # Teacher View: Student History Routes
  get 'teacher_dashboard/student_history_dashboard', to:'teacher_dashboard#student_history_dashboard', as: :student_history_dashboard
  get 'teacher_dashboard/student_history/:uin', to: 'teacher_dashboard#student_history', as: :student_history
  # Practice Problem Dashboard Routes
  # get '/practice_problems', to: 'practice_problem_dashboard#index', as: :practice_problems

  # Add the settings route
  get 'settings', to: 'settings#show', as: 'settings'

  # Add the history route
  get 'history', to: 'history#show', as: 'history'
  
  # Practice Problem Routes
  resources :practice_problems, only: [:index] do
    collection do
      get 'generate'
      post 'check_answer'
    end
  end

end
