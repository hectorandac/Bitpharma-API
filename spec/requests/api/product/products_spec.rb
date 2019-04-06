require 'rails_helper'

RSpec.describe "Api::Product::Products", type: :request do
  describe "GET /api/product/products" do
    it "works! (now write some real specs)" do
      get api_product_products_path
      expect(response).to have_http_status(200)
    end
  end
end
