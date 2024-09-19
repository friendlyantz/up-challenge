# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.3.5"

gem "activemodel"
gem "money"

gem "rack"
gem "rackup"
gem "sinatra"

group :test, :development do
  gem "rerun"
  gem "super_diff"
end

group :test do
  gem "capybara"
  gem "rspec"
  gem "rspec-example_steps"
  gem "rubocop"
  gem "rubocop-rspec"
  gem "simplecov"
  gem "webdrivers", require: false
end
