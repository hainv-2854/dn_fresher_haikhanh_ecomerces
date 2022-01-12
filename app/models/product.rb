class Product < ApplicationRecord
  belongs_to :category
  has_many :order_details, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one_attached :image

  validates :quantity, presence: true,
             numericality: {only_integer: true,
                            greater_than_or_equal_to: Settings.length.zero}

  scope :order_by_name, ->{order :name}
  scope :sort_by_price, ->{order :price}
end
