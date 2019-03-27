# frozen_string_literal: true

# General Application controller
class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  respond_to :json

  def render_resource(resource)
    if resource.errors.empty?
      render json: resource
    else
      validation_error(resource)
    end
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
