module G5AuthenticatableApi
  class TokenValidator

    def initialize(token)
      @access_token = token
    end

    def validate_token!
      auth_client.token_info
    end

    def auth_client
      @auth_client ||= G5AuthenticationClient::Client.new(access_token: @access_token)
    end
  end
end
