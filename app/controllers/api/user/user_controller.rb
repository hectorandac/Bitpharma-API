# frozen_string_literal: true

module Api
  module User
    class UserController < ApplicationController
      before_action :authenticate_user!
      before_action :verify_admin, only: :append_role

      api :POST, '/user/profile_picture', 'Modify user picture'
      param :image, File, required: true, desc: 'User image'
      header :Authorization, 'Token that identifies the user', required: true
      def add_profile_picture
        current_user.profile_image.attach(params[:image])
        render json: {
            location: rails_blob_path(current_user.profile_image, disposition: "attachment", only_path: true)
        }, status: :ok
      end

      api :PATCH, '/user/role', 'Add roles to the user'
      param :user_id, String, required: true, desc: 'User to which we want to change its role'
      param :user_role, String, required: true, desc: 'Desired role'
      header :Authorization, 'Token that identifies the admin user', required: true
      def append_role
        target_user = ::User.find(params[:user_id])
        target_user.assign_role(params[:user_role])
        render json: target_user.sanitized_info, status: :ok
      end

      api :GET, '/user', 'Get user information'
      header :Authorization, 'Token that identifies the user', required: true
      def show
        render json: current_user.sanitized_info, status: :ok
      end

      api :PATCH, '/user', 'Modify user information'
      header :Authorization, 'Token that identifies the user', required: true
      param :complete_name, String, desc: 'Complete user name'
      def update
        current_user.update!(modify_params)
        render json: current_user.sanitized_info, status: :ok
      end

      private

      def modify_params
        params.require('user').permit(:complete_name, :phone_number, :address)
      end

    end
  end
end
