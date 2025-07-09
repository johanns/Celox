# frozen_string_literal: true

module MessagesHelper
  def expiration_duration_options
    [
      [ t("messages.expiration_options.five_minutes"), "five_minutes" ],
      [ t("messages.expiration_options.one_hour"), "one_hour" ],
      [ t("messages.expiration_options.six_hours"), "six_hours" ],
      [ t("messages.expiration_options.one_day"), "one_day" ]
    ]
  end

  def message_encryption_data_attributes
    {
      "data-controller" => "message-encryption",
      "data-message-encryption-connection-error-message-value" => t("messages.errors.connection_failed"),
      "data-message-encryption-encryption-failed-message-value" => t("messages.errors.encryption_failed"),
      "data-message-encryption-server-error-message-value" => t("messages.errors.server_error"),
      "data-message-encryption-generic-error-message-value" => t("messages.errors.generic"),
      "data-message-encryption-unexpected-error-message-value" => t("messages.errors.unexpected")
    }
  end

  def message_decryption_data_attributes(message)
    {
      "data-controller" => "message-decryption",
      "data-message-decryption-fetch-url-value" => fetch_message_path(message.stub),
      "data-message-decryption-decryption-failed-message-value" => t("messages.decryption.failed"),
      "data-message-decryption-challenge-missing-answer-message-value" => t("messages.challenge.missing_answer"),
      "data-message-decryption-challenge-missing-key-message-value" => t("messages.challenge.missing_key"),
      "data-message-decryption-challenge-verification-failed-message-value" => t("messages.challenge.verification_failed"),
      "data-message-decryption-challenge-network-error-message-value" => t("messages.challenge.network_error")
    }
  end
end
