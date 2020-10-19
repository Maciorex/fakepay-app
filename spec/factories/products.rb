# frozen_string_literal: true

FactoryBot.define do
  factory :product, class: Product do
    name { Faker::Music::PearlJam.song }
    price_in_cents { Faker::Number.number(digits: 4) }
    uuid { SecureRandom.uuid }
  end
end
