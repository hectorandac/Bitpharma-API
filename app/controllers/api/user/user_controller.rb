# frozen_string_literal: true

module Api
  module User
    class UserController < ApplicationController
      before_action :authenticate_user!
      before_action :verify_admin, only: :append_role

      def add_profile_picture
        current_user.profile_image.attach(params[:image])
      end

      def append_role
        target_user = ::User.find(params[:user_id])
        target_user.assign_role(params[:user_role])
        render json: target_user.sanitized_info, status: :ok
      end

      def show
        render json: current_user.sanitized_info, status: :ok
      end

      def update
        current_user.update!(modify_params)
        render json: current_user.sanitized_info, status: :ok
      end

      private

      def modify_params
        params.require('user').permit(:first_name, :last_name)
      end

    end
  end
end
