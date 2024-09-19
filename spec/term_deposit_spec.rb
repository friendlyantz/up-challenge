# frozen_string_literal: true

require "spec_helper"
require "term_deposit"

RSpec.describe TermDeposit, type: :model do
  it "instantiates with principal and top up amount as Money objects" do
    td = TermDeposit.new(principal: 1000, term: 12.5, rate: 0.05, freq: 52, top_up: 100)
    expect(td.principal).to be_a(Money)
    expect(td.top_up).to be_a(Money)
  end

  it "calculates the final balance" do
    td = TermDeposit.new(principal: 10_000.00, term: 1.0, rate: 0.12, freq: 12, top_up: 0.0)
    expect(td.final_balance).to be_a(Money)
    expect(td.final_balance.round.to_f).to eq 11_268.25

    expect(td.final_interest_earned).to be_a(Money)
    expect(td.final_interest_earned.round.to_f).to eq 1_268.25
  end
end
