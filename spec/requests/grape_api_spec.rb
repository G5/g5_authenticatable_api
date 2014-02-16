require 'spec_helper'

describe 'a Grape API endpoint' do
  subject(:api_call) { get '/grape_api/hello' }

  it 'is accessible without authentication' do
    api_call
    expect(response).to be_success
  end
end
