FactoryBot.define do
  factory :address do
    user {FactoryBot.create :user}
    address_detail {Faker::Address.full_address}
    phone {Faker::Number.number(digits: 11)}
    is_default {false}
  end
end
