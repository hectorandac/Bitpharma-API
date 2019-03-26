# frozen_string_literal: true

module Api
  module DrugStore
    class DrugStoreController < ApplicationController
      before_action :authenticate_user!, except: :show

      def create
        drugstore = ::DrugStore.new(permitted_params)
        drugstore.user = current_user
        drugstore.save!
        render json: drugstore, status: :ok
      end

      def show
        drugstore = ::DrugStore.find(params[:drugstore_id])
        render json: drugstore, status: :ok
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

      private

      def permitted_params
        params.require('drug_store').permit(:name, :description)
      end
    end
  end
end
