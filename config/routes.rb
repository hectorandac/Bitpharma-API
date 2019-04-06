# frozen_string_literal: true

Rails.application.routes.draw do
  apipie
  devise_for :users,
             path: 'api',
             path_names: {
               sign_in: 'login',
               sign_out: 'logout',
               registration: 'sign_up'
             },
             controllers: {
               sessions: 'sessions',
               registrations: 'registrations'
             }, defaults: { format: :json }

  mount ActionCable.server => '/cable'

  namespace :api do
    namespace :drug_store do
      post '/', to: 'drug_store#create'
      post '/image', to: 'drug_store#append_image'
      get '/', to: 'drug_store#show'
    end

    namespace :user do
      get '/', to: 'user#show'
      patch '/', to: 'user#update'
      post '/profile_picture', to: 'user#add_profile_picture'
      patch '/role', to: 'user#append_role'
    end

    namespace :order do
      get '/', to: 'order#show_single'
      get '/all', to: 'order#show'
      patch '/', to: 'order#update_state'
      post '/demo', to: 'order#create_demo'
    end

    namespace :product do
      get '/', to: 'products#index'
      get '/search', to: 'products#query'
      get '/:id', to: 'products#show'
      post '/', to: 'products#create'
      post '/image', to: 'products#append_images'
      patch '/:id', to: 'products#update'
    end
  end
end
