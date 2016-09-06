Rails.application.routes.draw do
  resources :stores do

  end
  # resources :stores do
  #   member do
  #     post 'destroy_multiple' => "stores#destroy_multiple", :as => :destroy_multiple
  #   end
  # end

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
  get "settings", to: "profiles#index"
  resources :settings

  post '/stores/destroy_multiple', to: 'stores#destroy_multiple'
  get '/bulk_upload', to: 'stores#bulk_upload', as: 'bulk_upload'
  post '/stores/import' => "stores#import", :as => 'import'
  get '/destroy_all' => "stores#destroy_all", :as => 'destroy_all'
  

end
