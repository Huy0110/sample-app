# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Create a main sample user.
User.create!(name:  "Example User",
  email: "123@gmail.com",
  password:              "123456",
  password_confirmation: "123456",
  admin: true,
  activated: true,
  activated_at: Time.now)

# Generate a bunch of additional users.
5.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.now)
end

# Generate microposts for a subset of users.
users = User.order(:created_at).take(2)

10.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.microposts.create!(content: content) }
end

# Create following relationships.
users = User.all
user = users.first
following = users[2..10]
followers = users[3..9]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
