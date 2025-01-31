Rails.application.routes.draw do
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
  
  # Practice Problem Routes
  resources :practice_problems, only: [:index] do
    post :generate, on: :collection
  end
end
