require 'sidekiq/web'

Rails.application.routes.draw do

  # vist sidekiq if user is admin
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :projects do
    resources :comments, module: :projects
  end

  devise_for :users
  root to: 'projects#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
