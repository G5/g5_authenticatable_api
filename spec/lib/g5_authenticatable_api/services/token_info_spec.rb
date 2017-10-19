# frozen_string_literal: true

require 'rails_helper'

RSpec.describe G5AuthenticatableApi::Services::TokenInfo do
  subject(:token_info) { described_class.new(params, headers, warden) }
  let(:params) { { 'access_token' => token_value } }
  let(:headers) { {} }
  let(:warden) {}

  let(:token_value) { 'abc123' }

  describe '#initialize' do
    let(:params) { { 'foo' => 'bar' } }
    let(:headers) { { 'Content-Type' => 'application/json' } }

    context 'with warden' do
      let(:warden) { double(:warden) }

      it 'sets the params' do
        expect(token_info.params).to eq(params)
      end

      it 'sets the headers' do
        expect(token_info.headers).to eq(headers)
      end

      it 'sets warden' do
        expect(token_info.warden).to eq(warden)
      end
    end

    context 'without warden' do
      let(:token_info) { described_class.new(params, headers) }

      it 'sets the params' do
        expect(token_info.params).to eq(params)
      end

      it 'sets the headers' do
        expect(token_info.headers).to eq(headers)
      end

      it 'defaults warden to nil' do
        expect(token_info.warden).to be_nil
      end
    end
  end

  describe '#access_token' do
    subject(:access_token) { token_info.access_token }

    context 'with auth header' do
      let(:headers) { { 'Authorization' => "Bearer #{token_value}" } }
      let(:params) {}

      it 'should extract the token value from the header' do
        expect(access_token).to eq(token_value)
      end
    end

    context 'with all caps authorization key' do
      let(:headers) { { 'AUTHORIZATION' => "Bearer #{token_value}" } }
      let(:params) {}

      it 'should extract the token value from the header' do
        expect(access_token).to eq(token_value)
      end
    end

    context 'with auth param' do
      let(:params) { { 'access_token' => token_value } }
      let(:headers) {}

      it 'should extract the token value from the access_token parameter' do
        expect(access_token).to eq(token_value)
      end
    end

    context 'with warden user' do
      let(:warden) { double(:warden, user: user) }
      let(:user) { FactoryGirl.build_stubbed(:user) }

      context 'without token on request' do
        let(:params) {}
        let(:headers) {}

        it 'should extract the token value from the session user' do
          expect(access_token).to eq(user.g5_access_token)
        end
      end

      context 'with auth param' do
        let(:params) { { 'access_token' => token_value } }
        let(:headers) {}

        it 'should give precedence to the token on the request' do
          expect(access_token).to eq(token_value)
        end
      end
    end
  end

  describe '#token_data' do
    subject(:token_data) { token_info.token_data }

    context 'when token is valid' do
      include_context 'valid access token'

      it 'includes the resource_owner_id' do
        expect(token_data.resource_owner_id)
          .to eq(raw_token_info['resource_owner_id'])
      end

      it 'includes the expires_in_seconds' do
        expect(token_data.expires_in_seconds)
          .to eq(raw_token_info['expires_in_seconds'])
      end

      it 'includes the application_uid' do
        expect(token_data.application_uid)
          .to eq(raw_token_info['application']['uid'])
      end

      it 'includes the scopes' do
        expect(token_data.scopes)
          .to eq(raw_token_info['scopes'])
      end
    end

    context 'when token is invalid' do
      include_context 'invalid access token'

      it 'raises an error' do
        expect { token_data }.to raise_error(OAuth2::Error)
      end
    end
  end

  describe '#auth_client' do
    subject(:auth_client) { token_info.auth_client }

    let(:client) { double(:auth_client) }
    before do
      allow(G5AuthenticationClient::Client).to receive(:new).and_return(client)
    end

    it 'returns the initialized client' do
      expect(auth_client).to eq(client)
    end

    it 'initializes the client with the token' do
      auth_client
      expect(G5AuthenticationClient::Client).to have_received(:new)
        .with(hash_including(access_token: token_value))
    end

    it 'disables password access on the client' do
      auth_client
      expect(G5AuthenticationClient::Client).to have_received(:new)
        .with(hash_including(allow_password_credentials: 'false'))
    end
  end
end
