# frozen_string_literal: true

class Api::User::PaymentsController < Api::User::PaymentMethodController
  api :POST, '/user/cart/pay', 'Perform cart payment with default user source'
  header :Authorization, 'Token that identifies a user', required: true
  def perform_payment
    is_cash = (params[:payment_method] === 'cash')
    status = 'pending'
    products = current_user.products
    unless is_cash
      total = products.map(&:price).sum
      total_stripe_format = (total * 100).to_i

      charge = Stripe::Charge.create(
        amount: total_stripe_format,
        currency: 'dop',
        customer: @stripe_customer,
        description: "Pago de productos #{current_user.email}"
      )
      status = charge.status
    end

    if status == 'succeeded' || is_cash
      order = convert_to_order(products)
      order.update!(payment_method: is_cash ? 'cash' : 'card')
      current_user.products.clear
      render json: order.sanitized_info, status: :ok
    else
      render json: {
        message: 'Something happened while charging your primary payment method',
        payment_status: charge.status
      }, status: :conflict
    end
  end

  private

  def convert_to_order(products)
    total = products.map(&:price).sum

    ::Order.create!(
      total: total,
      itbis: total * 0.18,
      user: current_user,
      drug_store: DrugStore.last,
      products: products
    )
  end
end
