# frozen_string_literal: true

RSpec.shared_examples_for 'a token authenticatable api' do
  let(:token_value) { 'abc123' }

  context 'with authorization header' do
    let(:headers) { { 'Authorization' => "Bearer #{token_value}" } }

    include_examples 'token validation'
  end

  context 'with access token parameter' do
    let(:params) { { 'access_token' => token_value } }

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

  context 'with environment variables for password credentials' do
    before do
      ENV['G5_AUTH_USERNAME'] = 'my.user@test.host'
      ENV['G5_AUTH_PASSWORD'] = 'my_secret'
    end

    after do
      ENV['G5_AUTH_USERNAME'] = nil
      ENV['G5_AUTH_PASSWORD'] = nil
    end

    before { subject }

    it 'should be unauthorized' do
      expect(response).to be_http_unauthorized
    end

    it 'should return an authenticate header without details' do
      expect(response.headers).to include('WWW-Authenticate' => 'Bearer')
    end
  end
end
