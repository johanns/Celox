# frozen_string_literal: true

module Challengeable
  extend ActiveSupport::Concern

  private

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

  def setup_challenge_session
    @challenge = generate_challenge
    session[:challenge_answer] = @challenge[:answer]
    session[:challenge_expires_at] = 5.minutes.from_now
  end

  def valid_challenge?
    return false unless session[:challenge_answer] && session[:challenge_expires_at]
    return false if Time.current > session[:challenge_expires_at]

    submitted_answer = request.headers["X-Challenge-Answer"]&.to_i
    submitted_answer == session[:challenge_answer]
  end

  def clear_challenge_session
    session.delete(:challenge_answer)
    session.delete(:challenge_expires_at)
  end

  def render_challenge_error
    render(json: {
             success: false,
             error: t("challenges.errors.invalid")
           },
           status: :forbidden)
  end
end
