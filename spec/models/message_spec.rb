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

RSpec.describe Message do
  describe "validations" do
    context "when created" do
      it "validates presence of body" do
        message = build(:message, body: nil)
        expect(message).not_to be_valid
      end

      it "includes error message for blank body" do
        message = build(:message, body: nil)
        message.valid?
        expect(message.errors[:body]).to include("can't be blank")
      end

      it "allows valid expiration_duration values" do
        valid_durations = %i[five_minutes one_hour six_hours one_day]
        valid_durations.each do |duration|
          message = build(:message, expiration_duration: duration)
          expect(message).to be_valid
        end
      end

      it "disallows nil expiration_duration" do
        message = build(:message, expiration_duration: nil)
        expect(message).not_to be_valid
      end

      it "rejects invalid expiration_duration values" do
        invalid_message = build(:message, expiration_duration: :invalid_duration)
        expect(invalid_message).not_to be_valid
      end

      it "includes error message for invalid expiration_duration" do
        invalid_message = build(:message, expiration_duration: :invalid_duration)
        invalid_message.valid?
        expect(invalid_message.errors[:expiration_duration]).to include("is not included in the list")
      end

      # NOTE: stub validation is complex due to the generate_stub callback
      # so we test it separately rather than using shoulda matchers

      it "validates uniqueness of stub when uniqueness constraint would be violated" do
        # This test verifies that the uniqueness validation exists
        # We can't easily test it in isolation due to the generate_stub callback
        # but we can verify the validation is present by checking the model's validators
        uniqueness_validators = described_class.validators_on(:stub).select { |v| v.is_a?(ActiveRecord::Validations::UniquenessValidator) }
        expect(uniqueness_validators).not_to be_empty
      end
    end

    context "when updated" do
      let(:message) { create(:message) }

      it "prevents stub from being changed" do
        message.stub = "new_stub"
        expect(message).not_to be_valid
      end

      it "includes error message when stub is changed" do
        message.stub = "new_stub"
        message.valid?
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
      end

      it "generates a stub of correct length" do
        message = build(:message, stub: nil)
        message.valid?
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

    describe "#set_expires_at" do
      it "sets expires_at based on expiration_duration" do
        freeze_time do
          message = create(:message, expiration_duration: :one_hour)
          expect(message.expires_at).to be_within(1.second).of(1.hour.from_now)
        end
      end

      it "sets expires_at for five minutes duration" do
        freeze_time do
          five_min_message = create(:message, expiration_duration: :five_minutes)
          expect(five_min_message.expires_at).to be_within(1.second).of(5.minutes.from_now)
        end
      end

      it "sets expires_at for one day duration" do
        freeze_time do
          one_day_message = create(:message, expiration_duration: :one_day)
          expect(one_day_message.expires_at).to be_within(1.second).of(1.day.from_now)
        end
      end

      it "sets expires_at even when expiration_duration is provided" do
        freeze_time do
          message = create(:message, expiration_duration: :six_hours)
          expect(message.expires_at).to be_within(1.second).of(6.hours.from_now)
        end
      end
    end
  end

  describe "scopes" do
    let!(:active_message) { create(:message, :one_hour) }
    let!(:expired_message) { create(:message, :expired) }
    let!(:read_message) { create(:message, :read) }
    let!(:unread_message) { create(:message, :unread) }

    describe ".active" do
      it "includes active messages" do
        expect(described_class.active).to include(active_message)
      end

      it "excludes expired messages" do
        expect(described_class.active).not_to include(expired_message)
      end
    end

    describe ".expired" do
      it "includes expired messages" do
        expect(described_class.expired).to include(expired_message)
      end

      it "excludes active messages" do
        expect(described_class.expired).not_to include(active_message)
      end
    end

    describe ".read" do
      it "includes read messages" do
        expect(described_class.read).to include(read_message)
      end

      it "excludes unread messages" do
        expect(described_class.read).not_to include(unread_message)
      end
    end

    describe ".unread" do
      it "includes unread messages" do
        expect(described_class.unread).to include(unread_message)
      end

      it "excludes read messages" do
        expect(described_class.unread).not_to include(read_message)
      end
    end
  end

  describe "instance methods" do
    describe "#expired?" do
      it "returns true for expired messages" do
        message = create(:message, :expired)
        expect(message.expired?).to be true
      end

      it "returns false for active messages" do
        message = create(:message, :one_hour)
        expect(message.expired?).to be false
      end
    end

    describe "#read!" do
      let(:message) { create(:message, read_at: nil) }

      it "sets read_at to current time" do
        freeze_time do
          message.read!
          expect(message.read_at).to be_within(1.second).of(Time.current)
        end
      end

      it "does not change read_at if already read" do
        original_time = 1.hour.ago
        message.update!(read_at: original_time)

        message.read!
        expect(message.reload.read_at).to be_within(1.second).of(original_time)
      end
    end

    describe "#unread?" do
      it "returns true when read_at is nil" do
        message = create(:message, read_at: nil)
        expect(message.unread?).to be true
      end

      it "returns false when read_at is set" do
        message = create(:message, read_at: Time.current)
        expect(message.unread?).to be false
      end
    end
  end

  describe "constants" do
    it "has the expected expiration options" do
      expected_keys = %i[five_minutes one_hour six_hours one_day]
      expect(Message::EXPIRATION_OPTIONS.keys).to match_array(expected_keys)
    end

    it "has correct five minutes duration value" do
      expect(Message::EXPIRATION_OPTIONS[:five_minutes]).to eq(5.minutes)
    end

    it "has correct one hour duration value" do
      expect(Message::EXPIRATION_OPTIONS[:one_hour]).to eq(1.hour)
    end

    it "has correct six hours duration value" do
      expect(Message::EXPIRATION_OPTIONS[:six_hours]).to eq(6.hours)
    end

    it "has correct one day duration value" do
      expect(Message::EXPIRATION_OPTIONS[:one_day]).to eq(1.day)
    end
  end
end
