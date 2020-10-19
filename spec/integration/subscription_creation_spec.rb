# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::SubscriptionsController, type: :controller do
  let!(:products) do
    create(:product, name: 'Bronze Box', price_in_cents: '1999', uuid: '11111111-1111-1111-1111-111111111111')
    create(:product, name: 'Silver Box', price_in_cents: '4900', uuid: '22222222-1111-1111-1111-111111111111')
    create(:product, name: 'Gold Box', price_in_cents: '9900', uuid: '33333333-1111-1111-1111-111111111111')
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

    subject { post :create, { params: params } }

    before do
      stub_request(:post, 'https://www.fakepay.io/purchase')
        .with(
          body: {
            amount: '1999',
            card_number: '4242424242424242',
            cvv: '123',
            expiration_month: '10',
            expiration_year: '2023',
            zip_code: '10045'
          }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        ).to_return(
          status: 200,
          body: '{"token":"111111111111111111","success":true,"error_code":null}',
          headers: {}
        )
    end

    context 'when customer does not exist' do
      it 'creates new customer record with proper data' do
        expect { subject }.to change { Customer.count }.by(1)
        expect(Customer.last.name).to eq('Lucas Braathen')
      end

      it 'creates new subscription record with proper data' do
        expect { subject }.to change { Subscription.count }.by(1)
        expect(Subscription.last.fakepay_token).to eq('111111111111111111')
      end

      it 'stes up correct subscription associations' do
        subject
        expect(Subscription.last.customer).to eq(Customer.find_by(name: 'Lucas Braathen'))
      end
    end

    context 'when customer exists' do
      let!(:customer) { create(:customer, name: 'Lucas Braathen', address: 'asd', zip_code: '51-986') }

      it 'does NOT create new customer record' do
        expect { subject }.not_to change { Customer.count }
      end

      it 'creates new subscription record with proper data' do
        expect { subject }.to change { Subscription.count }.by(1)
        expect(Subscription.last.fakepay_token).to eq('111111111111111111')
      end

      it 'stes up correct subscription associations' do
        subject
        expect(Subscription.last.customer).to eq(customer)
      end

      context 'when customer has existing subscription' do
        let!(:subscription) { create(:subscription, customer: customer, product: Product.last) }

        it 'creates new subscription record with proper data' do
          expect { subject }.to change { Subscription.count }.by(1)
          expect(Subscription.last.fakepay_token).to eq('111111111111111111')
        end

        it 'stes up correct subscription associations' do
          subject
          expect(Subscription.last.customer).to eq(customer)
        end
      end
    end
  end
end
