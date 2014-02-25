require 'g5_authenticatable_api/token_validator'

module G5AuthenticatableApi
  module GrapeHelpers
    def authenticate_user!
      unless warden.try(:authenticated?)
        if token_validator.access_token
          validate_access_token
        else
          throw :error, message: 'Unauthorized',
                        status: 401,
                        headers: {'WWW-Authenticate' => authenticate_response_header}
        end
      end
    end

    def warden
      env['warden']
    end

    private
    def token_validator
      request = Rack::Request.new(env)
      @token_validator ||= TokenValidator.new(request.params, headers)
    end

    def validate_access_token
      unless token_validator.valid?
        throw :error, message: 'Unauthorized',
                      status: 401,
                      headers: {'WWW-Authenticate' => authenticate_response_header(token_validator.error)}
      end
    end

    def authenticate_response_header(error=nil)
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
