module G5AuthenticatableApi
  module GrapeHelpers
    def authenticate_user!
      throw :error, status: 401, headers: {'WWW-Authenticate' => 'Bearer'}
    end
  end
end
