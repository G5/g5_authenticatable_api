module G5AuthenticatableApi
  class UserFetcher
    def initialize(access_token)
      @access_token = access_token
    end

    def token_info
      auth_client.token_info
    end

    private
    def auth_client
      @auth_client ||= G5AuthenticationClient::Client.new(allow_password_credentials: 'false',
                                                          access_token: @access_token)
    end
  end
end
