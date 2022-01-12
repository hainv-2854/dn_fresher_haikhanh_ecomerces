class Order < ApplicationRecord
  belongs_to :user
  belongs_to :address
  has_many :order_details, dependent: :destroy
  delegate :name, to: :user, prefix: true
  delegate :phone, :address_detail, to: :address, prefix: true

  enum status: {pending: 0, accept: 1, resolved: 2, rejected: 3, canceled: 4}

  scope :recent_orders, ->{order(status: :asc, created_at: :desc)}

  def calculate_total
    order_details.reduce(0) do |total, item|
      total + item.quantity * item.price
    end
  end

  private

  def restore_product_quantity_when_rejected
    order_details.each do |order_detail|
      product = order_detail.product
      product.update!(quantity: product.quantity + order_detail.quantity)
    end
  end

  def restore_product_quantity_when_accept
    # send email to user
  end

  def restore_product_quantity_when_resolved
    update(delivered_at: Time.zone.now)
  end
end
