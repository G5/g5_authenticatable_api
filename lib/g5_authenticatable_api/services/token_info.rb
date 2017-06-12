# frozen_string_literal: true

module G5AuthenticatableApi
  module Services
    # Extract access token from request to retrieve token data from G5 Auth
    class TokenInfo
      attr_reader :params, :headers, :warden

      def initialize(params = {}, headers = {}, warden = nil)
        @params = params || {}
        @headers = headers || {}
        @warden = warden
      end

      def access_token
        @access_token ||= begin
                            extract_token_from_header ||
                              extract_token_from_params ||
                              extract_token_from_warden
                          end
      end

      def token_data
        auth_client.token_info
      end

      def auth_client
        @auth_client ||= G5AuthenticationClient::Client.new(
          allow_password_credentials: 'false',
          access_token: access_token
        )
      end

      private

      def extract_token_from_header
        return unless authorization_header
        parts = authorization_header.match(/Bearer (?<access_token>\S+)/)
        parts['access_token']
      end

      def extract_token_from_params
        return if params['access_token'].blank?
        params['access_token']
      end

      def extract_token_from_warden
        warden.try(:user).try(:g5_access_token)
      end

      def authorization_header
        @headers['Authorization'] || @headers['AUTHORIZATION']
      end
    end
  end
end
