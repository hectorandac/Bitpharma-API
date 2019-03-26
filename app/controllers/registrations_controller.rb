# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  api :POST, '/sign_up', "Create an user"
  param :user, Hash, required: true, desc: 'User info' do
    param :email, String, desc: 'User email'
    param :password, String, desc: 'User password'
    param :first_name, String, desc: 'User first name'
    param :last_name, String, desc: 'User last name'
  end
  def create
    build_resource(sign_up_params)

    resource.save
    render_resource(resource)
  end

  private

  def sign_up_params
    params.require('user').permit(:email, :first_name, :last_name, :password)
  end

end
