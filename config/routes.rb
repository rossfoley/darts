Rails.application.routes.draw do
  devise_for :users, only: :omniauth_callbacks, controllers:  { omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :players
  resources :teams
  resources :games do
    member do
      get 'play'
      put 'finish'
    end

    collection do
      get 'new_suggest'
      post 'create_suggest'
    end
  end

  namespace :leaderboards do
    get 'players'
    get 'all-time'
  end

  root 'games#index'
end
