# frozen_string_literal: true

class Subscription < ApplicationRecord
  belongs_to :customer
  belongs_to :product

  validates :customer_id, presence: true
  validates :product_id, presence: true
  validates :subscribe_date, presence: true
  validates :expiration_date, presence: true
end
