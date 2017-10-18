Rails.application.routes.draw do
  root to: 'pages#home'
  get '/users/:id/addFunds', to: 'users#addFunds', as: 'addFunds'
  get '/home', to: 'pages#home', as: 'home'
  post 'jackpot/update/:id', to: 'jackpots#update', as: 'update_pot'
  post 'jackpot', to: 'jackpots#update', as: 'jackpot'
  devise_for :users
  resources :users
end
