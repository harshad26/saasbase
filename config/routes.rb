Rails.application.routes.draw do
  resources :stores
  # resources :stores do
  #   member do
  #     post 'destroy_multiple' => "stores#destroy_multiple", :as => :destroy_multiple
  #   end
  # end

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
  match '/stores/destroy_multiple', to: 'stores#destroy_multiple', via: 'post'
  # post '/stores/destroy_multiple', to: 'stores#destroy_multiple'
end
