# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subscriptions::CreationHandler do
  subject { described_class.new(request_params: params).call }

  let(:params) do
    {
      customer_name: 'Marco Odermatt',
      address: 'asd',
      zip_code: '51-986',
      card_number: '4242424242424242',
      cvv: '123',
      card_expiration_date: (Date.today + 3.years).strftime('%m/%Y'),
      billing_zip_code: '10045',
      product_uuid: product_uuid,
      months_valid: 5
    }
  end
  let(:payment_data) do
    {
      amount: '1999',
      card_number: '4242424242424242',
      cvv: '123',
      expiration_month: '10',
      expiration_year: '2023',
      zip_code: '10045'
    }
  end
  let(:fakepay_response) do
    {
      status: 200,
      body: { token: 'test_token', success: true, error_code: nil }
    }
  end
  let!(:product) do
    create(:product, name: 'Bronze Box', price_in_cents: '1999', uuid: '11111111-1111-1111-1111-111111111111')
  end
  let(:fakepay_gateway) { instance_double(FakepayGateway) }
  let(:product_uuid) { '11111111-1111-1111-1111-111111111111' }


  before do
    allow(FakepayGateway).to receive(:new).and_return(fakepay_gateway)
    allow(fakepay_gateway).to receive(:perform_first_payment)
      .with(payment_data: payment_data)
      .and_return(fakepay_response)
  end

  context 'when receiving success response from fakepay' do
    context 'when customer does not exist' do
      it 'calls fakepay_gateway service' do
        expect(fakepay_gateway).to receive(:perform_first_payment)

        subject
      end

      it 'creates new customer record with proper data' do
        expect { subject }.to change { Customer.count }.by(1)
        expect(Customer.last.name).to eq('Marco Odermatt')
      end

      it 'sets up correct subscription associations' do
        subject
        expect(Subscription.last.customer).to eq(Customer.find_by(name: 'Marco Odermatt'))
      end

      it 'creates new subscription record with proper data' do
        expect { subject }.to change { Subscription.count }.by(1)
        expect(Subscription.last.fakepay_token).to eq('test_token')
      end
    end

    context 'when customer exists' do
      let!(:customer) { create(:customer, name: 'Marco Odermatt', address: 'asd', zip_code: '51-986') }

      it 'calls fakepay_gateway service' do
        expect(fakepay_gateway).to receive(:perform_first_payment)

        subject
      end

      it 'does NOT create new customer record' do
        expect { subject }.not_to change { Customer.count }
      end

      it 'creates new subscription record with proper data' do
        expect { subject }.to change { Subscription.count }.by(1)
        expect(Subscription.last.fakepay_token).to eq('test_token')
      end

      it 'sets up correct subscription associations' do
        subject
        expect(Subscription.last.customer).to eq(customer)
      end

      context 'when customer has existing subscription' do
        let!(:subscription) { create(:subscription, customer: customer, product: Product.last) }

        it 'calls fakepay_gateway service' do
          expect(fakepay_gateway).to receive(:perform_first_payment)

          subject
        end

        it 'creates new subscription record with proper data' do
          expect { subject }.to change { Subscription.count }.by(1)
          expect(Subscription.last.fakepay_token).to eq('test_token')
        end

        it 'sets up correct subscription associations' do
          subject
          expect(Subscription.last.customer).to eq(customer)
        end
      end
    end
  end

  context 'when product with requested uuid does not exist' do
    let(:product_uuid) { 'wroooooong_uuid' }

    it 'raises an error' do
      expect { subject }.to raise_error('Product with uuid: wroooooong_uuid does not exists')
    end
  end
end
