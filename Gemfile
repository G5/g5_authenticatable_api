# frozen_string_literal: true

source 'https://rubygems.org'

# Declare your gem's dependencies in g5_authenticatable_api.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Gems used by the dummy application
gem 'devise'
gem 'devise_g5_authenticatable'
gem 'grape'
gem 'jquery-rails'
gem 'pg'
gem 'rails', '4.1.16'

group :test, :development do
  gem 'pry'
  gem 'rake', '< 11'
  gem 'rspec-rails', '~> 2.14'
end

group :test do
  gem 'capybara'
  gem 'codeclimate-test-reporter', '~> 1.0'
  gem 'factory_girl_rails', '~> 4.3', require: false
  gem 'rack-test', '0.6.2'
  gem 'rspec-http', require: false
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'webmock'
end

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.
# gem 'g5_authentication_client', github: 'G5/g5_authentication_client'

# To use debugger
# gem 'debugger'
