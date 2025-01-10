Rails.application.routes.draw do
  resources :students
  root :to => redirect('/students')
end
