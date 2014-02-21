RSpec.configure do |config|
  config.include Warden::Test::Helpers, type: :request
  config.after { Warden.test_reset! }
end
