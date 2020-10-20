# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subscriptions::ChargeSubscribers do
  subject { described_class.new.call }

  let(:fakepay_gateway) { instance_double(FakepayGateway) }

  before do
    allow(FakepayGateway).to receive(:new).and_return(fakepay_gateway)
    allow(fakepay_gateway).to receive(:perform_regular_payment)

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
end
