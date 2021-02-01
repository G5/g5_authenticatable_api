# frozen_string_literal: true

# MUST happen before any other code is loaded
require 'simplecov'
SimpleCov.start 'rails'

require 'pry'

require  'support/shared_examples/model_configured_attribute'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.filter_run_when_matching :focus

  config.disable_monkey_patching!

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.order = 'random'

  Kernel.srand config.seed
end

require 'g5_authenticatable_api'
