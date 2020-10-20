# frozen_string_literal: true

# This service could be triggered by a cron worker every day to charge subscribers
module Subscriptions
  class ChargeSubscribers
    def call
      subscriptions_to_charge.each do |subscription|
        response = payment_service.perform_regular_payment(subscription: subscription)
        update_next_payment_date(subscription: subscription) if response[:status] == 200
      end
    end

    private

    def subscriptions_to_charge
      @subscriptions_to_charge ||= Subscription.where(next_payment_date: Date.today)
    end

    def payment_service
      @payment_service ||= FakepayGateway.new
    end

    def update_next_payment_date(subscription:)
      payment_date = Date.today + 1.month
      next_payment_date = payment_date > subscription.expiration_date ? nil : payment_date

      subscription.update!(next_payment_date: next_payment_date)
    end
  end
end
