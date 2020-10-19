# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::SubscriptionsController, type: :controller do
  let!(:product) do
    create(:product, name: 'Bronze Box', price_in_cents: '1999', uuid: '11111111-1111-1111-1111-111111111111')
  end

  describe 'POST /api/v1/subscriptions' do
    subject { post :create, { params: valid_params } }

    let(:valid_params) do
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
          product_uuid: '11111111-1111-1111-1111-111111111111',
          months_valid: 5
        }
      }
    end
    let(:creation_handler_service) { instance_double(Subscriptions::CreationHandler) }
    let(:service_response) do
      {
        status: 200,
        body: { token: 'cb93b2f036eb849320cb4c685f66c4', success: true, error_code: nil }
      }
    end

    before do
      allow(Subscriptions::CreationHandler).to receive(:new).and_return(creation_handler_service)
      allow(creation_handler_service).to receive(:call).and_return(service_response)
    end

    context 'response successfull' do
      it 'calls creation handler service' do
        expect(creation_handler_service).to receive(:call)

        subject
      end

      it 'returns 200 with message' do
        subject
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq('Subscription created succesfully')
      end
    end

    context 'erronous response' do
      let(:service_response) do
        {
          status: 422,
          body: { token: nil, success: false, error_code: 1000004 }
        }
      end

      it 'calls creation handler service' do
        expect(creation_handler_service).to receive(:call)

        subject
      end

      it 'returns 422 with error message' do
        subject
        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)).to eq('Error: Expired card')
      end
    end
  end
end
