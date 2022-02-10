class Category < ApplicationRecord
  belongs_to :parent, class_name: Category.name, optional: true
  has_many :products, dependent: :destroy
  has_many :childrens, class_name: Category.name, foreign_key: :parent_id,
    dependent: :destroy

  scope :order_by_name, ->{order :name}
end
