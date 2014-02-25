require 'g5_authenticatable_api/token_validator'

module G5AuthenticatableApi
  module GrapeHelpers
    def authenticate_user!
      raise_error if !(warden.try(:authenticated?) || token_validator.valid?)
    end

    def warden
      env['warden']
    end

    private
    def token_validator
      request = Rack::Request.new(env)
      @token_validator ||= TokenValidator.new(request.params, headers)
    end

    def raise_error
      throw :error, message: 'Unauthorized',
                    status: 401,
                    headers: {'WWW-Authenticate' => token_validator.auth_response_header}
    end
  end
end
