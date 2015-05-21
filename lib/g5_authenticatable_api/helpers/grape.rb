require 'g5_authenticatable_api/services/token_validator'
require 'g5_authenticatable_api/services/user_fetcher'

module G5AuthenticatableApi
  module Helpers
    module Grape
      def authenticate_user!
        raise_auth_error if !token_validator.valid?
      end

      def token_data
        @token_data ||= token_info.token_data
      end

      def current_user
        @current_user ||= user_fetcher.current_user
      end

      def access_token
        @access_token ||= token_info.access_token
      end

      def warden
        env['warden']
      end

      private
      def request
        Rack::Request.new(env)
      end

      def token_info
        @token_info ||= Services::TokenInfo.new(request.params, headers, warden)
      end

      def token_validator
        @token_validator ||= Services::TokenValidator.new(request.params, headers, warden)
      end

      def user_fetcher
        @user_fetcher ||= Services::UserFetcher.new(request.params, headers, warden)
      end

      def raise_auth_error
        throw :error, message: 'Unauthorized',
                      status: 401,
                      headers: {'WWW-Authenticate' => token_validator.auth_response_header}
      end
    end
  end
end
