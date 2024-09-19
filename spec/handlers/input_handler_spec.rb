# frozen_string_literal: true

require "handlers/input_handler"

RSpec.describe InputHandler do
  let(:request_args) { { some_key: "some_value" } }
  let(:validator) { instance_double("InputValidator") }
  let(:input_handler) { InputHandler.new(request_args: request_args, validator:) }

  describe "#initialize" do
    it "assigns the validator" do
      expect(input_handler.validator).to eq(validator)
    end
  end

  describe "#handle" do
    context "when the input is valid" do
      it "returns success with the result" do
        allow(validator).to receive_messages(valid?: true, valid_args: "valid_args")
        result = input_handler.handle
        expect(result).to eq({ success: true, result: "result" })
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
