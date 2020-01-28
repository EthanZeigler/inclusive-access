# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# Create the global configuration
AppConfig.create!(name: "MyApp", logo_url: "hhhhhhh")

# Create two user profiles, admin and unprivledged user
admin = User.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
user = User.create!(email: 'user@example.com', password: 'password', password_confirmation: 'password')