require 'spec_helper'

describe G5AuthenticatableApi::Helpers::Grape do
  include Rack::Test::Methods

  def app
    Class.new(Grape::API) do
      helpers G5AuthenticatableApi::Helpers::Grape

      get :authenticate do
        authenticate_user!
        { hello: 'world' }
      end

      get :token_data do
        token_data.to_json
      end

      get :current_user do
        current_user.to_json
      end

      get :access_token do
        [access_token]
      end
    end
  end

  let(:env) { {'warden' => warden} }
  let(:warden) { double(:warden) }

  let(:params) { {'access_token' => token_value} }
  let(:token_value) { 'abc123' }

  let(:headers) { {'Host'=>'example.org', 'Cookie'=>''} }

  describe '#authenticate_user!' do
    subject(:authenticate_user!) { get '/authenticate', params, env }

    let(:token_validator) do
      double(:token_validator, valid?: valid,
                               auth_response_header: auth_response_header,
                               access_token: token_value)
    end
    before do
      allow(G5AuthenticatableApi::Services::TokenValidator).to receive(:new).
        and_return(token_validator)
    end

    context 'when token is valid' do
      let(:valid) { true }
      let(:auth_response_header) {}

      it 'initializes the token validator correctly' do
        authenticate_user!
        expect(G5AuthenticatableApi::Services::TokenValidator).to have_received(:new).
          with(params, headers, warden)
      end

      it 'is successful' do
        authenticate_user!
        expect(last_response).to be_http_ok
      end

      it 'does not set the authenticate response header' do
        authenticate_user!
        expect(last_response).to_not have_header('WWW-Authenticate')
      end
    end

    context 'when token is invalid' do
      let(:valid) { false }
      let(:auth_response_header) { 'whatever' }

      it 'is unauthorized' do
        authenticate_user!
        expect(last_response).to be_http_unauthorized
      end

      it 'renders an error message' do
        authenticate_user!
        expect(last_response.body).to eq('Unauthorized')
      end

      it 'sets the authenticate response header' do
        authenticate_user!
        expect(last_response).to have_header('WWW-Authenticate' => auth_response_header)
      end
    end
  end

  describe '#token_data' do
    subject(:token_data) { get '/token_data', params, env }

    before do
      allow(G5AuthenticatableApi::Services::TokenInfo).to receive(:new).
        and_return(token_info)
    end
    let(:token_info) { double(:token_info, token_data: mock_token_data) }
    let(:mock_token_data) { double(:token_data, to_json: '{result: mock_token_data_json}') }

    it 'initializes the token info service correctly' do
      token_data
      expect(G5AuthenticatableApi::Services::TokenInfo).to have_received(:new).
        with(params, headers, warden)
    end

    it 'returns the token info from the service' do
      token_data
      expect(last_response.body).to eq(mock_token_data.to_json)
    end
  end

  describe '#current_user' do
    subject(:current_user) { get '/current_user', params, env }

    before do
      allow(G5AuthenticatableApi::Services::UserFetcher).to receive(:new).
        and_return(user_fetcher)
    end
    let(:user_fetcher) { double(:user_fetcher, current_user: user) }
    let(:user) { double(:user, to_json: '{result: mock_user_json}') }

    it 'initializes the user fetcher service correctly' do
      current_user
      expect(G5AuthenticatableApi::Services::UserFetcher).to have_received(:new).
        with(params, headers, warden)
    end

    it 'returns the user from the service' do
      current_user
      expect(last_response.body).to eq(user.to_json)
    end
  end

  describe '#access_token' do
    subject(:access_token) { get '/access_token', params, env }

    before do
      allow(G5AuthenticatableApi::Services::TokenInfo).to receive(:new).
        and_return(token_info)
    end
    let(:token_info) { double(:token_info, access_token: token_value) }

    it 'initializes the token info service correctly' do
      access_token
      expect(G5AuthenticatableApi::Services::TokenInfo).to have_received(:new).
        with(params, headers, warden)
    end

    it 'returns the access token from the service' do
      access_token
      expect(last_response.body).to eq([token_value].to_json)
    end
  end
end
