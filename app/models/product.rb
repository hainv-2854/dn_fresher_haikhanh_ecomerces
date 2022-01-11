class Product < ApplicationRecord
  belongs_to :category
  has_many :order_details, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one_attached :image

  scope :order_by_name, ->{order :name}
  scope :sort_by_price, ->{order :price}
end
