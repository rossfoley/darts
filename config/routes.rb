Rails.application.routes.draw do
  resources :players
  resources :teams
  resources :games do
    member do
      get 'play'
      post 'submit_scores'
      get 'submit_score'
    end
  end
  root 'games#index'
end
