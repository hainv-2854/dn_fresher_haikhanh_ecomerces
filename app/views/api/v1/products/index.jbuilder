json.products @products do |product|
  json.(product, :id, :name, :quantity, :price, :description, :created_at)
  json.category do
    json.partial! "api/v1/categories/category", category: product.category
  end
end
