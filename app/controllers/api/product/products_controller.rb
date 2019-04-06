# frozen_string_literal: true

class Api::Product::ProductsController < ApplicationController
  before_action :set_api_product_product, only: %i[show update destroy]
  before_action :authenticate_user!, only: :create

  # GET /api/product/products
  def index
    @api_product_products = ::Product.all

    render json: @api_product_products
  end

  # GET /api/product/products/1
  def show
    render json: @api_product_product
  end

  # POST /api/product/products
  def create
    @api_product_product = ::Product.new(api_product_product_params)

    if @api_product_product.save
      render json: @api_product_product, status: :created, location: @api_product_product
    else
      render json: @api_product_product.errors, status: :unprocessable_entity
    end
  end

  def append_images
    if @api_product_product.pictures.attach(params[:image])

    end
  end

  # PATCH/PUT /api/product/products/1
  def update
    if @api_product_product.update(api_product_product_params)
      render json: @api_product_product
    else
      render json: @api_product_product.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/product/products/1
  def destroy
    @api_product_product.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_api_product_product
    @api_product_product = ::Product.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def api_product_product_params
    params.fetch(:product, {})
  end
end
