# frozen_string_literal: true

class FakepayGateway
  def perform_first_payment(payment_data:)
    response = fakepay_connection.post do |request|
      request.body = payment_data.to_json
    end

    parse_response(response: response)
  end

  def perform_regular_payment(subscription:)
    response = fakepay_connection.post do |request|
      request.body = { amount: subscription.product.price_in_cents, token: subscription.fakepay_token }.to_json
    end

    update_next_payment_date(subscription: subscription) if response.success?
  end

  private

  def fakepay_connection
    Faraday.new(
      url: Rails.application.credentials.fakepay[:url],
      headers: { 'Authorization' => "Token token=#{api_token}",
                 'Content-Type' => 'application/json' }
    )
  end

  def update_next_payment_date(subscription:)
    payment_date = Date.today + 1.month
    next_payment_date = payment_date > subscription.expiration_date ? nil : payment_date

    subscription.update!(next_payment_date: next_payment_date)
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
