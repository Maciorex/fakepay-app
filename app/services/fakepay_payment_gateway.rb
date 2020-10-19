# frozen_string_literal: true

class FakepayPaymentGateway
  def perform_first_payment(payment_data:)
    response = fakepay_connection.post do |request|
      request.body = payment_data.to_json
    end

    parse_response(response: response)
  end

  def perform_regular_payment(subscription:)
    fakepay_connection.post do |request|
      request.body = { amount: subscription.product.price, token: subscription.fakepay_token }.to_json
    end
  end

  private

  def fakepay_connection
    Faraday.new(
      url: Rails.application.credentials.fakepay[:url],
      headers: { 'Authorization' => "Token token=#{api_token}",
                 'Content-Type' => 'application/json' }
    )
  end

  def api_token
    Rails.application.credentials.fakepay[:api_key]
  end

  def parse_response(response:)
    {
      status: response.status,
      body: JSON.parse(response.body, symbolize_names: true)
    }
  end
end
