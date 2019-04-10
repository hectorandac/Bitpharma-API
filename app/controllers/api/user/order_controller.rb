# frozen_string_literal: true

class Api::User::OrderController < ApplicationController
  before_action :authenticate_user!

  api :GET, '/user/orders', 'Get user orders'
  def show
    render json: current_user.orders.map(&:sanitized_info), status: :ok
  end

  api :GET, '/user/orders/single', 'Get order details'
  def show_single
    render json: current_user.orders.find(params[:order_id]).sanitized_info, status: :ok
  end

end
