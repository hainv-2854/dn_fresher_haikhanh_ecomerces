class OrderSerializer < ActiveModel::Serializer
  attributes :id, :status, :total, :created_at, :updated_at
  belongs_to :user
  belongs_to :address
  has_many :order_details, dependent: :destroy

  enum status: {pending: 0, accept: 1, resolved: 2, rejected: 3, canceled: 4}
end
