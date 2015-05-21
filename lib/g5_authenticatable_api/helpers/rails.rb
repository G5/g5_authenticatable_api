require 'g5_authenticatable_api/services/token_validator'
require 'g5_authenticatable_api/services/user_fetcher'

module G5AuthenticatableApi
  module Helpers
    module Rails
      def authenticate_api_user!
        raise_auth_error if !token_validator.valid?
        self.access_token = token_validator.access_token
      end

      def warden
        request.env['warden']
      end

      def token_info
        user_fetcher.token_info
      end

      def current_api_user
        user_fetcher.current_user
      end

      def access_token=(token_value)
        request.env['g5_access_token'] = token_value
      end

      def access_token
        request.env['g5_access_token']
      end

      private
      def token_validator
        @token_validator ||= Services::TokenValidator.new(request.params, request.headers, warden)
      end

      def user_fetcher
        @user_fetcher ||= Services::UserFetcher.new(access_token, warden)
      end

      def raise_auth_error
        response.headers['WWW-Authenticate'] = token_validator.auth_response_header
        render json: {error: 'Unauthorized'},
               status: :unauthorized
      end
    end
  end
end
