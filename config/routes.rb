Rails.application.routes.draw do
  devise_for :users
  root 'categories#new'

  get "yy" => "welcome#yy"


  resources :categories
end
