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

      get :token_info do
        token_info.to_json
      end

      get :current_user do
        current_user.to_json
      end
    end
  end

  let(:env) { {'warden' => warden} }
  let(:warden) { double(:warden) }

  describe '#authenticate_user!' do
    subject(:authenticate_user!) { get :authenticate, params, env }
    let(:params) { {'access_token' => token_value} }

    let(:token_value) { 'abc123' }

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
          with(params,
               {'Host'=>'example.org', 'Cookie'=>''},
               warden)
      end

      it 'is successful' do
        authenticate_user!
        expect(last_response).to be_http_ok
      end

      it 'does not set the authenticate response header' do
        authenticate_user!
        expect(last_response).to_not have_header('WWW-Authenticate')
      end

      it 'sets the access_token in the request env' do
        authenticate_user!
        expect(last_request.env['g5_access_token']).to eq(token_value)
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

  describe '#token_info' do
    subject(:token_info) { get :token_info, {}, env }
    before { env['g5_access_token'] = token_value }
    let(:token_value) { 'abc123' }

    before do
      allow(G5AuthenticatableApi::Services::UserFetcher).to receive(:new).
        and_return(user_fetcher)
    end
    let(:user_fetcher) { double(:user_fetcher, token_info: mock_token_info) }
    let(:mock_token_info) { double(:token_info, to_json: '{result: mock_token_info_json}') }

    it 'initializes the user fetcher service correctly' do
      token_info
      expect(G5AuthenticatableApi::Services::UserFetcher).to have_received(:new).
        with(token_value, warden)
    end

    it 'returns the token info from the service' do
      token_info
      expect(last_response.body).to eq(mock_token_info.to_json)
    end
  end

  describe '#current_user' do
    subject(:current_user) { get :current_user, {}, env }
    before { env['g5_access_token'] = token_value }
    let(:token_value) { 'abc123' }

    before do
      allow(G5AuthenticatableApi::Services::UserFetcher).to receive(:new).
        and_return(user_fetcher)
    end
    let(:user_fetcher) { double(:user_fetcher, current_user: user) }
    let(:user) { double(:user, to_json: '{result: mock_user_json}') }

    it 'initializes the user fetcher service correctly' do
      current_user
      expect(G5AuthenticatableApi::Services::UserFetcher).to have_received(:new).
        with(token_value, warden)
    end

    it 'returns the user from the service' do
      current_user
      expect(last_response.body).to eq(user.to_json)
    end
  end
end
