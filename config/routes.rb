Rails.application.routes.draw do
  devise_for :users, only: :omniauth_callbacks, controllers:  { omniauth_callbacks: 'users/omniauth_callbacks' }
  authenticate :user do
    resources :players
    resources :teams
    resources :games, except: :index do
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
  end

  get :logout, to: 'users#logout', as: :logout

  resources :games, only: :index

  root 'games#index'
end
