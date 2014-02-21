shared_examples_for 'token validation' do
  let(:g5_auth_client) { double(:g5_authentication_client) }
  before do
    allow(G5AuthenticationClient::Client).to receive(:new).and_return(g5_auth_client)
  end

  context 'when token is valid' do
    let(:auth_user) { double(:auth_user, email: 'auth.user@test.host',
                                         id: 'user-uid-42') }
    before { allow(g5_auth_client).to receive(:me).and_return(auth_user) }


    let(:token_info) { double(:token_info, resource_owner_id: 'user-uid-42',
                                           expires_in_seconds: 3600,
                                           application_uid: 'application-uid-42',
                                           scopes: []) }
    before { allow(g5_auth_client).to receive(:token_info).and_return(token_info) }

    before { subject }

    it 'should be successful' do
      expect(response).to be_success
    end
  end

  context 'when token is invalid' do
    let(:oauth_error) { OAuth2::Error.new(oauth_response) }
    let(:oauth_response) do
      double(:oauth_response,
             parsed: {'error' => error_code,
                      'error_description' => error_description}).as_null_object
    end

    let(:error_code) { 'invalid_token' }
    let(:error_description) { 'The access token expired' }

    before do
      allow(g5_auth_client).to receive(:me).and_raise(oauth_error)
      allow(g5_auth_client).to receive(:token_info).and_raise(oauth_error)
    end

    before { subject }

    it 'should be unauthorized' do
      expect(response).to be_http_unauthorized
    end

    it 'should return an authenticate header' do
      expect(response.headers).to have_key('WWW-Authenticate')
    end

    it 'should return the authentication error' do
      expect(response.headers['WWW-Authenticate']).to match("error=\"#{error_code}\"")
    end

    it 'should return the authentication error description' do
      expect(response.headers['WWW-Authenticate']).to match("error_description=\"#{error_description}\"")
    end
  end

  context 'when some other oauth error occurs' do
    let(:oauth_error) { OAuth2::Error.new(oauth_response) }
    let(:oauth_response) { double(:oauth_response, parsed: '').as_null_object }

    before do
      allow(g5_auth_client).to receive(:me).and_raise(oauth_error)
      allow(g5_auth_client).to receive(:token_info).and_raise(oauth_error)
    end

    before { subject }

    it 'should be unauthorized' do
      expect(response).to be_http_unauthorized
    end

    it 'should return an authenticate header' do
      expect(response.headers).to have_key('WWW-Authenticate')
    end

    it 'should return the default authentication error code' do
      expect(response.headers['WWW-Authenticate']).to match('error="invalid_request"')
    end
  end
end

shared_examples_for 'a token authenticatable api' do
  let(:access_token) { 'abc123' }

  context 'with authorization header' do
    let(:headers) { {'Authorization' => "Bearer #{access_token}"} }

    include_examples 'token validation'
  end

  context 'with access token parameter' do
    let(:params) { {'access_token' => access_token} }

    include_examples 'token validation'
  end

  context 'without authentication information' do
    before { subject }

    it 'should be unauthorized' do
      expect(response).to be_http_unauthorized
    end

    it 'should return an authenticate header without details' do
      expect(response.headers).to include('WWW-Authenticate' => 'Bearer')
    end
  end
end
