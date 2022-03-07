json.carts @cart_items do |cart_item|
  json.product_id cart_item.dig(:product).id
  json.product_name cart_item.dig(:product).name
  json.(cart_item, :quantity_order, :total_price_item)
end
json.total_price_cart @total_price_cart
