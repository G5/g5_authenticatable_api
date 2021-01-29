# frozen_string_literal: true

source 'https://rubygems.org'

# Declare your gem's dependencies in g5_authenticatable_api.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Gems used by the dummy application
gem 'devise'
gem 'devise_g5_authenticatable', '~> 1.0'
gem 'grape'
gem 'jquery-rails'
gem 'pg'
gem 'rails', '5.1.1'

group :test, :development do
  gem 'appraisal'
  gem 'pry-byebug'
  gem 'rspec'
  gem 'rspec-rails', '~> 3.6'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :test do
  gem 'capybara'
  gem 'codeclimate-test-reporter', '~> 1.0'
  gem 'factory_girl_rails', '~> 4.3', require: false
  gem 'rack-test'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'simplecov', require: false
  gem 'webmock'
end

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.
# gem 'g5_authentication_client', github: 'G5/g5_authentication_client'
