json.orders @orders do |order|
  json.(order, :id, :status, :total, :created_at)
  json.user do
    json.partial! "api/v1/users/user", user: order.user
  end
  json.address do
    json.partial! "api/v1/addresses/address", address: order.address
  end
  json.order_details order.order_details do |order_detail|
    json.(order_detail, :id, :quantity, :created_at)
    json.product do
      json.partial! "api/v1/products/product", product: order_detail.product
    end
  end
end
