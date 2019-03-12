# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  api :POST, '/sign_up', "Create an user"
  param :user, Hash, required: true, desc: 'User info' do
    param :email, String, desc: 'User email'
    param :password, String, desc: 'User password'
  end
  def create
    build_resource(sign_up_params)

    resource.save
    render_resource(resource)
  end
end
