module UserRequestMethods
  def stub_g5_omniauth(user, options={})
    OmniAuth.config.mock_auth[:g5] = OmniAuth::AuthHash.new({
      uid: user.uid,
      provider: 'g5',
      info: {email: user.email},
      credentials: {token: user.g5_access_token}
    }.merge(options))
  end
end

RSpec.configure do |config|
  config.before { OmniAuth.config.test_mode = true }
  config.after { OmniAuth.config.test_mode = false }

  config.include UserRequestMethods, type: :request
end

