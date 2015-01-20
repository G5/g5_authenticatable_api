module G5AuthenticatableApi
  class TokenValidator
    attr_reader :error

    def initialize(params={},headers={},warden=nil)
      @params = params || {}
      @headers = headers || {}
      @warden = warden
    end

    def validate!
      begin
        auth_client.token_info unless skip_validation?
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
      @access_token ||= (extract_token_from_header ||
                         @params['access_token'] ||
                         @warden.try(:user).try(:g5_access_token))
    end

    def auth_response_header
      if error
        auth_header = "Bearer"

        if access_token
          auth_header << " error=\"#{error_code}\""
          auth_header << ",error_description=\"#{error_description}\"" if error_description
        end

        auth_header
      end
    end

    def auth_client
      @auth_client ||= G5AuthenticationClient::Client.new(allow_password_credentials: 'false',
                                                          access_token: access_token)
    end

    private
    def error_code
      error_code = error.code if error.respond_to?(:code)
      error_code || 'invalid_request'
    end

    def error_description
      error_description = error.description if error.respond_to?(:description)
      error_description
    end

    def extract_token_from_header
      if @headers['Authorization']
        parts = @headers['Authorization'].match(/Bearer (?<access_token>\S+)/)
        parts['access_token']
      end
    end

    def skip_validation?
      @warden.try(:user) && !G5AuthenticatableApi.strict_token_validation
    end
  end
end
