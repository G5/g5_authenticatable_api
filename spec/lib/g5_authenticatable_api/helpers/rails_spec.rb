require 'spec_helper'

describe G5AuthenticatableApi::Helpers::Rails, type: :controller do
  controller(ActionController::Base) do
    before_action :authenticate_api_user!

    def index
      render json: [], status: :ok
    end
  end

  describe '#authenticate_api_user!' do
    subject(:authenticate_api_user!) { get :index, access_token: token_value }

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
        authenticate_api_user!
        expect(G5AuthenticatableApi::TokenValidator).to have_received(:new).
          with(request.params,
               an_instance_of(ActionDispatch::Http::Headers),
               request.env['warden'])
      end

      it 'is successful' do
        authenticate_api_user!
        expect(response).to be_success
      end

      it 'does not set the authenticate response header' do
        authenticate_api_user!
        expect(response).to_not have_header('WWW-Authenticate')
      end

      it 'sets the access token in the request env' do
        authenticate_api_user!
        expect(request.env['g5_access_token']).to eq(token_value)
      end
    end

    context 'when token is invalid' do
      let(:valid) { false }
      let(:auth_response_header) { 'whatever' }

      it 'is unauthorized' do
        authenticate_api_user!
        expect(response).to be_unauthorized
      end

      it 'renders an error message' do
        authenticate_api_user!
        expect(JSON.parse(response.body)).to eq('error' => 'Unauthorized')
      end

      it 'sets the authenticate response header' do
        authenticate_api_user!
        expect(response).to have_header('WWW-Authenticate' => auth_response_header)
      end
    end
  end

  describe '#token_info' do
    pending 'impelement me!'
  end

  describe '#current_auth_user' do
    pending 'implement me!'
  end
end
