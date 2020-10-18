# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'validations' do
    it 'validates name' do
      expect(build(:customer, name: '')).not_to be_valid
    end

    it 'validates address' do
      expect(build(:customer, address: '')).not_to be_valid
    end

    it 'validates zip_code' do
      expect(build(:customer, zip_code: '')).not_to be_valid
    end
  end
end
