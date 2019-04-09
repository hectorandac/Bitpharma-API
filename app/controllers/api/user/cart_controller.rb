class Api::User::CartController < ApplicationController

  api :POST, '/user/cart/product', 'Add a product to the cart'
  param :product_id, String, required: true, desc: 'Id of the product that the user wants to add'
  header :Authorization, 'Token that identifies the user', required: true
  def append_product
    current_user.products << Product.find(params[:product_id])
    show_cart
  rescue StandardError => _e
    render json: { message: 'Verify that the product exists' }, status: :bad_request
  end

  api :DELETE, '/user/cart/product', 'Remove a product from a user cart'
  param :product_id, String, required: true, desc: 'Id of the product that the user wants to remove'
  header :Authorization, 'Token that identifies the user', required: true
  def remove_product
    current_user.products.delete Product.find(params[:product_id])
    show_cart
  rescue StandardError => _e
    render json: { message: 'Verify that the product exists' }, status: :bad_request
  end

  api :GET, '/user/cart/product', 'Get the cart products information'
  header :Authorization, 'Token that identifies the user', required: true
  def show_cart
    render json: current_user.products.map(&:sanitized_info), status: :ok
  end
end
