require 'g5_authenticatable_api/base_service'

module G5AuthenticatableApi
  class UserFetcher < BaseService
    attr_reader :access_token

    def initialize(access_token)
      @access_token = access_token
    end
  end
end
