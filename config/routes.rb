Rails.application.routes.draw do
  resources :students
  root to: redirect("/students")

  resources :practice_problems, only: [ :index ] do
    post :generate, on: :collection
  end
end
