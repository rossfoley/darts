Rails.application.routes.draw do
  resources :players
  resources :teams
  resources :games do
    member do
      get 'play'
      post 'submit_score'
      delete 'undo'
    end
  end
  root 'games#index'
end
