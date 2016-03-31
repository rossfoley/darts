Rails.application.routes.draw do
  devise_for :users, only: :omniauth_callbacks, controllers:  { omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :players
  resources :teams
  resources :games do
    member do
      get 'play'
      put 'finish'
    end
  end

  namespace :leaderboards do
    get 'players'
  end

  root 'games#index'
end
