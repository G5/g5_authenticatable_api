# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'a secure Grape API endpoint' do
  let(:endpoint) { '/grape_api/hello' }
  let(:params) {}
  let(:headers) {}

  describe 'GET request' do
    subject(:api_call) { get endpoint, params, headers }

    it_should_behave_like 'a warden authenticatable api'
    it_should_behave_like 'a token authenticatable api'
  end

  describe 'POST request' do
    subject(:api_call) { post endpoint, params, headers }

    it_should_behave_like 'a warden authenticatable api'
    it_should_behave_like 'a token authenticatable api'
  end
end
