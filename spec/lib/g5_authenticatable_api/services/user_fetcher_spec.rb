require 'spec_helper'

describe G5AuthenticatableApi::Services::UserFetcher do
  subject(:user_fetcher) { described_class.new(token_value, warden) }
  let(:token_value) { 'abc123' }
  let(:warden) {}

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

    context 'when there is no warden user' do
      it_behaves_like 'an auth user' do
        let(:user) { current_user }
      end
    end

    context 'when there is a warden user' do
      let(:warden) { double(:warden, user: warden_user) }

      context 'when the access_token is for the warden user' do
        let(:warden_user) { double(:user, g5_access_token: token_value) }

        it 'returns the warden user' do
          expect(current_user).to eq(warden_user)
        end
      end

      context 'when the access token is for a different user' do
        let(:warden_user) { double(:user, g5_access_token: "#{token_value}42") }

        it_behaves_like 'an auth user' do
          let(:user) { current_user }
        end
      end
    end
  end
end
