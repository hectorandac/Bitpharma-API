# frozen_string_literal: true

class Api::User::CartController < ApplicationController
  before_action :authenticate_user!

  api :POST, '/user/cart/product', 'Add a product to the cart'
  param :product_id, String, required: true, desc: 'Id of the product that the user wants to add'
  header :Authorization, 'Token that identifies the user', required: true
  def append_product
    (params[:qty] || 1).to_i.times do
      current_user.products << Product.find(params[:product_id])
    end
    show_cart
  rescue StandardError => _e
    render json: { message: 'Verify that the product exists', error: _e }, status: :bad_request
  end

  api :DELETE, '/user/cart/product', 'Remove a product from a user cart'
  param :product_id, String, required: true, desc: 'Id of the product that the user wants to remove'
  header :Authorization, 'Token that identifies the user', required: true
  def remove_product
    products = current_user.products
    product_to_delete = products.find(params[:product_id])
    products.delete product_to_delete
    show_cart
  rescue StandardError => _e
    render json: { message: 'Verify that the product exists' }, status: :bad_request
  end

  api :GET, '/user/cart/product', 'Get the cart products information'
  header :Authorization, 'Token that identifies the user', required: true
  def show_cart
    render json: compound(current_user.products.map(&:sanitized_info)), status: :ok
  end

  private

  def get_index(object_id, array)
    counter = 0
    array.each do |element|
      element[:id] == object_id ? (return counter) : (counter += 1)
    end
    -1
  end

  def compound(array)
    compound_elements = []
    array.each do |element|
      position = get_index(element[:id], compound_elements)
      if position >= 0
        puts position
        compound_elements[position][:qty] += 1
      else
        compound_elements << element
      end
    end
    puts compound_elements
    compound_elements
  end
end
