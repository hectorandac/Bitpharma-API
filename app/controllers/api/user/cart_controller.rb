class Api::User::CartController < ApplicationController

  def append_product
    current_user.products << Product.find(params[:product_id])
    show_cart
  rescue StandardError => _e
    render json: { message: 'Verify that the product exists' }, status: :bad_request
  end

  def remove_product
    current_user.products >> Product.find(params[:product_id])
    show_cart
  rescue StandardError => _e
    render json: { message: 'Verify that the product exists' }, status: :bad_request
  end

  def show_cart
    render json: current_user.products.map(&:sanitized_info), status: :ok
  end

end
