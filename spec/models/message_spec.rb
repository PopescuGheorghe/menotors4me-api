# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message, type: :model do
  context 'fields' do
    it { is_expected.to respond_to(:context_id) }
    it { is_expected.to respond_to(:sender_id) }
    it { is_expected.to respond_to(:receiver_id) }
    it { is_expected.to respond_to(:message) }
    it { is_expected.to validate_presence_of(:message) }
    it { is_expected.to validate_length_of(:message).is_at_most(10_000) }
    it { is_expected.to belong_to(:context) }
  end
end
