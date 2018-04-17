Rails.application.routes.draw do
  # 登入用：
  resources :sessions do
    collection do
      post :wechat_login
      post :admin_required
    end
  end

  root "welcome#home"
  resources :users
  delete '/logout' => 'sessions#destroy', as: :logout

  get "welcome" => "welcome#index"

  get '/admin/recent_login_log' => "admin/recent_login_log"
  get '/admin/get_user_login_log' => "admin/get_user_login_log"
  post "/kexue/update_ss_item" => "kexue/update_ss_item"
  get 'kexue/get_qr' => "kexue/get_qr"
  get 'kexue/show_qr' => "kexue/show_qr"
  get "kexue/show_wingy_qr" => "kexue/show_wingy_qr"
  get "server_data" => 'application#server_data'

  resources :categories do
    collection do
      get :for_wechat_product_new_picker
      get :for_wechat_category_new_picker
      post :create_form_api
    end
    member do
      post :update_column
      post :update_form_api
      get :get_category_detail
      post :change_index_show_status
      post :delete_category
    end
  end
  resources :products do
    collection do
      post :create_form_wechat
    end
    member do
      post :update_form_wechat
      post :add_product_image
      get :get_product_detail
      post :change_is_hide_status
      post :change_in_stock_status
      post :change_index_show_status
      post :delete_form_wechat
    end
  end
  resources :homeset do
    member do
      post :update_column
      post :update_column_homeset
      post :change_is_hide_status
    end
    collection do
      # 获取小程序首页的图片，标题等配置
      get :get_wechat_homeset
    end
  end
  resources :collects do
    collection do
      post :create_collect
      delete :remove_clooect
      get :my_collects
    end
  end


  resources :ss_services do
    resources :ss_items do
      member do
        get :admin_show_qr
        post :change_send_status
        post :init_draw_time
      end
    end
  end


end
