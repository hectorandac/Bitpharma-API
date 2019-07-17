# frozen_string_literal: true

module Api
  module Order
    class OrderController < ApplicationController
      before_action :authenticate_user!
      before_action :set_drugstore, except: :personal
      before_action :verify_ownership, except: :personal

      def personal
        orders = current_user.orders
                     .limit(params[:limit] || 20)
                     .offset(params[:offset] || 0)
                     .order(id: :desc)
                     .where(state: params[:status])
        render json: orders.map(&:sanitized_info), status: :ok
      end

      def show
        orders = @drugstore.orders.all
                        .limit(params[:limit] || 20)
                        .offset(params[:offset] || 0)
                        .order(id: :desc)
                        .where(state: params[:status])
        render json: orders.map(&:sanitized_info), status: :ok
      end

      def show_single
        order = @drugstore.orders.find(params[:order_id])
        render json: order.sanitized_info, status: :ok
      end

      def update_state
        order = @drugstore.orders.find(params[:order_id])
        order.update!(state: params[:state])
        order_info = show_single
        ::ActionCable.server.broadcast('order_notification_channel_new', order_info.to_json)
        order_info
      rescue
        render json: { status: 'failed', message: 'Verify ownership or existence of this order' }, status: :bad_request
      end

      private

      def set_drugstore
        @drugstore = ::DrugStore.find(params[:drugstore_id])
      end

      def modify_params
        params.require('user').permit(:complete_name)
      end

      def verify_ownership
        unless current_user.has_role? :owner, @drugstore
          render json: { message: 'User does not have admin privileges.' }, status: :unauthorized
          nil
        end
      end
    end
  end
end
