# frozen_string_literal: true

class Api::User::OrderController < ApplicationController
  before_action :authenticate_user!

  api :GET, '/user/orders', 'Get user orders'
  def show
    render json: current_user.orders.sanitize_info, status: :ok
  end

end
