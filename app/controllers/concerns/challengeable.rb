# frozen_string_literal: true

module Challengeable
  extend ActiveSupport::Concern

  class ::ChallengeError < StandardError; end

  def valid_challenge?
    if valid_challenge_answer?
      clear_challenge_session
      return true
    end

    render_challenge_error

    # Halt action chain when used as before_action
    false
  end

  # Exception-based variant - raises instead of rendering
  def require_challenge!
    return clear_challenge_session if valid_challenge_answer?

    raise ChallengeError, "Invalid or expired challenge"
  end

  private

  def clear_challenge_session
    session.delete(:challenge_answer)
    session.delete(:challenge_expires_at)
  end

  def generate_challenge
    a = rand(1..20)
    b = rand(1..20)
    operation = [ "+", "-" ].sample

    answer = operation == "+" ? a + b : a - b

    {
      question: "#{a} #{operation} #{b} = ?",
      answer: answer
    }
  end

  def render_challenge_error
    render(json: {
             success: false,
             error: t("challenges.errors.invalid")
           },
           status: :forbidden)
  end

  def setup_challenge_session
    @challenge = generate_challenge
    session[:challenge_answer] = @challenge[:answer]
    session[:challenge_expires_at] = 5.minutes.from_now
  end

  def valid_challenge_answer?
    return false unless session[:challenge_answer] && session[:challenge_expires_at]
    return false if Time.current > session[:challenge_expires_at]

    submitted_answer = request.headers["X-Challenge-Answer"]&.to_i
    submitted_answer == session[:challenge_answer]
  end
end
