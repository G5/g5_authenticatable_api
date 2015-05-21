require 'g5_authenticatable_api/services/service'

module G5AuthenticatableApi
  module Services
    class UserFetcher < Service
      attr_reader :access_token

      def initialize(access_token, warden=nil)
        @access_token = access_token
        @warden = warden
      end

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
