# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

{ 'Bronze Box': '1999', 'Silver Box': '4900', 'Gold Box': '9900' }.each do |name, price|
  Product.create(
    name: name,
    price: price,
    valid_for: 'Month',
    uuid: SecureRandom.uuid
  )
end
