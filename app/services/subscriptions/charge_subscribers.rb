# frozen_string_literal: true

# This service could be triggered by a cron worker every day to charge subscribers
module Subscriptions
  class ChargeSubscribers
    def call
      subscriptions_to_charge.each do |subscription|
        payment_service.perform_regular_payment(subscription: subscription)
      end
    end

    private

    def subscriptions_to_charge
      @subscriptions_to_charge ||= Subscription.where(next_payment_date: Date.today)
    end

    def payment_service
      @payment_service ||= FakepayPaymentGateway.new
    end
  end
end
