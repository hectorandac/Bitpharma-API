# frozen_string_literal: true

class OrderNotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'order_notification_channel_new'
  end

  def show_new
    orders = ::Order.all
                    .limit(params[:limit] || 100)
                    .offset(params[:offset] || 0)
                    .order(updated_at: :desc)
                    .where(state: 'new')

    ActionCable.server.broadcast(
      'order_notification_channel_new',
      orders
    )
  end

  def show_my_orders
    user = User.find(params[:user_id])
    orders = user.orders
    ActionCable.server.broadcast(
      "order_notification_user_#{params[:user_id]}",
      orders
    )
  end

  def unsubscribe
    # Any cleanup needed when channel is unsubscribed
  end
end
