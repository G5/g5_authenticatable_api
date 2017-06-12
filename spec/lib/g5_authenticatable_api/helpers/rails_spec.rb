# frozen_string_literal: true

require 'rails_helper'

RSpec.describe G5AuthenticatableApi::Helpers::Rails, type: :controller do
  controller(ActionController::Base) do
    before_action :authenticate_api_user!, only: :index

    def index
      render json: [], status: :ok
    end

    def new
      render json: [], status: :ok
    end
  end

  let(:warden) { double(:warden) }
  before { request.env['warden'] = warden }

  describe '#authenticate_api_user!' do
    subject(:authenticate_api_user!) do
      get :index, *build_request_options(access_token: token_value)
    end

    let(:token_value) { 'abc123' }

    let(:token_validator) do
      double(:token_validator, valid?: valid,
                               auth_response_header: auth_response_header,
                               access_token: token_value)
    end
    before do
      allow(G5AuthenticatableApi::Services::TokenValidator).to receive(:new)
        .and_return(token_validator)
    end

    context 'when token is valid' do
      let(:valid) { true }
      let(:auth_response_header) {}

      it 'initializes the token validator correctly' do
        authenticate_api_user!
        expect(G5AuthenticatableApi::Services::TokenValidator)
          .to have_received(:new)
          .with(request.params,
                an_instance_of(ActionDispatch::Http::Headers),
                warden)
      end

      it 'is successful' do
        authenticate_api_user!
        expect(response).to be_success
      end

      it 'does not set the authenticate response header' do
        authenticate_api_user!
        expect(response.headers).to_not have_key('WWW-Authenticate')
      end
    end

    context 'when token is invalid' do
      let(:valid) { false }
      let(:auth_response_header) { 'whatever' }

      it 'is unauthorized' do
        authenticate_api_user!
        expect(response.status).to eq(401)
      end

      it 'renders an error message' do
        authenticate_api_user!
        expect(JSON.parse(response.body)).to eq('error' => 'Unauthorized')
      end
    end
  end

  describe '#token_data' do
    subject(:token_data) { controller.token_data }

    before do
      allow(G5AuthenticatableApi::Services::TokenInfo).to receive(:new)
        .and_return(token_info)
    end
    let(:token_info) { double(:user_fetcher, token_data: mock_token_data) }
    let(:mock_token_data) { double(:token_info) }

    before { get :new, *build_request_options(access_token: 'abc123') }

    it 'initializes the token info service correctly' do
      token_data
      expect(G5AuthenticatableApi::Services::TokenInfo)
        .to have_received(:new)
        .with(request.params,
              an_instance_of(ActionDispatch::Http::Headers),
              warden)
    end

    it 'returns the token data from the service' do
      expect(token_data).to eq(mock_token_data)
    end
  end

  describe '#access_token' do
    subject(:access_token) { controller.access_token }

    before do
      allow(G5AuthenticatableApi::Services::TokenInfo).to receive(:new)
        .and_return(token_info)
    end
    let(:token_info) { double(:token_info, access_token: token_value) }
    let(:token_value) { 'abc123' }

    before { get :new, *build_request_options(access_token: token_value) }

    it 'initializes the token info service correctly' do
      access_token
      expect(G5AuthenticatableApi::Services::TokenInfo)
        .to have_received(:new)
        .with(request.params,
              an_instance_of(ActionDispatch::Http::Headers),
              warden)
    end

    it 'returns the access token from the service' do
      expect(access_token).to eq(token_value)
    end
  end

  describe '#current_api_user' do
    subject(:current_api_user) { controller.current_api_user }

    before do
      allow(G5AuthenticatableApi::Services::UserFetcher).to receive(:new)
        .and_return(user_fetcher)
    end
    let(:user_fetcher) { double(:user_fetcher, current_user: user) }
    let(:user) { double(:user) }

    before { get :new, *build_request_options(access_token: 'abc123') }

    it 'initializes the user fetcher service correctly' do
      current_api_user
      expect(G5AuthenticatableApi::Services::UserFetcher).to have_received(:new)
        .with(request.params,
              an_instance_of(ActionDispatch::Http::Headers),
              warden)
    end

    it 'returns the user from the service' do
      expect(current_api_user).to eq(user)
    end
  end
end
