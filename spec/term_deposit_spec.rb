# frozen_string_literal: true

require "spec_helper"
require "term_deposit"

RSpec.describe TermDeposit, type: :model do
  it "instantiates with principal and top up amount as Money objects" do
    td = TermDeposit.new(principal: 1000, term: 12.5, rate: 0.05, freq: 52, top_up: 100)
    expect(td.principal).to be_a(Money)
    expect(td.top_up).to be_a(Money)
  end

  it "calculates the final balance and inteset earned" do
    td = TermDeposit.new(principal: 10_000.00, term: 1.0, rate: 0.12, freq: 12, top_up: 0.0)
    td.calculate
    expect(td.final_balance).to be_a(Money)
    expect(td.final_balance.round.to_f).to eq 11_268.25

    expect(td.final_interest_earned).to be_a(Money)
    expect(td.final_interest_earned.round.to_f).to eq 1_268.25
  end

  describe "no top up Term Deposit re-invest" do
    it "calculates for monthly compounding and provides monthly compounding breakdown" do
      td = TermDeposit.new(
        principal: 10_000.00,
        term: 1.5,
        rate: 0.12,
        freq: 12
      )
      td.calculate
      expect(td.final_balance.round.to_f).to eq(11_961.47)
      expect(td.final_interest_earned.round.to_f).to eq(1961.47)
      expect(
        td.monthly_interests.map(&:interest_earned).map { |b| b.round.to_f }
      ).to eq(
        [
          100.0, 201.0, 303.01, 406.04, 510.1, 615.2,
          721.35, 828.57, 936.85, 1046.22, 1156.68, 1268.25,
          1380.93, 1494.74, 1609.69, 1725.79, 1843.04, 1961.47
        ]
      )
      expect(
        td.monthly_interests.map(&:balance).map { |b| b.round.to_f }
      ).to eq(
        [
          10_100.0, 10_201.0, 10_303.01, 10_406.04, 10_510.1, 10_615.2,
          10_721.35, 10_828.57, 10_936.85, 11_046.22, 11_156.68, 11_268.25,
          11_380.93, 11_494.74, 11_609.69, 11_725.79, 11_843.04, 11_961.47
        ]
      )
    end

    it "calculates for quarterly compounding and provides monthly compounding breakdown" do
      td = TermDeposit.new(
        principal: 10_000.00,
        term: 1.5,
        rate: 0.12,
        freq: 4
      )
      td.calculate
      expect(td.final_balance.round.to_f).to eq(11_940.52)
      expect(td.monthly_interests[5].interest_earned.round.to_f).to eq(609.00)

      expect(
        td.monthly_interests.map(&:interest_earned).map { |b| b.round.to_f }
      ).to eq(
        [99.02, 199.01, 300.0, 401.99, 504.98, 609.0,
         714.05, 820.13, 927.27, 1035.47, 1144.74, 1255.09,
         1366.53, 1479.08, 1592.74, 1707.53, 1823.45, 1940.52]
      )
      expect(
        td.monthly_interests.map(&:balance).map { |b| b.round.to_f }
      ).to eq(
        [10_099.02, 10_199.01, 10_300.0, 10_401.99, 10_504.98, 10_609.0, 10_714.05, 10_820.13, 10_927.27, 11_035.47,
         11_144.74, 11_255.09, 11_366.53, 11_479.08, 11_592.74, 11_707.53, 11_823.45, 11_940.52]
      )
    end

    it "calculates for interest paid at maturity/ no compounding" do
      td = TermDeposit.new(
        principal: 10_000.00,
        term: 1.5,
        rate: 0.12,
        freq: 0
      )
      td.calculate
      expect(td.final_balance.round.to_f).to eq(11_800.00)
      expect(td.final_interest_earned.round.to_f).to eq(1_800.00)
    end
  end

  describe "Cash deposits with top ups" do
    it "calculates for monthly compounding" do
      td = TermDeposit.new(
        principal: 10_000.00,
        term: 1.0,
        rate: 0.12,
        freq: 12,
        top_up: 100.00
      )
      td.calculate
      expect(td.final_balance.round.to_f).to eq(12_536.50)
      expect(
        td.monthly_interests.map(&:interest_earned).map { |b| b.round.to_f }
      ).to eq(
        [100.0, 202.0, 306.02, 412.08, 520.2, 630.4, 742.71, 857.13, 973.71, 1092.44, 1213.37, 1336.5]
      )
    end

    it "annual topup" do
      td = TermDeposit.new(
        principal: 10_000.00,
        term: 1.0,
        rate: 0.12,
        freq: 1,
        top_up: 100.00
      )
      td.calculate
      expect(td.final_balance.round.to_f).to eq(11_300.00)
    end

    it "weekly topup" do
      td = TermDeposit.new(
        principal: 10_000.00,
        term: 1.0,
        rate: 0.12,
        freq: 52,
        top_up: 100.00
      )
      td.calculate
      expect(td.final_balance.round.to_f).to eq(16_791.52)
      expect(td.final_interest_earned.round.to_f).to eq(1_591.52)
    end
  end
end
