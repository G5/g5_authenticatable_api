
shared_examples_for 'token validation' do
  context 'when token is valid' do
    # TODO: stub g5 auth interaction

    before { subject }

    it 'should be successful' do
      expect(response).to be_success
    end
  end

  context 'when token is invalid' do
    # TODO: stub g5 auth interaction

    before { subject }

    it 'should be unauthorized' do
      expect(response).to be_http_unauthorized
    end

    it 'should return an authenticate header' do
      expect(response.headers).to have_key('WWW-Authenticate')
    end

    it 'should return the authentication error' do
      expect(response.headers['WWW-Authenticate']).to match('error="invalid_token"')
    end

    it 'should return the authentication error description' do
      expect(response.headers['WWW-Authenticate']).to match('error_description="The access token has expired"')
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
