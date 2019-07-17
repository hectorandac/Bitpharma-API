# frozen_string_literal: true

module Api
  module DrugStore
    class DrugStoreController < ApplicationController
      before_action :authenticate_user!, except: %i[show search_near]
      before_action :configure_google_Service, only: :search_near

      before_action :set_drugstore, only: [:add_product]
      before_action :verify_ownership, only: [:add_product]

      def create
        drugstore = ::DrugStore.new(permitted_params)
        drugstore.user = current_user
        drugstore.save!
        render json: drugstore, status: :ok
      end

      def show_all
        render json: current_user.drug_stores.map(&:sanitized_info), status: :ok
      end

      def add_product
        product = ::Product.find(params[:product_id])
        inventory_item = ::Inventory.create!(
          drug_store: @drugstore,
          product: product,
          quantity: params[:quantity] || 10,
          sale_price: params[:sale_price] || product.price
        )
        render json: { status: 'successful', inventory_item: inventory_item }
      rescue StandardError => e
        render json: { status: 'failed', message: e.message }, status: :bad_request
      end

      def last_week_status
        orders = ::Order.where('created_at >= :date AND user_id = :user_id', date: 1.week.ago, user_id: current_user[:id]).map(&:sanitized_info)
        total_price = 0

        if orders.any?
          orders.each do |order|
            total_price += order[:total]
          end

        end

        render json: {
          statistics: {
            total_price_orders: total_price,
            total_orders: orders.size,
            customers_orders: orders.map(&:sanitized_info)
          }
        }, status: :ok
      end

      def show
        drugstore = ::DrugStore.find(params[:drugstore_id])
        render json: drugstore.sanitazed_info, status: :ok
      rescue ActiveRecord::RecordNotFound => _e
        render json: 'Drugstore does not exist.', status: :not_found
      end

      def append_image
        drugstore = current_user.drug_stores.find(params[:drugstore_id])
        drugstore.pictures.attach(params[:image])
        render json: drugstore.pictures.map { |picture|
          {
            picture_data: picture, url: url_for(picture)
          }
        }, status: :ok
      rescue StandardError => _e
        if ::DrugStore.where(id: params[:drugstore_id]).first.present?
          render json: 'User is not allowed to perform this action.', status: :unauthorized
        else
          render json: 'This object does not exist.', status: :not_found
        end
      end

      def search_near
        nearbies = []
        stores = []
        debug_values = []

        destinations = ''
        ::DrugStore.find_each do |store|
          if store == ::DrugStore.last
            destinations = destinations + store[:latitude].to_s + '%2C' + store[:longitude].to_s
          else
            destinations = destinations + store[:latitude].to_s + '%2C' + store[:longitude].to_s + '%7C'
          end
          stores.push(store)
        end

        if destinations.empty?
          render json: {
            message: 'There are no drug stores created.'
          }, status: :ok
        else
          response = open("https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=#{params[:latitude]},#{params[:longitude]}&destinations=#{destinations}&key=AIzaSyA6p9-yG5S0jb7CtGAFFo07Dk3eMV2lyZg").read
          result = JSON.parse(response)

          elements = result['rows'][0]['elements']

          idx = 0
          elements.each do |e|
            puts 'element: '
            if e['distance']['value'] < 30_000
              nearbies.push(store: stores[idx], matrix: e)
            end
            idx += 1
          end

          render json: { result: nearbies, debug_value: debug_values, destinations: destinations }, status: :ok
        end
      end

      private

      def configure_google_Service
        # Setup global parameters
        ::GoogleMapsService.configure do |config|
          config.key = 'AIzaSyA6p9-yG5S0jb7CtGAFFo07Dk3eMV2lyZg'
          config.retry_timeout = 20
          config.queries_per_second = 10
        end

        # Initialize client using global parameters
        @gmaps = ::GoogleMapsService::Client.new
      end

      def permitted_params
        params.require('drug_store').permit(:name, :description, :latitude, :longitude, :phone_number)
      end

      def set_drugstore
        @drugstore = ::DrugStore.find(params[:drugstore_id])
      rescue StandardError => e
        render json: { status: 'failed', mesaage: e.message }, status: :bad_request
        nil
      end

      def verify_ownership
        unless current_user.has_role? :owner, @drugstore
          render json: { status: 'failed', message: 'User does not have admin privileges.' }, status: :unauthorized
          nil
        end
      end
    end
  end
end
