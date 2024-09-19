# frozen_string_literal: true

require "spec_helper"
require "term_deposit"

RSpec.describe TermDeposit, type: :model do
  it "instantiates with principal and top up amount as Money objects" do
    td = TermDeposit.new(principal: 1000, term: 12.5, rate: 0.05, freq: 52, top_up: 100)
    expect(td.principal).to be_a(Money)
    expect(td.top_up).to be_a(Money)
  end
end
