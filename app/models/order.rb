class Order < ApplicationRecord
  belongs_to :user
  belongs_to :address
  has_many :order_details, dependent: :destroy
  delegate :name, to: :user, prefix: true
  delegate :phone, :address_detail, to: :address, prefix: true

  enum status: {pending: 0, accept: 1, resolved: 2, rejected: 3}

  scope :recent_orders, ->{order(status: :asc, created_at: :desc)}

  def calculate_total
    order_details.reduce(0) do |total, item|
      total + item.quantity * item.price
    end
  end
end
