module G5AuthenticatableApi
  module GrapeHelpers
    def authenticate_user!
      unless access_token
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
