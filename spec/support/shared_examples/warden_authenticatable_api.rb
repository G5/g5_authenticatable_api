require 'spec_helper'

shared_examples_for 'a warden authenticatable api' do
  context 'when user is authenticated' do
    let(:user) { create(:user) }
    let(:token_value) { user.g5_access_token }

    before { login_as(user, scope: :user) }
    after { logout }

    include_examples 'token validation'
  end

  context 'when user is not authenticated' do
    before do
     logout
     subject
    end

    it 'should be unauthorized' do
      expect(response).to be_http_unauthorized
    end

    it 'should return an authenticate header without details' do
      expect(response.headers).to include('WWW-Authenticate' => 'Bearer')
    end
  end
end
