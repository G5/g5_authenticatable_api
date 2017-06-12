# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'A Secure Rails API endpoint' do
  let(:params) {}
  let(:headers) {}

  describe 'GET request' do
    subject(:api_call) do
      get '/rails_api/articles', *build_request_options(params, headers)
    end

    it_should_behave_like 'a warden authenticatable api'
    it_should_behave_like 'a token authenticatable api'
  end
end
