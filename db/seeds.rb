User.create!(name: "Example User",
  email: "user@gmail.com",
  password: "user123",
  password_confirmation: "user123",
  role: 1,
  activated: true
)
10.times do |n|
  name = Faker::Name.name
  email = "example#{n+1}@project.org"
  password = "password"
  User.create!(name: name,
    email: email,
    password: password,
    password_confirmation: password,
    activated: true
  )
end

category = ["Dell", "HP", "Lenovo", "Macbook"]

3.times do |n|
  Category.create(name: category[n])
end

50.times do |n|
  category_id = 1
  category_id = 2 if n > 25
  Product.create(
    name: Faker::Lorem.sentence,
    category_id: category_id,
    price: 1000 + n * 100,
    quantity: 10,
    description: Faker::Lorem.paragraph_by_chars,
  )
end

10.times do |n|
  Address.create(
    user_id: n + 1,
    address_detail: Faker::Address.street_address,
    phone: Faker::PhoneNumber.phone_number,
  )
end

10.times do |n|
  user_id = n + 1
  address_id = n + 1
  o = Order.new user_id: user_id, address_id: address_id
  o.order_details.build product_id: 1, quantity: 1, price: 1000 + n * 100
  o.save!
end

