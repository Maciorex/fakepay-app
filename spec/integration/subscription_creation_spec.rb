# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::SubscriptionsController, type: :controller do
  describe 'POST create' do
    let!(:params) do
      {

        subscription:
        {
          customer_name: 'Lucas Braathen',
          address: 'asd',
          zip_code: '51-986',
          card_number: '123123',
          cvv: '123',
          card_expiration_date: Date.today + 3.years,
          billing_zip_code: '56-986',
          product_id: 1
        }
      }
    end

    it 'creates' do
      post :create, { params: params }
    end
  end
end
