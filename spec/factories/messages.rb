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
    expiration_duration { :one_hour }

    # Don't set stub directly - let the model generate it
    # Don't set read_at by default - messages should be unread when created

    trait :read do
      read_at { 1.minute.ago }
      body { I18n.t("models.message.read_notification") }
    end

    trait :unread do
      read_at { nil }
    end

    trait :with_short_body do
      body { Faker::Lorem.sentence }
    end

    trait :with_long_body do
      body { Faker::Lorem.paragraph(sentence_count: 10) }
    end

    # Expiration duration traits
    trait :five_minutes do
      expiration_duration { :five_minutes }
    end

    trait :one_hour do
      expiration_duration { :one_hour }
    end

    trait :six_hours do
      expiration_duration { :six_hours }
    end

    trait :one_day do
      expiration_duration { :one_day }
    end

    trait :no_expiration do
      expiration_duration { nil }
    end

    # Create an expired message by setting creation time in the past
    trait :expired do
      expiration_duration { :five_minutes }
      created_at { 10.minutes.ago }

      after(:create) do |message|
        # Manually set expires_at to be in the past
        message.expires_at = 5.minutes.ago
        message.save!(validate: false)
      end
    end
  end
end
