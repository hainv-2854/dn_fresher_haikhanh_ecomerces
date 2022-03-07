class OrderDetailSerializer < ActiveModel::Serializer
  belongs_to :product
  belongs_to :order
end
