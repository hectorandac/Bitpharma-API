class Order < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :products

  after_create :add_initial_status

  def add_initial_status
    update!(state: 'new')
  end

  def sanitized_info
    {
      id: id,
      total: total,
      itbis: itbis,
      state: state,
      user: user.sanitized_info,
      products: products
    }
  end

end
