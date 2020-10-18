# frozen_string_literal: true

class Customer < ApplicationRecord
  has_many :subscriptions

  validates :name, presence: true
  validates :address, presence: true
  validates :zip_code, presence: true
end
