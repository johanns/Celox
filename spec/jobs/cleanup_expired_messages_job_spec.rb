# frozen_string_literal: true

require "rails_helper"

RSpec.describe CleanupExpiredMessagesJob do
  describe "#perform" do
    let!(:active_message) { create(:message, :one_hour) }
    let!(:expired_message) { create(:message, :expired) }

    it "deletes only expired messages" do
      expect { described_class.perform_now }
        .to change(Message, :count).by(-1)

      expect(Message.exists?(active_message.id)).to be true
      expect(Message.exists?(expired_message.id)).to be false
    end

    it "returns the count of deleted messages" do
      result = described_class.perform_now
      expect(result).to eq(1)
    end

    it "logs the cleanup activity" do
      allow(Rails.logger).to receive(:info)

      described_class.perform_now

      expect(Rails.logger).to have_received(:info).with("Starting cleanup of expired messages...")
      expect(Rails.logger).to have_received(:info).with("Cleanup completed. Deleted 1 expired messages.")
    end
  end
end
