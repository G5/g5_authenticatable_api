module G5AuthenticatableApi
  module GrapeHelpers
    def authenticate_user!
      if access_token
        begin
          g5_auth_client.token_info
        rescue OAuth2::Error => error
          error_code = error.code || 'invalid_request'
          auth_header = "Bearer error=\"#{error_code}\""
          auth_header << ",error_description=\"#{error.description}\"" if error.description
          throw :error, status: 401, headers: {'WWW-Authenticate' => auth_header}
        end
      else
        throw :error, status: 401, headers: {'WWW-Authenticate' => 'Bearer'}
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
  end
end
