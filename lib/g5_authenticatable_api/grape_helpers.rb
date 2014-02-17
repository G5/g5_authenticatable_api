module G5AuthenticatableApi
  module GrapeHelpers
    def authenticate_user!
      if access_token
        validate_access_token
      else
        throw :error, status: 401,
                      headers: {'WWW-Authenticate' => authenticate_header}
      end
    end

    def access_token
      @access_token ||= if env['HTTP_AUTHORIZATION']
        parts = env['HTTP_AUTHORIZATION'].match(/Bearer (?<access_token>\S+)/)
        parts['access_token']
      else
        Rack::Request.new(env).params['access_token']
      end
    end

    def g5_auth_client
      G5AuthenticationClient::Client.new(access_token: access_token)
    end

    private
    def validate_access_token
      begin
        g5_auth_client.token_info
      rescue OAuth2::Error => error
        throw :error, status: 401,
                      headers: {'WWW-Authenticate' => authenticate_header(error)}
      end
    end

    def authenticate_header(error=nil)
      auth_header = "Bearer"

      if error
        error_code = error.code || 'invalid_request'
        auth_header << " error=\"#{error_code}\""
        auth_header << ",error_description=\"#{error.description}\"" if error.description
      end

      auth_header
    end
  end
end
