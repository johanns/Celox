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
FactoryBot.define do
  factory :message do
    body { Faker::Lorem.paragraph(sentence_count: 2) }
    expires_at { 1.hour.from_now }

    # Don't set stub directly - let the model generate it
    # Don't set read_at by default - messages should be unread when created

    trait :read do
      read_at { 1.minute.ago }
    end

    trait :expired do
      expires_at { 1.hour.ago }
    end

    trait :expiring_soon do
      expires_at { 5.minutes.from_now }
    end

    trait :with_short_body do
      body { Faker::Lorem.sentence }
    end

    trait :with_long_body do
      body { Faker::Lorem.paragraph(sentence_count: 10) }
    end

    # Factory for testing scopes that need messages without expiration
    # Uses after(:create) to bypass the validation
    trait :without_expiration do
      after(:create) do |message|
        message.update_column(:expires_at, nil)
      end
    end
  end
end
