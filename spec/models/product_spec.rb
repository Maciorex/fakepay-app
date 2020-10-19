# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'validations' do
    it 'validates name' do
      expect(build(:product, name: '')).not_to be_valid
    end

    it 'validates price_in_cents' do
      expect(build(:product, price_in_cents: '')).not_to be_valid
    end
  end
end
