Rails.application.routes.draw do
  resources :players
  resources :teams
  resources :games do
    member do
      get 'play'
    end
  end
  root 'games#index'
end
