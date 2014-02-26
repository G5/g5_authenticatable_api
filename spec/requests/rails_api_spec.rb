require 'spec_helper'

describe 'A Secure Rails API endpoint' do
  let(:params) {}
  let(:headers) {}

  describe 'GET request' do
    subject(:api_call) { get '/rails_api/articles', params, headers }

    it_should_behave_like 'a warden authenticatable api'
    it_should_behave_like 'a token authenticatable api'
  end
end
