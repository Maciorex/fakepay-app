# frozen_string_literal: true

class SubscriptionHandler
  def initialize(request_params:)
    @request_params = request_params
    @product = Product.find(request_params[:product_id])
  end

  def call
    customer = create_or_fetch_customer
    perform_payment
    create_subscription(customer: customer)
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
    FakepayPaymentGateway.new(product: product).perform_first_payment(payment_data: payment_data)
  end

  def create_subscription(customer:)
    Subscription.create(customer: customer)
  end

  def payment_data
    @payment_data ||= {
      card_number: request_params[:card_number],
      cvv: request_params[:cvv],
      expiration_month: request_params[:card_expiration_date],
      expiration_year: request_params[:billing_zip_code]
    }
  end
end
