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
end
