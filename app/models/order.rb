# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :products

  after_create :add_initial_status
  after_update :notify_create
  after_update :notify_to_user

  def add_initial_status
    update!(state: 'new')
    notify_create
  end

  def update(new_state)
    update!(state: new_state)
  end

  def sanitized_info
    {
      id: id,
      total: total,
      itbis: itbis,
      state: state,
      user: user.sanitized_info,
      products: products.map(&:sanitized_info)
    }
  end

  def notify_to_users
    ActionCable.server.broadcast("my_orders_#{user.id}", sanitized_info)
  end

  def notify_create
    orders_new = ::Order.all
                    .limit(100)
                    .offset(0)
                    .order(updated_at: :desc)
                    .where(state: 'new')

    orders_progress = ::Order.all
                          .limit(100)
                          .offset(0)
                          .order(updated_at: :desc)
                          .where(state: 'progress')

    orders_delivery = ::Order.all
                          .limit(100)
                          .offset(0)
                          .order(updated_at: :desc)
                          .where(state: 'delivered')

    ActionCable.server.broadcast(
      'order_notification_channel_new',
      {orders_new: orders_new.map(&:sanitized_info),
       orders_progress: orders_progress.map(&:sanitized_info), orders_delivery: orders_delivery.map(&:sanitized_info)}
    )
  end
end
