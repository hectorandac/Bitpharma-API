# frozen_string_literal: true

module Api
  module Order
    class OrderController < ApplicationController
      before_action :authenticate_user!, except: :create_demo
      before_action :verify_admin, except: :create_demo

      def create_demo
        products = Product.all
        total = products.map(&:price).sum
        ::Order.create!(total: total, itbis: (total * 0.18), user_id: 3, products: products)
        render json: 'Sent', status: :ok
      end

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
        params.require('user').permit(:complete_name)
      end
    end
  end
end
