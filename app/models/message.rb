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
class Message < ApplicationRecord
  # Attributes

  attr_accessor(:expiration_duration)

  # Constants

  EXPIRATION_OPTIONS = {
    five_minutes: 5.minutes,
    one_hour: 1.hour,
    six_hours: 6.hours,
    one_day: 1.day
  }.freeze

  # Callbacks

  before_validation(:generate_stub, on: :create)
  before_validation(:set_expires_at, on: :create)

  # Scopes

  scope(:active, -> { where("expires_at IS NULL OR expires_at > ?", Time.current) })
  scope(:expired, -> { where("expires_at IS NOT NULL AND expires_at <= ?", Time.current) })
  scope(:read, -> { where.not(read_at: nil) })
  scope(:unread, -> { where(read_at: nil) })

  # Validations

  validates(:body, presence: true, length: { maximum: 5_000 })

  with_options(on: :create) do
    validates(:expires_at, presence: true)
    validates(:expiration_duration, inclusion: { in: EXPIRATION_OPTIONS.keys })
    validates(
      :stub,
      presence: true,
      uniqueness: true
    )
  end

  with_options(on: :update) do
    validate(:prevent_stub_change, if: -> { stub_changed? })
  end

  # Class methods

  def self.remove_expired!
    where("expires_at IS NOT NULL AND expires_at <= ?", Time.current).find_each(&:destroy)
  end

  # Instance methods

  def expired?
    expires_at.present? && expires_at <= Time.current
  end

  def read!
    return [ nil, read_at ] if read_at.present?

    pre_body = body
    pre_read_at = read_at

    self.body = I18n.t("models.message.read_notification")
    self.read_at = Time.current
    save!

    [ pre_body, pre_read_at ]
  end

  def read?
    read_at.present?
  end

  def unread?
    read_at.nil?
  end

  private

  def generate_stub
    retry_count = 0

    loop do
      self.stub = SecureRandom.base58(8)

      break unless Message.exists?(stub: stub)

      retry_count += 1

      raise I18n.t("models.message.errors.stub_generation_failed", attempts: retry_count) if retry_count > 5
    end
  end

  def set_expires_at
    duration_key = expiration_duration || :one_hour
    duration = EXPIRATION_OPTIONS[duration_key]

    self.expires_at = Time.current + duration if duration
  end

  def prevent_stub_change
    errors.add(:stub, I18n.t("models.message.errors.stub_cannot_be_changed"))
  end
end
