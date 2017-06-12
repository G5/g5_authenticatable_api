# frozen_string_literal: true

RSpec.shared_examples_for 'a warden authenticatable api' do
  context 'when user is authenticated' do
    let(:user) { create(:user) }
    let(:token_value) { user.g5_access_token }

    before { login_as(user, scope: :user) }
    after { logout }

    context 'when strict token validation is enabled' do
      before do
        G5AuthenticatableApi.strict_token_validation = true
      end

      include_examples 'token validation'
    end

    context 'when strict token validation is disabled' do
      before do
        G5AuthenticatableApi.strict_token_validation = false
        subject
      end

      it 'should be successful' do
        expect(response).to be_success
      end

      it 'should not validate the token against the auth server' do
        expect(a_request(:get, 'auth.g5search.com/oauth/token/info'))
          .to_not have_been_made
      end
    end
  end

  context 'when user is not authenticated' do
    before do
      logout
      subject
    end

    it 'should be unauthorized' do
      expect(response.status).to eq(401)
    end

    it 'should return an authenticate header without details' do
      expect(response.headers['WWW-Authenticate']).to eq('Bearer')
    end
  end
end
