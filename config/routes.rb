Rails.application.routes.draw do
  devise_for :users
  root 'categories#index'

  get "yy" => "welcome#yy"


  resources :categories do
    member do
      post :update_column
    end
  end
  resources :products
end
