require 'spec_helper'

describe 'a secure Grape API endpoint' do
  subject(:api_call) { get '/grape_api/hello' }

  context 'with valid access token' do
    it 'should be accessible' do
      api_call
      expect(response).to be_http_ok
    end
  end

  context 'with invalid access token' do
    it 'should be unauthorized' do
      api_call
      expect(response).to be_http_unauthorized
    end
  end

  context 'without authentication' do
    it 'should be unauthorized' do
      api_call
      expect(response).to be_http_unauthorized
    end
  end
end
