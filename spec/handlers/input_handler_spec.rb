# frozen_string_literal: true

# spec/input_handler_spec.rb
require "handlers/input_handler"
require "term_deposit"

RSpec.describe InputHandler do
  let(:request_args) { { some_key: "some_value" } }
  let(:validator) { instance_double("InputValidator") }
  let(:input_handler) { InputHandler.new(request_args:, validator:) }

  describe "#handle" do
    context "when the input is valid" do
      let(:validated_args) { { principal: 1000, term: 12, rate: 5, freq: 4 } }
      let(:term_deposit) { instance_double(TermDeposit) }

      before do
        allow(validator).to receive_messages(valid?: true, valid_args: validated_args)
        allow(TermDeposit).to receive(:new).and_return(term_deposit)
        allow(term_deposit).to receive(:calculate).and_return("calculated_result")
      end

      it "returns success with the result" do
        result = input_handler.handle
        expect(result).to eq({ success: true, result: term_deposit })
      end
    end

    context "when the input is invalid" do
      let(:errors) { instance_double("Errors", full_messages: %w[error1 error2]) }

      it "returns failure with errors" do
        allow(validator).to receive_messages(valid?: false, errors:)
        result = input_handler.handle
        expect(result).to eq({ success: false, errors: %w[error1 error2] })
      end
    end
  end
end
