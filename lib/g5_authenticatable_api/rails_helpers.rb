module G5AuthenticatableApi
  module RailsHelpers
    def authenticate_api_user!
      unless warden.try(:authenticated?)
        render status: :unauthorized,
               text: {error: 'Unauthorized'}.to_json
      end
    end

    def warden
      request.env['warden']
    end
  end
end
