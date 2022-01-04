class Product < ApplicationRecord
  belongs_to :category
  has_many :order_details, dependent: :destroy
  has_many :comments, dependent: :destroy
  scope :sort_by_price, ->{order :price}
end
