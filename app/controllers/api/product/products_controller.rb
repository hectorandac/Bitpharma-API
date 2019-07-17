# frozen_string_literal: true

class Api::Product::ProductsController < ApplicationController
  before_action :set_api_product_product, only: %i[show update destroy append_images]
  before_action :authenticate_user!, only: :create
  # before_action :verify_admin, only: :create

  # GET /api/product/products
  def index
    @api_product_products = ::Product.all

    render json: @api_product_products
  end

  # GET /api/product/products/1
  def show
    render json: @api_product_product
  end

  def query
    render json: ::Product.search(params[:query]).map(&:sanitized_info), status: :ok
  end

  def create
    @api_product_product = ::Product.new(api_product_product_params)

    if @api_product_product.save
      render json: @api_product_product.sanitized_info, status: :created, location: @api_product_product
    else
      render json: @api_product_product.errors, status: :unprocessable_entity
    end

  rescue StandardError => e
    render json: { status: :failed, message: e.message }, status: :ok
  end

  def append_images
    @api_product_product.pictures.attach(params[:image])
    render json: @api_product_product.sanitized_info
  end

  def update
    if @api_product_product.update(api_product_product_params)
      render json: @api_product_product
    else
      render json: @api_product_product.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @api_product_product.destroy
  end

  def reindex
    ::Product.reindex
    render json: {
        message: 'Reindex successful', :status => :ok
    }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_api_product_product
    @api_product_product = ::Product.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def api_product_product_params
    params.require(:product).permit(:name, :description, :barcode, :price, :selling_dose, :selling_unit)
  end
end
