# frozen_string_literal: true

require "validators/input_validator"
class InputHandler
  attr_reader :validator

  def initialize(request_args:, validator: InputValidator.new(request_args))
    @validator = validator
  end

  def handle
    if validator.valid?
      validated_args = validator.valid_args

      begin
        calculator = TermDeposit.new(**validated_args)
        calculator.calculate
      rescue StandardError => e
        puts "Error: #{e.message} to be piped to some monitoring service"
        return { success: false, errors: ["Uh, oh, something went wrong. Please contact support team"] }
      end
      { success: true, result: calculator }
    else
      { success: false, errors: validator.errors.full_messages }
    end
  end
end
