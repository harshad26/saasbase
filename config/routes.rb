Rails.application.routes.draw do
  root to: 'visitors#index'
  #devise_for :users, :controllers => { :registrations => 'devise/registrations' }
  devise_for :users, :controllers => { :registrations => 'registrations' }
  resources :users
  resources :accounts
  resources :dashboards
  resources :invoices
  resources :subscriptions
  resources :plans
  match '/edit_card',   to: 'subscriptions#edit_card',   via: 'get'
  match '/update_card', to: 'subscriptions#update_card', via: 'post'
  get "settings", to: "profiles#index"
  resources :settings

end
