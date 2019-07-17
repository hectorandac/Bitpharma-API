# frozen_string_literal: true

Rails.application.routes.draw do

  get '/', to: 'application#index'

  devise_for :users,
             path: 'api',
             path_names: {
               sign_in: 'login',
               sign_out: 'logout',
               registration: 'sign_up'
             },
             controllers: {
               sessions: 'sessions',
               registrations: 'registrations',
               confirmations: 'confirmations'
             }, defaults: { format: :json }

  mount ActionCable.server => '/cable'

  namespace :api do
    namespace :drug_store do
      post '/', to: 'drug_store#create'
      post '/image', to: 'drug_store#append_image'
      get '/', to: 'drug_store#show'
      get '/search_near', to: 'drug_store#search_near'
      get '/last_week_status', to: 'drug_store#last_week_status'
      put '/add_product', to: 'drug_store#add_product'
    end

    namespace :user do
      get '/', to: 'user#show'
      patch '/', to: 'user#update'
      post '/profile_picture', to: 'user#add_profile_picture'
      patch '/role', to: 'user#append_role'

      post '/payment_method', to: 'payment_method#add_payment_method'
      get '/payment_method', to: 'payment_method#retrieve_payment_methods'
      delete '/payment_method', to: 'payment_method#remove_payment_method'
      patch '/payment_method', to: 'payment_method#modify_default'

      post '/cart/pay', to: 'payments#perform_payment'
      post '/cart/product', to: 'cart#append_product'
      delete '/cart/product', to: 'cart#remove_product'
      get '/cart/product', to: 'cart#show_cart'

      get '/orders', to: 'order#show'
      get '/orders/single', to: 'order#show_single'

      get '/address', to: 'address#show'
      post '/address', to: 'address#create'
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
      post '/reindex', to: 'products#reindex'
      delete '/', to: 'products#destroy'
    end
  end
end
