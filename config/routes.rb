Rails.application.routes.draw do
  resources :stores

  root to: 'visitors#index'
  #devise_for :users, :controllers => { :registrations => 'devise/registrations' }
  devise_for :users, :controllers => { :registrations => 'registrations', sessions: 'users/sessions' }
  resources :users
  resources :accounts
  resources :dashboards
  resources :invoices
  resources :subscriptions
  resources :plans
  match '/edit_card',   to: 'subscriptions#edit_card',   via: 'get'
  match '/update_card', to: 'subscriptions#update_card', via: 'post'
  get '/profile', to: "profiles#index"
  resources :settings

  post '/stores/destroy_multiple', to: 'stores#destroy_multiple'
  get '/bulk_upload', to: 'stores#bulk_upload', as: 'bulk_upload'
  post '/stores/import' => "stores#import", :as => 'import'
  get '/destroy_all' => "stores#destroy_all", :as => 'destroy_all'
  get '/mapdata/:id' => "stores#mapdata", :as => 'mapdata'
  get '/find_key/:id' => "stores#find_key", :as => 'find_key'
  get '/geocode' => "stores#geocode", :as => 'geocode'

  get '/settings' => "settings#index"
  patch '/settings/:id' => "settings#update"

end
