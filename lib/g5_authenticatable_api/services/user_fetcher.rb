require 'g5_authenticatable_api/services/token_info'

module G5AuthenticatableApi
  module Services
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
