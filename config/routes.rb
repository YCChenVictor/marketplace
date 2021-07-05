require 'sidekiq/web'

Rails.application.routes.draw do

  # vist sidekiq if user is admin
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :products do
    resources :comments

    member do
      post :checkout
    end
  end

  resources :comments do
    resources :comments # should use only to arrange the routes
  end

  devise_for :users
  root to: 'products#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
