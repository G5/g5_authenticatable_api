require 'spec_helper'

describe G5AuthenticatableApi::UserFetcher do
  subject(:user_fetcher) { described_class.new(token_value) }
  let(:token_value) { 'abc123' }

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
end
