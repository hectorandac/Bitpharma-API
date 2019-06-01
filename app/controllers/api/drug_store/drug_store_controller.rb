# frozen_string_literal: true

module Api
  module DrugStore
    class DrugStoreController < ApplicationController
      before_action :authenticate_user!, except: [:show, :search_near]
      before_action :configure_google_Service, only: :search_near

      def create
        drugstore = ::DrugStore.new(permitted_params)
        drugstore.user = current_user
        drugstore.save!
        render json: drugstore, status: :ok
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

      api :GET, '/drug_store/search', 'Retrieve a set of near drug stores'
      param :latitude, String, required: true, desc: 'location latitude of the user'
      param :longitude, String, required: true, desc: 'location longitude of the user'
      param :max_distance, String, require: true, desc: 'Max distance allowed between current user and drug stores'
      def search_near

        nearbies = []
        stores = []
        debug_values = []

        destinations = ""
        ::DrugStore.find_each do |store|
          if store == ::DrugStore.last
            destinations = destinations + store[:latitude].to_s + "%2C" + store[:longitude].to_s
          else
            destinations = destinations + store[:latitude].to_s + "%2C" + store[:longitude].to_s + "%7C"
          end
          stores.push(store)
        end

        if destinations.empty?
          render json: {
              message: "There are no drug stores created."
          }, :status => :ok
        else
          response = open("https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=#{params[:latitude]},#{params[:longitude]}&destinations=#{destinations}&key=AIzaSyA6p9-yG5S0jb7CtGAFFo07Dk3eMV2lyZg").read
          result = JSON.parse(response)

          elements = result['rows'][0]['elements']

          idx = 0
          elements.each do |e|
            puts 'element: '
            if e['distance']['value'] < 30000
              nearbies.push({store: stores[idx], matrix: e})
            end
            idx = idx + 1
          end

          render json: { result: nearbies, debug_value: debug_values, destinations: destinations }, :status => :ok
        end

      end

      private

      # TODO: Move this into a config file
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
        params.require('drug_store').permit(:name, :description, :latitude, :longitude)
      end
    end
  end
end
