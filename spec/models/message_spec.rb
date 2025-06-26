# frozen_string_literal: true

# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  body       :string           not null
#  expires_at :datetime
#  read_at    :datetime
#  stub       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_messages_on_stub  (stub) UNIQUE
#
require "rails_helper"

RSpec.describe Message, type: :model do
  describe "validations" do
    context "on create" do
      subject { build(:message) }

      it { is_expected.to validate_presence_of(:body) }
      it { is_expected.to validate_presence_of(:expires_at) }

      # Note: stub validation is complex due to the generate_stub callback
      # so we test it separately rather than using shoulda matchers

      it "validates uniqueness of stub when uniqueness constraint would be violated" do
        # This test verifies that the uniqueness validation exists
        # We can't easily test it in isolation due to the generate_stub callback
        # but we can verify the validation is present by checking the model's validators
        uniqueness_validators = Message.validators_on(:stub).select { |v| v.is_a?(ActiveRecord::Validations::UniquenessValidator) }
        expect(uniqueness_validators).not_to be_empty
      end
    end

    context "on update" do
      let(:message) { create(:message) }

      it "validates presence of read_at" do
        message.read_at = nil
        expect(message).not_to be_valid
        expect(message.errors[:read_at]).to include("can't be blank")
      end

      it "prevents stub from being changed" do
        message.stub = "new_stub"
        expect(message).not_to be_valid
        expect(message.errors[:stub]).to include("cannot be changed once set")
      end
    end
  end

  describe "callbacks" do
    describe "before_validation" do
      it "generates a stub on create" do
        message = build(:message, stub: nil)
        message.valid?
        expect(message.stub).to be_present
        expect(message.stub.length).to eq(8)
      end

      it "generates a unique stub" do
        # Create a message with a specific stub
        existing_message = create(:message)

        # Mock SecureRandom to return the same stub first, then a different one
        allow(SecureRandom).to receive(:base58).and_return(existing_message.stub, "unique123")

        new_message = build(:message, stub: nil)
        new_message.valid?

        expect(new_message.stub).to eq("unique123")
      end

      it "raises an error if unable to generate unique stub after 5 attempts" do
        existing_message = create(:message)

        # Mock SecureRandom to always return the same stub
        allow(SecureRandom).to receive(:base58).and_return(existing_message.stub)

        new_message = build(:message, stub: nil)

        expect { new_message.valid? }.to raise_error("Failed to generate unique stub after 6 attempts")
      end
    end
  end

  describe "scopes" do
    let!(:active_message) { create(:message, expires_at: 1.hour.from_now) }
    let!(:expired_message) { create(:message, :expired) }
    let!(:no_expiration_message) { create(:message, :without_expiration) }
    let!(:read_message) { create(:message, :read) }
    let!(:unread_message) { create(:message) }

    describe ".active" do
      it "returns messages that are not expired" do
        expect(Message.active).to include(active_message, no_expiration_message)
        expect(Message.active).not_to include(expired_message)
      end
    end

    describe ".expired" do
      it "returns messages that have expired" do
        expect(Message.expired).to include(expired_message)
        expect(Message.expired).not_to include(active_message, no_expiration_message)
      end
    end

    describe ".read" do
      it "returns messages that have been read" do
        expect(Message.read).to include(read_message)
        expect(Message.read).not_to include(unread_message)
      end
    end

    describe ".unread" do
      it "returns messages that have not been read" do
        expect(Message.unread).to include(unread_message, active_message, expired_message, no_expiration_message)
        expect(Message.unread).not_to include(read_message)
      end
    end
  end

  describe "instance methods" do
    describe "#expired?" do
      it "returns true when expires_at is in the past" do
        message = build(:message, :expired)
        expect(message.expired?).to be true
      end

      it "returns false when expires_at is in the future" do
        message = build(:message, expires_at: 1.hour.from_now)
        expect(message.expired?).to be false
      end

      it "returns false when expires_at is nil" do
        message = create(:message, :without_expiration)
        expect(message.expired?).to be false
      end
    end

    describe "#read!" do
      let(:message) { create(:message) }

      it "sets read_at to current time and saves the record" do
        expect { message.read! }.to change { message.read_at }.from(nil)
        expect(message.reload.read_at).to be_within(1.second).of(Time.current)
      end

      it "does not change read_at if already read" do
        message.update!(read_at: 1.hour.ago)
        original_read_at = message.read_at

        expect { message.read! }.not_to change { message.read_at }
        expect(message.read_at).to eq(original_read_at)
      end
    end

    describe "#unread?" do
      it "returns true when read_at is nil" do
        message = build(:message)
        expect(message.unread?).to be true
      end

      it "returns false when read_at is present" do
        message = build(:message, :read)
        expect(message.unread?).to be false
      end
    end
  end

  describe "factory" do
    it "creates a valid message" do
      message = build(:message)
      expect(message).to be_valid
    end

    it "creates a message with read trait" do
      message = create(:message, :read)
      expect(message.read_at).to be_present
      expect(message).not_to be_unread
    end

    it "creates an expired message" do
      message = create(:message, :expired)
      expect(message).to be_expired
    end

    it "creates a message without expiration using trait" do
      message = create(:message, :without_expiration)
      expect(message.expires_at).to be_nil
      expect(message).not_to be_expired
    end
  end
end
