# frozen_string_literal: true

require "rails_helper"

RSpec.describe CleanupExpiredMessagesJob do
  describe "#perform" do
    let!(:active_message) { create(:message, :one_hour) }
    let!(:expired_message) { create(:message, :expired) }

    before do
      allow(Rails.logger).to receive(:info)
    end

    it "deletes expired messages" do
      described_class.perform_now

      expect(Message.exists?(expired_message.id)).to be false
    end

    it "keeps active messages" do
      described_class.perform_now

      expect(Message.exists?(active_message.id)).to be true
    end

    it "logs the cleanup activity" do
      described_class.perform_now

      expect(Rails.logger).to have_received(:info).with("Cleanup completed. Deleted 1 expired messages.")
    end
  end
end
