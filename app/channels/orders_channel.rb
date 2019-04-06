class OrdersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "orders_channel"
  end

  def create
    order = ::Order.update('progress')
    OrdersChannel.broadcast('orders_chanel', order.to_json)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
