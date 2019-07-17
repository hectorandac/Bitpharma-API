# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :products
  belongs_to :drug_store

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
      created_at: created_at,
      updated_at: updated_at,
      products: compound(products.map(&:sanitized_info)),
      payment_method: payment_method
    }
  end

  def notify_to_user
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



  private

  def get_index(object_id, array)
    counter = 0
    array.each do |element|
      element[:id] == object_id ? (return counter) : (counter += 1)
    end
    -1
  end

  def compound(array)
    compound_elements = []
    array.each do |element|
      position = get_index(element[:id], compound_elements)
      if position >= 0
        compound_elements[position][:qty] += 1
      else
        compound_elements << element
      end
    end
    compound_elements
  end
end
