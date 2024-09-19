# frozen_string_literal: true

require "money"

Money.default_infinite_precision = true
I18n.enforce_available_locales = false
Money.locale_backend = :currency

class TermDeposit
  attr_reader :monthly_interests, :principal, :term, :rate, :freq, :top_up, :periodic_interests

  def initialize(principal:, term:, rate:, freq:, top_up: 0.0)
    @principal = Money.from_amount(principal, "AUD")
    @term = term.to_f
    @rate = rate.to_f
    @freq = freq.to_i
    @top_up = Money.from_amount(top_up, "AUD")
    @monthly_interests = []
    @periodic_interests = []
  end

  def final_balance
    periodic_interests.last.balance
  end

  def final_interest_earned
    periodic_interests.last.interest_earned
  end

  CompoundedPeriods = Struct.new(:name, :rate, :top_up, :balance, :interest_earned)
  def calculate
    @periodic_interests = case freq
                          in 0
                            [

                              CompoundedPeriods.new(
                                balance: principal * (1 + (rate * term)),
                                interest_earned: principal * rate * term,
                                name: "At Maturity",
                                rate:
                              )
                            ]
                          in 1.. then calculate_compounding_periods
                          end

    @monthly_interests = case freq
                         in 0..11 then project_monthly
                         in 12.. then periodic_interests
                         end
  end

  private

  def calculate_compounding_periods
    period_name = case freq
                  in 1 then "Year"
                  in 4 then "Quarter"
                  in 12 then "Month"
                  in 52 then "Week"
                  in 26 then "Fortnight"
                  end
    period_multiplier = (1 + (rate / freq))**(1.0 * freq / freq)
    prev_balance = principal
    num_of_periods = term * freq

    Array.new(num_of_periods.to_i).map.with_index do |_e, i|
      amount_before_top_up = prev_balance * period_multiplier
      interest_so_far = amount_before_top_up - principal - (top_up * i)
      amount_after_top_up = amount_before_top_up + top_up
      r = CompoundedPeriods.new(
        name: "#{period_name} #{i + 1}",
        top_up:,
        rate:,
        balance: amount_after_top_up,
        interest_earned: interest_so_far
      )
      prev_balance = amount_after_top_up
      r
    end
  end

  MonthlyProjection = Struct.new(:name, :rate, :top_up, :balance, :interest_earned)
  def project_monthly
    period_rate, num_of_periods = period_rate_and_num_of_periods_per_month
    monthly_multiplier = ((1 + period_rate)**(1.0 / num_of_periods))
    prev_period_principal = principal

    periodic_interests.map.with_index(1) do |mth_int_object, period_index|
      result = (1..num_of_periods).map do |i|
        balance_so_far = prev_period_principal * (monthly_multiplier**i)
        interest_so_far = balance_so_far - principal
        balance_so_far + top_up if i == num_of_periods
        MonthlyProjection.new(
          name: "Month #{i + ((period_index - 1) * num_of_periods)}",
          rate:,
          top_up:,
          balance: balance_so_far,
          interest_earned: interest_so_far
        )
      end
      prev_period_principal = mth_int_object.balance
      result
    end.flatten!
  end

  def period_rate_and_num_of_periods_per_month
    if freq.zero?
      [rate * term, 12 * term]
    else
      [rate / freq, 12 / freq]
    end
  end
end
