# frozen_string_literal: true

require 'rails_helper'

RSpec.describe G5AuthenticatableApi::Services::UserFetcher do
  subject(:user_fetcher) { described_class.new(params, headers, warden) }
  let(:params) { { 'access_token' => token_value } }
  let(:token_value) { 'abc123' }
  let(:headers) {}
  let(:warden) {}

  describe '#current_user' do
    include_context 'current auth user'

    subject(:current_user) { user_fetcher.current_user }

    context 'when there is no warden user' do
      it_behaves_like 'an auth user' do
        let(:user) { current_user }
      end
    end

    context 'when there is a warden user' do
      let(:warden) { double(:warden, user: warden_user) }

      context 'when the access_token is for the warden user' do
        let(:warden_user) { double(:user, g5_access_token: token_value) }

        it 'returns the warden user' do
          expect(current_user).to eq(warden_user)
        end
      end

      context 'when the access token is for a different user' do
        let(:warden_user) { double(:user, g5_access_token: "#{token_value}42") }

        it_behaves_like 'an auth user' do
          let(:user) { current_user }
        end
      end
    end
  end
end
