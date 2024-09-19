# frozen_string_literal: true

require "money"

Money.default_infinite_precision = true
I18n.enforce_available_locales = false
Money.locale_backend = :currency

class TermDeposit
  attr_reader :principal, :term, :rate, :freq, :top_up

  def initialize(principal:, term:, rate:, freq:, top_up: 0.0)
    @principal = Money.from_amount(principal, "AUD")
    @term = term
    @rate = rate
    @freq = freq
    @top_up = Money.from_amount(top_up, "AUD")
  end

  def calculate
    true
  end

  def final_balance
    principal * ((1 + (rate / freq))**(term * freq))
  end

  def final_interest_earned
    final_balance - principal
  end
end
