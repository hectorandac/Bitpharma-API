# frozen_string_literal: true

module Api
  module User
    class PaymentMethodController < ApplicationController
      before_action :authenticate_user!
      before_action :set_stripe_customer

      api :POST, '/user/payment_method', 'Add payment method'
      param :source_token, String, required: true, desc: 'Payment method stripe id'
      header :Authorization, 'Token that identifies the user', required: true
      def add_payment_method
        if @stripe_customer
          Stripe::Customer.create_source(
            @stripe_customer.id,
            source: params[:source_token]
          )
        else
          @stripe_customer = Stripe::Customer.create(
            description: "Customer for #{current_user.email}",
            source: params[:source_token],
            email: current_user.email
          )
          current_user.update!(stripe_id: @stripe_customer.id)
        end
        render json: { message: 'created' }, status: :ok
      rescue StandardError => _e
        render json:
                   { message: 'Verify the validity of your payment method' },
               status: :bad_request
      end

      api :GET, '/user/payment_method', 'Get a list of a user payment methods'
      header :Authorization, 'Token that identifies the user', required: true
      def retrieve_payment_methods
        render json: @stripe_customer.sources, status: :ok
      rescue StandardError => _e
        render json: { message: 'Something happened, are you sure yo have payment methods' }, status: :bad_request
      end

      api :DELETE, '/user/payment_method', 'Removes an specific payment method'
      header :Authorization, 'Token that identifies the user', required: true
      param :source_id, String, required: true, desc: 'Payment method stripe id'
      def remove_payment_method
        Stripe::Customer.detach_source(
          @stripe_customer.id,
          params[:source_id]
        )
        render json: { message: 'deleted' }, status: :ok
      rescue StandardError => _e
        render json: { message: 'Something happened, are you sure you have this payment method' }, status: :bad_request
      end

      api :PATCH, '/user/payment_method', 'Change default user payment method'
      header :Authorization, 'Token that identifies the user', required: true
      param :source_id, String, required: true, desc: 'Payment method stripe id'
      def modify_default
        Stripe::Customer.update(
          @stripe_customer.id,
          default_source: params[:source_id]
        )

        render json: { message: 'modified' }, status: :ok
      rescue StandardError => _e
        render json: { message: 'Something happened, are you sure yo have payment methods' }, status: :bad_request
      end

      private

      def set_stripe_customer
        stripe_id = current_user.stripe_id
        if stripe_id.present?
          @stripe_customer = Stripe::Customer.retrieve(stripe_id)
        end
      end
    end
  end
end
