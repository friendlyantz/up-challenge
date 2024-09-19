# frozen_string_literal: true

require "validators/input_validator"

RSpec.describe InputValidator do
  subject { InputValidator.new(principal:, interest_rate:, term:, compounding:, top_up:) }

  context "with valid params" do
    let(:principal) { "1000" }
    let(:interest_rate) { "0.05" }
    let(:term) { "12.5" }
    let(:compounding) { "wEekLy" }
    let(:top_up) { 100 }

    it "is valid and returns valid args" do
      expect(subject).to be_valid
      expect(
        subject.valid_args
      ).to eq(
        {
          principal: 1000.0,
          term: 12.5,
          rate: 0.05,
          freq: 52,
          top_up: 100.00
        }
      )
    end
  end

  context "with invalid params" do
    let(:principal) { "abc" }
    let(:term) { -1 }
    let(:interest_rate) { 1.5 }
    let(:compounding) { "some unknown period" }
    let(:top_up) { -1 }

    it "is not valid" do
      expect(subject).not_to be_valid
      expect(subject.errors[:principal]).to include("is not a number")
      expect(subject.errors[:term]).to include("must be greater than 0")
      expect(subject.errors[:interest_rate]).to include("must be less than 1")
      expect(subject.errors[:compounding]).to include("Interest period is not included")
      expect(subject.errors[:top_up]).to include("must be greater than or equal to 0")
    end
  end
end
