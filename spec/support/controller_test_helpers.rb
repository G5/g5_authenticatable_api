# frozen_string_literal: true

module ControllerTestHelpers
  def safe_get(endpoint, params = nil, headers = nil)
    safe_request(:get, endpoint, params, headers)
  end

  def safe_post(endpoint, params = nil, headers = nil)
    safe_request(:post, endpoint, params, headers)
  end

  def safe_request(method_name, endpoint, params = nil, headers = nil)
    if Rails.version.starts_with?('4')
      send(method_name, endpoint, params, headers)
    else
      options = { params: params }
      options[:headers] = headers if headers
      send(method_name, endpoint, **options)
    end
  end
end

RSpec.configure do |config|
  config.include ControllerTestHelpers, type: :controller
  config.include ControllerTestHelpers, type: :request
end
