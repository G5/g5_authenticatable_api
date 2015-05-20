require 'g5_authenticatable_api/services/token_validator'
require 'g5_authenticatable_api/services/user_fetcher'

module G5AuthenticatableApi
  module Helpers
    module Grape
      def authenticate_user!
        raise_auth_error if !token_validator.valid?
        env['g5_access_token'] = token_validator.access_token
      end

      def warden
        env['warden']
      end

      private
      def token_validator
        request = Rack::Request.new(env)
        @token_validator ||= Services::TokenValidator.new(request.params, headers, warden)
      end

      def raise_auth_error
        throw :error, message: 'Unauthorized',
                      status: 401,
                      headers: {'WWW-Authenticate' => token_validator.auth_response_header}
      end
    end
  end
end
