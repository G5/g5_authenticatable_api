require 'spec_helper'

shared_examples_for 'a warden authenticatable api' do
  context 'when user is authenticated' do
    let(:user) { create(:user) }

    before do
      stub_g5_omniauth(user)
      get '/users/sign_in'
      subject
    end

    it 'should be successful' do
      expect(response).to be_success
    end
  end

  context 'when user is not authenticated' do
    before { subject }

    it 'should be unauthorized' do
      expect(response).to be_http_unauthorized
    end

    it 'should return an authenticate header without details' do
      expect(response.headers).to include('WWW-Authenticate' => 'Bearer')
    end
  end
end
