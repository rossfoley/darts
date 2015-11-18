Rails.application.routes.draw do
  resources :players
  resources :teams
  resources :games do
    member do
      get 'play'
      post 'submit_score'
      post 'new_round'
      delete 'undo'
      patch 'finish'
    end
  end

  namespace :leaderboards do
    get 'players'
  end

  root 'games#index'
end
