module G5AuthenticatableApi
  class TokenValidator
    attr_reader :error

    def initialize(params={},headers={})
      @params = params || {}
      @headers = headers || {}
    end

    def validate!
      begin
        auth_client.token_info
      rescue StandardError => @error
        raise error
      end
    end

    def valid?
      begin
        validate!
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
