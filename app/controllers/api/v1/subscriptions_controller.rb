# frozen_string_literal: true

module Api
  module V1
    class SubscriptionsController < ApplicationController
      # POST /api/v1/subscriptions
      def create
        response = Subscriptions::CreationHandler.new(request_params: subscription_request_params).call

        render json: parse_response(response: response).to_json, status: response[:status]
      end

      private

      def subscription_request_params
        params.require(:subscription)
              .permit(:customer_name, :address, :zip_code, :card_number, :months_valid,
                      :cvv, :card_expiration_date, :billing_zip_code, :product_uuid)
      end

      def parse_response(response:)
        if response[:status] == 200
          'Subscription created succesfully'
        else
          Subscriptions::ErrorMapper.new.map_erronous_response(error_code: response[:body][:error_code])
        end
      end
    end
  end
end
