# frozen_string_literal: true

module Api
  module V1
    class SubscriptionsController < ApplicationController
      # POST /api/v1/subscriptions
      def create
        SubscriptionHandler.new(request_params: subscription_request_params).call
      end

      private

      def subscription_request_params
        params.require(:subscription)
              .permit(:customer_name, :address, :zip_code, :card_number,
                      :cvv, :card_expiration_date, :billing_zip_code, :product_id)
      end
    end
  end
end
