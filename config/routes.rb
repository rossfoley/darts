Rails.application.routes.draw do
  resources :players
  resources :teams
  resources :games
  root 'games#index'
end
