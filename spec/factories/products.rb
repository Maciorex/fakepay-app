# frozen_string_literal: true

FactoryBot.define do
  factory :product, class: Product do
    name { Faker::Music::PearlJam.song }
    price { Faker::Number.number(digits: 4) }
    valid_for { 'Month' }
    uuid { SecureRandom.uuid }
  end
end
