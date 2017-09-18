Rails.application.routes.draw do
  devise_for :users
  root 'products#index'

  get "yy" => "welcome#yy"


  resources :categories do
    member do
      post :update_column
    end
  end
  resources :products do
    collection do
      post :create_form_wechat
    end
    member do
      post :update_form_wechat
    end
  end
end
