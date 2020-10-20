# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subscriptions::ErrorMapper do
  subject { described_class.new.map_erronous_response(error_code: error_code) }

  # This service is rather trivial, I do not see sense for further testing
  context 'when error code is 1_000_006' do
    let(:error_code) { 1_000_006 }

    it { is_expected.to eq('Error: Invalid purchase amount')}
  end
end
