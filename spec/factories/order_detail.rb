FactoryBot.define do
  factory :order_detail do
    order {FactoryBot.create :order}
    product {FactoryBot.create :product}
    quantity {rand(1..5)}
    price {rand(100..1000)}
  end
end
