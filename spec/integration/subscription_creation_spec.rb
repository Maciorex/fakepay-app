# frozen_string_literal: true

require 'rails_helper'

RSpec.describe do
  let!(:products) do
    create(:product, name: 'Bronze Box', price_in_cents: '1999', uuid: '11111111-1111-1111-1111-111111111111')
    create(:product, name: 'Silver Box', price_in_cents: '4900', uuid: '22222222-1111-1111-1111-111111111111')
    create(:product, name: 'Gold Box', price_in_cents: '9900', uuid: '33333333-1111-1111-1111-111111111111')
  end

  subject { post '/api/v1/subscriptions', { params: request_params } }

  let(:request_params) do
    {

      subscription:
      {
        customer_name: 'Lucas Braathen',
        address: 'asd',
        zip_code: '51-986',
        card_number: '4242424242424242',
        cvv: '123',
        card_expiration_date: (Date.today + 3.years).strftime('%m/%Y'),
        billing_zip_code: '10045',
        product_uuid: product_uuid,
        months_valid: 5
      }
    }
  end
  let(:product_uuid) { '11111111-1111-1111-1111-111111111111' }

  context 'when fakepay response status is 2xx' do
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
      it 'returns 200 with proper message' do
        subject
        expect(response.status).to eq(200)
        expect(response.body).to eq('Subscription created succesfully'.to_json)
      end
    end

    context 'when customer exists' do
      let!(:customer) { create(:customer, name: 'Lucas Braathen', address: 'asd', zip_code: '51-986') }

      it 'returns 200' do
        subject
        expect(response.status).to eq(200)
        expect(response.body).to eq('Subscription created succesfully'.to_json)
      end

      context 'when customer has existing subscription' do
        let!(:subscription) { create(:subscription, customer: customer, product: Product.last) }

        it 'returns 200' do
          subject
          expect(response.status).to eq(200)
          expect(response.body).to eq('Subscription created succesfully'.to_json)
        end
      end
    end
  end

  context 'when fakepay response is 4xx' do
    let(:request_params) do
      {

        subscription:
        {
          customer_name: 'Lucas Braathen',
          address: 'asd',
          zip_code: '51-986',
          card_number: '4242424242424242',
          cvv: '977',
          card_expiration_date: Date.today + 3.years,
          billing_zip_code: '10045',
          product_uuid: '11111111-1111-1111-1111-111111111111',
          months_valid: 5
        }
      }
    end

    before do
      stub_request(:post, 'https://www.fakepay.io/purchase')
        .with(
          body: {
            'amount' => '1999',
            'card_number' => '4242424242424242',
            'cvv' => '977',
            'expiration_month' => '10',
            'expiration_year' => '2023',
            'zip_code' => '10045'
          }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        ).to_return(
          status: 422,
          body: '{"token": null, "success": false, "error_code": 1000003}',
          headers: {}
        )
    end

    it 'returns 422 and error message' do
      subject
      expect(response.status).to eq(422)
      expect(JSON.parse(response.body)).to eq('Error: CVV failure')
    end
  end

  context 'when product with requested uuid does not exist' do
    let(:product_uuid) { 'wroooooong_uuid' }

    it 'returns 400' do
      subject
      expect(response.status).to eq(400)
      expect(JSON.parse(response.body)).to eq('Product with uuid: wroooooong_uuid does not exists')
    end
  end
end
