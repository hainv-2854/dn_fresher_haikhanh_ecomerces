User.create!(name: "Example User",
  email: "user@gmail.com",
  password: "user123",
  password_confirmation: "user123",
  is_role: 1,
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
