require 'sidekiq/web'

Rails.application.routes.draw do

  root to: 'products#index'

  devise_for :users
  get '/users/:id', to: "users#show", :as => :user

  post '/users/:id/follow', to: "users#follow", :as => :follow_user
  post '/users/:id/unfollow', to: "users#unfollow", :as => :unfollow_user

  # vist sidekiq if user is admin
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :products do
    resources :comments # 這應該不用這麼多條

    member do
      post :checkout
      get :seller_of
    end
  end

  resources :comments do
    resources :comments # should use only to arrange the routes
  end

end
