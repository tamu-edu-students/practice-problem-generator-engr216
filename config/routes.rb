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
  get '/auth/failure', to: 'sessions#auth_failure', as: :auth_failure

  # Set Role Routes
  get '/set_role/:role', to: 'sessions#set_role', as: :get_set_role
  post '/set_role/:role', to: 'sessions#set_role', as: :post_set_role
  
  # Teacher Dashboard Routes
  get '/teacher_dashboard', to: 'teacher_dashboard#index', as: :teacher_dashboard
  get 'teacher_dashboard/manage_students', to: 'teacher_dashboard#manage_students', as: :manage_students

  # Student Statistics in Teacher Dashboard
  namespace :teacher_dashboard do
    get 'student_statistics', to: 'student_statistics#index', as: :student_statistics
    get 'student_statistics/:id', to: 'student_statistics#show', as: :student_statistics_show
  end

  # Practice Problem Routes
  resources :practice_problems, only: [:index] do
    collection do
      get 'generate'
      post 'check_answer'
    end
  end

  # settings route
  get 'settings', to: 'settings#show', as: 'settings'

  # history route
  get 'history', to: 'history#show', as: 'history'
end