require 'spec_helper'

describe G5AuthenticatableApi::TokenValidator do
  subject { validator }

  let(:validator) { described_class.new(params, headers) }

  let(:headers) {}
  let(:params) {}

  let(:access_token) { 'abc123' }

  context 'with Authorization header' do
    let(:headers) { {'Authorization' => "Bearer #{access_token}"} }

    context 'when token is valid' do
      include_context 'valid access token'

      its(:access_token) { should == access_token }

      it 'should initialize the auth client with the access token' do
        validator.auth_client
        expect(G5AuthenticationClient::Client).to have_received(:new).with(access_token: access_token)
      end

      it 'should not raise errors during validation' do
        expect { validator.validate_token! }.to_not raise_error
      end

      it 'should be valid' do
        expect(validator).to be_valid
      end
    end

    context 'when token is invalid' do
      include_context 'invalid access token'

      it 'should re-raise the OAuth error' do
        expect { validator.validate_token! }.to raise_error(OAuth2::Error)
      end

      it 'should be invalid' do
        expect(validator).to_not be_valid
      end
    end
  end

  context 'with access_token parameter' do
    let(:params) { {'access_token' => access_token} }

    include_context 'valid access token'

    its(:access_token) { should == access_token }

    it 'should initialize the auth client with the access token' do
      validator.auth_client
      expect(G5AuthenticationClient::Client).to have_received(:new).with(access_token: access_token)
    end

    it 'should not raise errors during validation' do
      expect { validator.validate_token! }.to_not raise_error
    end

    it 'should be valid' do
      expect(validator).to be_valid
    end
  end

  context 'without token' do
    it 'should raise an error during validation' do
      expect { validator.validate_token! }.to raise_error
    end

    it 'should not be valid' do
      expect(validator).to_not be_valid
    end
  end
end
