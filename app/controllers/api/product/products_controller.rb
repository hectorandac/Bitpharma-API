# frozen_string_literal: true

class Api::Product::ProductsController < ApplicationController
  before_action :set_api_product_product, only: %i[show update destroy append_images]

  # GET /api/product/products
  def index
    @api_product_products = ::Product.all

    render json: @api_product_products
  end

  # GET /api/product/products/1
  def show
    render json: @api_product_product
  end

  api :GET, '/product/search', 'Retrieve a set of products that matches the terms sent in queries'
  param :query, String, required: true, desc: 'Set of terms to find a product'
  def query
    render json: ::Product.search(params[:query]).map(&:sanitized_info), status: :ok
  end

  # POST /api/product
  api :POST, '/product', 'Create a product as an admin'
  param :product, Hash, required: true, desc: 'Product info' do
    param :name, String, desc: 'Product name'
    param :description, String, desc: 'Product description'
    param :barcode, String, desc: 'Product barcode'
    param :price, String, desc: 'Products price'
    param :selling_dose, String, desc: 'Product selling dose'
    param :selling_unit, String, desc: 'Product selling unit'
  end
  def create
    @api_product_product = ::Product.new(api_product_product_params)

    if @api_product_product.save
      render json: @api_product_product.sanitized_info, status: :created, location: @api_product_product
    else
      render json: @api_product_product.errors, status: :unprocessable_entity
    end
  end

  api :POST, '/product/image', 'Appends an image to the images set'
  param :image, File, required: true, desc: 'The image you want to upload'
  def append_images
    @api_product_product.pictures.attach(params[:image])
    render json: @api_product_product.sanitized_info
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
    params.require(:product).permit(:name, :description, :barcode, :price, :selling_dose, :selling_unit)
  end
end
