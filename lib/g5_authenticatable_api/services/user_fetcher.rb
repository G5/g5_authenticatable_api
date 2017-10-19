# frozen_string_literal: true

require 'g5_authenticatable_api/services/token_info'

module G5AuthenticatableApi
  module Services
    # Fetch user data from G5 Auth based on access token
    class UserFetcher < TokenInfo
      def current_user
        if access_token == @warden.try(:user).try(:g5_access_token)
          @warden.user
        else
          auth_client.me
        end
      end
    end
  end
end
