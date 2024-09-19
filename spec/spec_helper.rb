# frozen_string_literal: true

require 'capybara'
require 'capybara/rspec'
require 'rack/test'
require 'rspec/example_steps'
require 'super_diff/rspec'
require 'simplecov'

require 'app'

ENV['RACK_ENV'] = 'test'
Capybara.server = :webrick
Capybara.app = Sinatra::Application

SimpleCov.start

RSpec.configure do |config|
  include Rack::Test::Methods
  def app
    Sinatra::Application
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = "spec/examples.txt"
  config.disable_monkey_patching!
  config.warnings = true

  config.default_formatter = "doc" if config.files_to_run.one?

  config.profile_examples = 10

  config.order = :random

  Kernel.srand config.seed
end
