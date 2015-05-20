require 'g5_authenticatable_api/services/service'

module G5AuthenticatableApi
  module Services
    class UserFetcher < Service
      attr_reader :access_token

      def initialize(access_token)
        @access_token = access_token
      end

      def current_user
        auth_client.me
      end
    end
  end
end
