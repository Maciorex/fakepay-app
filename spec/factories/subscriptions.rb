# frozen_string_literal: true

FactoryBot.define do
  factory :subscription, class: Subscription do
    association :customer, factory: :customer
    association :product, factory: :product
    subscribe_date { Date.today }
    expiration_date { Date.today + 6.months }
  end
end
