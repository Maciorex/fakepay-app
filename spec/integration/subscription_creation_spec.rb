# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::SubscriptionsController, type: :controller do
  let!(:products) do
    create(:product, name: 'Bronze Box', price: '1999', uuid: '11111111-1111-1111-1111-111111111111')
    create(:product, name: 'Silver Box', price: '4900', uuid: '22222222-1111-1111-1111-111111111111')
    create(:product, name: 'Gold Box', price: '9900', uuid: '33333333-1111-1111-1111-111111111111')
  end

  describe 'POST create' do
    let!(:params) do
      {

        subscription:
        {
          customer_name: 'Lucas Braathen',
          address: 'asd',
          zip_code: '51-986',
          card_number: '4242424242424242',
          cvv: '123',
          card_expiration_date: Date.today + 3.years,
          billing_zip_code: '10045',
          product_uuid: '11111111-1111-1111-1111-111111111111'
        }
      }
    end

    it 'creates' do
      post :create, { params: params }
    end
  end
end
