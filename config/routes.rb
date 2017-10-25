Rails.application.routes.draw do
  devise_for :admins
  devise_for :users
  root to: 'pages#home'
  get '/users/:id/addFunds', to: 'users#addFunds', as: 'addFunds'
  post '/users/:id/addFunds', to: 'users#addFunds', as: 'update_funds'
  get '/', to: 'pages#home', as: 'home', :defaults => { :format => 'json' }
  get '/potinfo', to: 'jackpots#pot_info', as: 'pot_info', :defaults => { :format => 'json' }
  post 'jackpot/update/:id', to: 'jackpots#update', as: 'update_pot', :defaults => { :format => 'html' }
  post 'jackpot', to: 'jackpots#update', as: 'jackpot'
  get 'jackpot/:id', to: 'jackpots#show', as: 'show_jackpot'
  resources :users
  resources :games
  
  resources :jackpots do
    resources :games, shallow: true
  end
  
  mount ActionCable.server, at: '/cable'
end
