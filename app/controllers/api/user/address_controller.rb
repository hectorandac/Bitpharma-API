module Api
  module User
    class AddressController < ApplicationController
      before_action :authenticate_user!

      def show
        render json: current_user.addresses, status: :ok
      end

      def create
        address = ::Address.create(address: params[:address], latitude: params[:latitude], longitude: params[:longitude], user: current_user)
        render json: address, status: :ok
      end
    end
  end
end
