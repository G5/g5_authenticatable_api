module G5AuthenticatableApi
  module Services
    class TokenInfo
      attr_reader :params, :headers, :warden

      def initialize(params={},headers={},warden=nil)
        @params = params || {}
        @headers = headers || {}
        @warden = warden
      end

      def access_token
        @access_token ||= (extract_token_from_header ||
                           params['access_token'] ||
                           warden.try(:user).try(:g5_access_token))
      end

      def token_data
        auth_client.token_info
      end

      def auth_client
        @auth_client ||= G5AuthenticationClient::Client.new(allow_password_credentials: 'false',
                                                            access_token: access_token)
      end

      private
      def extract_token_from_header
        if authorization_header
          parts = authorization_header.match(/Bearer (?<access_token>\S+)/)
          parts['access_token']
        end
      end

      def authorization_header
        @headers['Authorization'] || @headers['AUTHORIZATION']
      end
    end
  end
end
