require 'spec_helper'

describe G5AuthenticatableApi::Services::UserFetcher do
  subject(:user_fetcher) { described_class.new(token_value) }
  let(:token_value) { 'abc123' }

  describe '#access_token' do
    subject(:access_token) { user_fetcher.access_token }

    it 'returns the initialized token value' do
      expect(access_token).to eq(token_value)
    end
  end

  describe '#token_info' do
    subject(:token_info) { user_fetcher.token_info }

    context 'when token is valid' do
      include_context 'valid access token'

      it 'includes the resource_owner_id' do
        expect(token_info.resource_owner_id).to eq(raw_token_info['resource_owner_id'])
      end

      it 'includes the expires_in_seconds' do
        expect(token_info.expires_in_seconds).to eq(raw_token_info['expires_in_seconds'])
      end

      it 'includes the application_uid' do
        expect(token_info.application_uid).to eq(raw_token_info['application']['uid'])
      end

      it 'includes the scopes' do
        expect(token_info.scopes). to eq(raw_token_info['scopes'])
      end
    end

    context 'when token is invalid' do
      include_context 'invalid access token'

      it 'raises an error' do
        expect { token_info }.to raise_error
      end
    end
  end

  describe '#current_user' do
    include_context 'current auth user'

    subject(:current_user) { user_fetcher.current_user }

    it 'has the correct id' do
      expect(current_user.id).to eq(raw_user_info['id'])
    end

    it 'has the correct email' do
      expect(current_user.email).to eq(raw_user_info['email'])
    end

    it 'has the correct first_name' do
      expect(current_user.first_name).to eq(raw_user_info['first_name'])
    end

    it 'has the correct last_name' do
      expect(current_user.last_name).to eq(raw_user_info['last_name'])
    end

    it 'has the correct number of roles' do
      expect(current_user.roles.count).to eq(raw_user_info['roles'].count)
    end
  end
end
