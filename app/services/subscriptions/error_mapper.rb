# frozen_string_literal: true

module Subscriptions
  class ErrorMapper
    FAKEPAY_ERROR_MAP = {
      1_000_001 => 'Invalid credit card number',
      1_000_002 => 'Insufficient funds',
      1_000_003 => 'CVV failure',
      1_000_004 => 'Expired card',
      1_000_005 => 'Invalid zip code',
      1_000_006	=> 'Invalid purchase amount',
      1_000_007 => 'Invalid token',
      1_000_008 => 'Invalid params: cannot specify both  token  and other credit card params'
    }.freeze

    def map_erronous_response(error_code:)
      "Error: #{FAKEPAY_ERROR_MAP.fetch(error_code)}"
    end
  end
end
