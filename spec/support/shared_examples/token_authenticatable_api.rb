
shared_examples_for 'token validation' do
  context 'when token is valid' do
    # TODO: stub g5 auth interaction

    before { subject }

    it 'should be successful' do
      expect(response).to be_success
    end

    it 'should have the correct authenticate header'
  end

  context 'when token is invalid' do
    # TODO: stub g5 auth interaction

    before { subject }

    it 'should be unauthorized' do
      expect(response).to be_http_unauthorized
    end

    it 'should have the correct authenticate header'
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
end
