# frozen_string_literal: true

class InputHandler
  attr_reader :validator

  def initialize(request_args:, validator:)
    @request_args = request_args
    @validator = validator
  end

  def handle
    if validator.valid?
      { success: true, result: "result" }
    else
      { success: false, errors: validator.errors.full_messages }
    end
  end
end
