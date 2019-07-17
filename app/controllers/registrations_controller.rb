# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  api :POST, '/sign_up', 'Create an user'
  param :user, Hash, required: true, desc: 'User info' do
    param :email, String, desc: 'User email'
    param :password, String, desc: 'User password'
    param :complete_name, String, desc: 'User name'
    param :address, String, desc: 'User address'
  end
  def create
    build_resource(sign_up_params)

    resource.save

    ::Address.create(address: params[:user][:address],
                     latitude: '0.0000000',
                     longitude: '0.00000',
                     user: resource)
    render_resource(resource)
  end

  private

  def sign_up_params
    params.require('user').permit(:email, :complete_name, :password)
  end
end
