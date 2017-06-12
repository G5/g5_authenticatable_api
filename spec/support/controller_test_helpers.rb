# frozen_string_literal: true

module ControllerTestHelpers
  def build_request_options(params = nil, headers = {})
    params = headers unless params

    if Rails.version.starts_with?('4')
      [params, headers]
    else
      [{ params: params, headers: headers }]
    end
  end
end

RSpec.configure do |config|
  config.include ControllerTestHelpers
end
