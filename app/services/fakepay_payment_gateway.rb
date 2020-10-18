# frozen_string_literal: true

class FakepayPaymentGateway
  def initialize(product: product)
    @product = product
  end

  def perform_first_payment
    http.post
  end

  private

  def http
    Faraday.new(
      url: Rails.application.credentials.fakepay[:url],
      headers: { 'Authorization' => "Token token=#{api_token}",
                 'Accept' => 'application/json' }
    )
  end

  def api_token
    Rails.application.credentials.fakepay[:api_key]
  end
end
