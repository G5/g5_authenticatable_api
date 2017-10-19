# frozen_string_literal: true

RSpec.configure do |config|
  config.include Warden::Test::Helpers, type: :request
  config.after(type: :request) { Warden.test_reset! }
end
