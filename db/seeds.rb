# frozen_string_literal: true

{ 'Bronze Box': '1999', 'Silver Box': '4900', 'Gold Box': '9900' }.each do |name, price|
  Product.create(
    name: name,
    price_in_cents: price,
    valid_for: 'Month',
    uuid: SecureRandom.uuid
  )
end
