# frozen_string_literal: true

FactoryBot.define do
  factory :customer, class: Customer do
    name { Faker::Name.name }
    address { Faker::Address.street_address }
    zip_code { Faker::Address.zip_code }
  end
end
