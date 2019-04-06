# frozen_string_literal: true

module Api
  module Order
    class OrderController < ApplicationController
      before_action :authenticate_user!
      before_action :verify_admin

      def show
        orders = ::Order.all
                        .limit(params[:limit] || 20)
                        .offset(params[:offset] || 0)
                        .order(id: :desc)
                        .where(state: params[:status])
        render json: orders.map(&:sanitized_info), status: :ok
      end

      def show_single
        order = ::Order.find(params[:order_id])
        render json: order.sanitized_info, status: :ok
      end

      def update_state
        order = ::Order.find(params[:order_id])
        order.update!(state: params[:state])
        order_info = show_single
        ::ActionCable.server.broadcast('orders_channel', order_info.to_json)
        order_info
      end

      private

      def modify_params
        params.require('user').permit(:first_name, :last_name)
      end
    end
  end
end
