# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FakepayGateway do
  subject { described_class.new(request_params: params).call }
end
