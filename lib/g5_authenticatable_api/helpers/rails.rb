# frozen_string_literal: true

require 'g5_authenticatable_api/services/token_validator'
require 'g5_authenticatable_api/services/user_fetcher'

module G5AuthenticatableApi
  module Helpers
    # Helpers for rails API controllers
    module Rails
      def authenticate_api_user!
        raise_auth_error unless token_validator.valid?
      end

      def token_data
        @token_data ||= token_info.token_data
      end

      def current_api_user
        @current_api_user ||= user_fetcher.current_user
      end

      def access_token
        @access_token ||= token_info.access_token
      end

      def warden
        request.env['warden']
      end

      private

      def token_info
        @token_info ||= Services::TokenInfo.new(
          request.params,
          request.headers,
          warden
        )
      end

      def token_validator
        @token_validator ||= Services::TokenValidator.new(
          request.params,
          request.headers,
          warden
        )
      end

      def user_fetcher
        @user_fetcher ||= Services::UserFetcher.new(
          request.params,
          request.headers,
          warden
        )
      end

      def raise_auth_error
        auth_header = token_validator.auth_response_header
        response.headers['WWW-Authenticate'] = auth_header
        render json: { error: 'Unauthorized' },
               status: :unauthorized
      end
    end
  end
end
