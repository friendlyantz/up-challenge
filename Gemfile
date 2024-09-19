# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.3.5"

gem "rack"
gem "rackup"
gem "sinatra"

group :test, :development do
  gem "rerun"
end

group :test do
  gem "capybara"
  gem "rspec"
  gem "rspec-example_steps"
  gem "rubocop"
  gem "rubocop-rspec"
  gem "webdrivers", require: false
end
