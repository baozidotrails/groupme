Rails.application.routes.draw do
  devise_for :users

  resources :groups do
    resources :posts

    member do
      post 'join'
      post 'quit'
    end
  end

  namespace :account do
    resources :groups
    resources :posts
  end

  root 'groups#index'
end
