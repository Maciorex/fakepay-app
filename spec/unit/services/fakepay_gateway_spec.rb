# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FakepayGateway do
  subject { described_class.new.perform_first_payment(payment_data: payment_data) }

  let(:payment_data) do
    {
      amount: 1999,
      card_number: '4242424242424242',
      cvv: '123',
      expiration_month: '10',
      expiration_year: '2023',
      zip_code: '10045'
    }
  end

  before do
    stub_request(:post, 'https://www.fakepay.io/purchase')
      .with(
        body: {
          amount: 1999,
          card_number: '4242424242424242',
          cvv: '123',
          expiration_month: '10',
          expiration_year: '2023',
          zip_code: '10045'
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      ).to_return(
        status: 200,
        body: '{"token":"test_token","success":true,"error_code":null}',
        headers: {}
      )
  end
  let(:fakepay_service_response) do
    {
      status: 200,
      body: { token: 'test_token', success: true, error_code: nil }
    }
  end

  it 'returns parsed response' do
    expect(subject).to eq(fakepay_service_response)
  end
end
