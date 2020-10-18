# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subscription, type: :model do
  describe 'validations' do
    it 'validates customer_id' do
      expect(build(:subscription, customer_id: nil)).not_to be_valid
    end

    it 'validates product_id' do
      expect(build(:subscription, product_id: nil)).not_to be_valid
    end

    it 'validates subscribe_date' do
      expect(build(:subscription, subscribe_date: nil)).not_to be_valid
    end

    it 'validates expiration_date' do
      expect(build(:subscription, expiration_date: nil)).not_to be_valid
    end
  end
end
