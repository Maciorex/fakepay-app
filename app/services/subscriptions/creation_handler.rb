# frozen_string_literal: true

module Subscriptions
  class CreationHandler
    def initialize(request_params:)
      @request_params = request_params
      @product = Product.find_by(uuid: request_params[:product_uuid])
    end

    def call
      customer = create_or_fetch_customer
      response = perform_payment
      return response unless response[:status] == 200

      create_subscription(customer: customer, token: response[:body][:token])
      response
    end

    private

    attr_reader :request_params, :product

    def create_or_fetch_customer
      customer_name = request_params[:customer_name]
      address = request_params[:address]
      zip_code = request_params[:zip_code]

      Customer.find_or_create_by(name: customer_name, address: address, zip_code: zip_code)
    end

    def perform_payment
      FakepayPaymentGateway.new.perform_first_payment(payment_data: payment_data)
    end

    def create_subscription(customer:, token:)
      Subscription.create(
        customer: customer,
        product: product,
        fakepay_token: token,
        subscribe_date: Date.today,
        expiration_date: Date.today + 1.month
      )
    end

    def payment_data
      @payment_data ||= {
        amount: product.price,
        card_number: request_params[:card_number],
        cvv: request_params[:cvv],
        expiration_month: Date.parse(request_params[:card_expiration_date]).strftime('%m'),
        expiration_year: Date.parse(request_params[:card_expiration_date]).strftime('%Y'),
        zip_code: request_params[:billing_zip_code]
      }
    end
  end
end
