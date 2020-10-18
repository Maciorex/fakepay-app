# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'validations' do
    it 'validates name' do
      expect(build(:product, name: '')).not_to be_valid
    end

    it 'validates price' do
      expect(build(:product, price: '')).not_to be_valid
    end

    it 'validates valid_for' do
      expect(build(:product, valid_for: '')).not_to be_valid
    end
  end
end
