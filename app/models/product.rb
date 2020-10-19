# frozen_string_literal: true

class Product < ApplicationRecord
  has_many :subscriptions

  validates :name, presence: true
  validates :price, presence: true
  validates :valid_for, presence: true
  validates :uuid, presence: true, uniqueness: true
end
