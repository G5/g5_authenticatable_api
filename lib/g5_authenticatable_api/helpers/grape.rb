# frozen_string_literal: true

require 'g5_authenticatable_api/services/token_validator'
require 'g5_authenticatable_api/services/user_fetcher'

module G5AuthenticatableApi
  module Helpers
    # Helper methods for securing a Grape API
    module Grape
      def authenticate_user!
        raise_auth_error unless token_validator.valid?
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

      def request
        Rack::Request.new(env)
      end

      protected

      def token_info
        @token_info ||= Services::TokenInfo.new(request.params, headers, warden)
      end

      def token_validator
        @token_validator ||= Services::TokenValidator.new(request.params,
                                                          headers,
                                                          warden)
      end

      def user_fetcher
        @user_fetcher ||= Services::UserFetcher.new(request.params,
                                                    headers,
                                                    warden)
      end

      def raise_auth_error
        auth_header = {
          'WWW-Authenticate' => token_validator.auth_response_header
        }
        throw :error, message: 'Unauthorized',
                      status: 401,
                      headers: auth_header
      end
    end
  end
end
