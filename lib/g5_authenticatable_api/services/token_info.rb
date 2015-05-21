module G5AuthenticatableApi
  module Services
    # The base class for all other service objects to extend
    class Service
      def access_token
        raise 'Not implemented'
      end

      def token_info
        auth_client.token_info
      end

      def auth_client
        @auth_client ||= G5AuthenticationClient::Client.new(allow_password_credentials: 'false',
                                                            access_token: access_token)
      end
    end
  end
end
