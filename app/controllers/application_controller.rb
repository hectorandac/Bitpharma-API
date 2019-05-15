# frozen_string_literal: true

require 'stripe'
require 'google_maps_service'
require 'net/http'
require 'open-uri'

# General Application controller
class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  Stripe.api_key = 'sk_test_2iqpMIbPvxjeVtoYKdN9hgj900TfPvurTi'
  respond_to :json

  def render_resource(resource)
    if resource.errors.empty?
      render json: resource
    else
      validation_error(resource)
    end
  end

  def index
    render json: {test: 'main'}, status: :ok
  end

  def validation_error(resource)
    render json: {
      errors: [
        {
          status: '400',
          title: 'Bad Request',
          detail: resource.errors,
          code: '100'
        }
      ]
    }, status: :bad_request
  end

  def verify_admin
    unless current_user.has_role? :admin
      render json: { message: 'User does not have admin privileges.' }, status: :unauthorized
      nil
    end
  end
end
