# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/module/attribute_accessors'

require 'g5_authenticatable_api/version'
require 'g5_authenticatable_api/configuration'
require 'g5_authenticatable_api/helpers/grape'
require 'g5_authenticatable_api/railtie' if defined?(Rails)

# Token-based authentication for protecting rails API endpoints with G5 Auth
module G5AuthenticatableApi
  # When enabled, strict token validation will validate the session user's
  # access_token against the auth server for every request (if there is
  # an existing session in warden). Disabled by default.
  @@strict_token_validation = false
  mattr_accessor :strict_token_validation
end
