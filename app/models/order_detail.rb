class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :product
  delegate :name, to: :product, prefix: true

  acts_as_paranoid

  after_create :change_product_quantity

  private

  def change_product_quantity
    product.update(quantity: product.quantity - quantity)
  end
end
