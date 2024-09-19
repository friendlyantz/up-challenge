# frozen_string_literal: true

require "active_model"
require "active_model/validations"

class InputValidator
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :principal, :interest_rate, :term, :compounding, :top_up

  validates :principal, :term, presence: true, numericality: { greater_than: 0 }
  validates :interest_rate, presence: true, numericality: { greater_than: 0, less_than: 1 }
  validates :top_up, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
  validate :compounding_inclusion

  def valid_args
    {
      principal: principal.to_f,
      term: term.to_f,
      rate: interest_rate.to_f,
      freq: translate_compounding_to_freq,
      top_up: top_up.to_f
    }
  end

  private

  def compounding_inclusion
    allowed_values = %w[weekly fortnightly monthly quarterly annually maturity]
    return if allowed_values.include?(compounding.to_s.downcase)

    errors.add(:compounding, "Interest period is not included")
  end

  def translate_compounding_to_freq
    case compounding.downcase
    in "weekly" then 52
    in "fortnightly" then 26
    in "monthly" then 12
    in "quarterly" then 4
    in "annually" then 1
    in "maturity" then 0
    end
  end
end
