require 'spec_helper'

describe G5AuthenticatableApi::Helpers::Grape do
  include Rack::Test::Methods

  def app
    Class.new(Grape::API) do
      helpers G5AuthenticatableApi::Helpers::Grape

      before { authenticate_user! }

      get :index do
        { hello: 'world' }
      end
    end
  end

  describe '#authenticate_user!' do
    subject(:authenticate_user!) { get :index, params, env }
    let(:params) { {'access_token' => token_value} }
    let(:env) { {'warden' => warden} }
    let(:warden) { double(:warden) }

    let(:token_value) { 'abc123' }

    let(:token_validator) do
      double(:token_validator, valid?: valid,
                               auth_response_header: auth_response_header,
                               access_token: token_value)
    end
    before do
      allow(G5AuthenticatableApi::TokenValidator).to receive(:new).
        and_return(token_validator)
    end

    context 'when token is valid' do
      let(:valid) { true }
      let(:auth_response_header) {}

      it 'initializes the token validator correctly' do
        authenticate_user!
        expect(G5AuthenticatableApi::TokenValidator).to have_received(:new).
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

  end
  describe '#current_auth_user' do
    pending 'implement me!'
  end
end
