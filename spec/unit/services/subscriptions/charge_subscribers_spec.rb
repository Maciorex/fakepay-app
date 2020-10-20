# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subscriptions::ChargeSubscribers do
  subject { described_class.new.call }

  let(:fakepay_gateway) { instance_double(FakepayGateway) }
  let(:fakepay_response) do
    {
      status: 200,
      body: { token: 'test_token', success: true, error_code: nil }
    }
  end

  before do
    allow(FakepayGateway).to receive(:new).and_return(fakepay_gateway)
    allow(fakepay_gateway).to receive(:perform_regular_payment).and_return(fakepay_response)

    create(:subscription)
    create(:subscription, next_payment_date: nil)
  end

  let!(:subscription_1) { create(:subscription, next_payment_date: Date.today) }
  let!(:subscription_2) { create(:subscription, next_payment_date: Date.today) }

  it 'calls fakepay_gateway service with proper subscriptions' do
    expect(fakepay_gateway).to receive(:perform_regular_payment).with(subscription: subscription_1)
    expect(fakepay_gateway).to receive(:perform_regular_payment).with(subscription: subscription_2)

    subject
  end

  it 'updates subscriptions next_payment_date column' do
    expect { subject }.to change { subscription_1.reload.next_payment_date }.from(Date.today).to(Date.today + 1.months)
  end
end
