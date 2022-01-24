FactoryBot.define do
  factory :order do
    user {FactoryBot.create :user}
    address {FactoryBot.create :address}
    status {rand(Order.statuses.values.first..Order.statuses.values.last)}
    total {rand(100..1000)}
    rejected_reason {Faker::Lorem.sentence}
  end
end
