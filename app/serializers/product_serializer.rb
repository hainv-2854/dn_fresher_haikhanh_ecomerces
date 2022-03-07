class ProductSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :price, :quantity, :description, :created_at, :updated_at
  belongs_to :category
  has_many :order_details, dependent: :destroy
end
