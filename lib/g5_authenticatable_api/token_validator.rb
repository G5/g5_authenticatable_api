module G5AuthenticatableApi
  class TokenValidator
    def initialize(params={},headers={})
      @params = params || {}
      @headers = headers || {}
    end

    def validate_token!
      auth_client.token_info
    end

    def valid?
      begin
        validate_token!
        true
      rescue StandardError => e
        false
      end
    end

    def access_token
      @access_token ||= if @headers['Authorization']
        parts = @headers['Authorization'].match(/Bearer (?<access_token>\S+)/)
        parts['access_token']
      else
        @params['access_token']
      end
    end

    def auth_client
      @auth_client ||= G5AuthenticationClient::Client.new(access_token: access_token)
    end
  end
end
