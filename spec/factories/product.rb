FactoryBot.define do
  factory :product do
    name {Faker::Book.title}
    price {Faker::Number.between(from: 1000, to: 10000)}
    description {Faker::Books::Dune.character}
    quantity {Faker::Number.between(from: 10, to: 20)}
    category_id {create(:category).id}
  end
end
