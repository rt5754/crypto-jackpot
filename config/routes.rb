Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get '/users/:id/addFunds', to: 'users#addFunds', as: 'addFunds'
  post '/users/:id/addFunds', to: 'users#addFunds', as: 'update_funds'
  get '/', to: 'pages#home', as: 'home', :defaults => { :format => 'json' }
  post '/', to: 'jackpots#newPotInfo', as: 'newPotInfo', :defaults => { :format => 'json' }
  post 'jackpot/update/:id', to: 'jackpots#update', as: 'update_pot', :defaults => { :format => 'html' }
  post 'jackpot', to: 'jackpots#update', as: 'jackpot'
  resources :users
end
