# frozen_string_literal: true

class Product < ApplicationRecord
  has_many :subscriptions

  validates :name, presence: true
  validates :price_in_cents, presence: true
  validates :uuid, presence: true, uniqueness: true
end
