# frozen_string_literal: true

module ApplicationHelper
  include BetterHtml::Helpers

  def flash_class(type)
    case type.to_s
    when "notice", "success"
      "alert-success"
    when "alert", "error"
      "alert-error"
    when "warning"
      "alert-warning"
    else
      "alert-info"
    end
  end

  # rubocop:disable Layout/LineLength
  def flash_icon(type)
    case type.to_s
    when "notice", "success"
      '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>'.html_safe
    when "alert", "error"
      '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z"></path>'.html_safe
    when "warning"
      '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L3.732 16c-.77.833.192 2.5 1.732 2.5z"></path>'.html_safe
    else
      '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>'.html_safe
    end
  end
  # rubocop:enable Layout/LineLength

  def time_ago_in_words_with_fallback(time)
    return "Never" unless time

    if time > 1.day.ago
      "#{time_ago_in_words(time)} ago"
    else
      time.strftime("%B %d, %Y at %I:%M %p")
    end
  rescue StandardError
    # Fallback if time_ago_in_words fails
    time.strftime("%B %d, %Y at %I:%M %p")
  end

  def field_class_with_errors(model, field, base_classes)
    classes = base_classes
    classes += " input-error" if model&.errors&.include?(field)
    classes
  end
end
