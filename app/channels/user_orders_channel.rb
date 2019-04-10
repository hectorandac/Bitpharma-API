class UserOrdersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "my_orders_#{parmas[:user_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
