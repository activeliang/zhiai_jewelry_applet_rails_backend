Rails.application.routes.draw do
  devise_for :users
  root 'products#index'

  get "yy" => "welcome#yy"


  resources :categories do
    collection do
      get :for_wechat_product_new_picker
      get :for_wechat_category_new_picker
    end
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
      post :update_product_image
    end
  end
end
