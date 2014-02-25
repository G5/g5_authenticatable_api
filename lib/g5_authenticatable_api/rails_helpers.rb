module G5AuthenticatableApi
  module RailsHelpers
    def authenticate_api_user!
      raise_auth_error if !(warden.try(:authenticated?) || token_validator.valid?)
    end

    def warden
      request.env['warden']
    end

    private
    def token_validator
      @token_validator ||= TokenValidator.new(request.params, request.headers)
    end

    def raise_auth_error
      response.headers['WWW-Authenticate'] = token_validator.auth_response_header
      render json: {error: 'Unauthorized'},
             status: :unauthorized
    end
  end
end
