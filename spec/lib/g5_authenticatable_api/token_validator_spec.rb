require 'spec_helper'

describe G5AuthenticatableApi::TokenValidator do
  subject { validator }

  let(:validator) { described_class.new(params, headers) }

  let(:headers) {}
  let(:params) { {'access_token' => token_value} }
  let(:token_value) { 'abc123' }

  describe '#access_token' do
    subject(:access_token) { validator.access_token }

    context 'with auth header' do
      let(:headers) { {'Authorization' => "Bearer #{token_value}"} }
      let(:params) {}

      it 'should extract the token value from the header' do
        expect(access_token).to eq(token_value)
      end
    end

    context 'with auth param' do
      let(:params) { {'access_token' => token_value} }
      let(:headers) {}

      it 'should extract the token value from the access_token parameter' do
        expect(access_token).to eq(token_value)
      end
    end
  end

  describe '#validate_token!' do
    subject(:validate_token!) { validator.validate_token! }

    context 'when token is valid' do
      include_context 'valid access token'

      it 'should initialize the auth client with the access token' do
        validator.auth_client
        expect(G5AuthenticationClient::Client).to have_received(:new).with(access_token: token_value)
      end

      it 'should not raise errors during validation' do
        expect { validate_token! }.to_not raise_error
      end
    end

    context 'when token is invalid' do
      include_context 'invalid access token'

      it 'should initialize the auth client with the access token' do
        validator.auth_client
        expect(G5AuthenticationClient::Client).to have_received(:new).with(access_token: token_value)
      end

      it 'should re-raise the OAuth error' do
        expect { validate_token! }.to raise_error(OAuth2::Error)
      end
    end

    context 'when there is no token' do
      let(:params) {}
      let(:headers) {}

      it 'should raise an error' do
        expect { validate_token! }.to raise_error
      end
    end
  end

  describe '#valid?' do
    subject(:valid?) { validator.valid? }

    context 'when token is valid' do
      include_context 'valid access token'

      it 'should be valid' do
        expect(validator).to be_valid
      end
    end

    context 'when token is invalid' do
      include_context 'invalid access token'

      it 'should not be valid' do
        expect(validator).to_not be_valid
      end
    end

    context 'without token' do
      let(:params) {}
      let(:headers) {}

      it 'should not be valid' do
        expect(validator).to_not be_valid
      end
    end
  end
end
