# frozen_string_literal: true

require 'rails_helper'

RSpec.describe G5AuthenticatableApi::Services::TokenValidator do
  subject { validator }

  let(:validator) { described_class.new(params, headers, warden) }

  let(:headers) {}
  let(:params) { { 'access_token' => token_value } }
  let(:token_value) { 'abc123' }
  let(:warden) {}

  describe '#validate!' do
    subject(:validate!) { validator.validate! }

    context 'when token is on the request' do
      context 'when token is valid' do
        include_context 'valid access token'

        it 'should initialize the auth client with the access token' do
          validate!
          expect(a_request(:get, 'auth.g5search.com/oauth/token/info')
            .with(headers: { 'Authorization' => "Bearer #{token_value}" }))
            .to have_been_made
        end

        it 'should not raise errors during validation' do
          expect { validate! }.to_not raise_error
        end

        it 'should not set an error on the validator' do
          validate!
          expect(validator.error).to be_nil
        end
      end

      context 'when token is invalid' do
        include_context 'invalid access token'

        it 'should re-raise the OAuth error' do
          expect { validate! }.to raise_error(OAuth2::Error)
        end

        it 'should set the error on the validator' do
          begin
            validate!
          rescue StandardError => validation_error
            expect(validator.error).to eq(validation_error)
          end
        end
      end
    end

    context 'when token is on the warden user' do
      let(:warden) { double(:warden, user: user) }
      let(:user) do
        FactoryGirl.build_stubbed(:user, g5_access_token: token_value)
      end
      let(:params) {}
      let(:headers) {}

      context 'when strict token validation is enabled' do
        before { G5AuthenticatableApi.strict_token_validation = true }

        context 'when the token is valid' do
          include_context 'valid access token'

          it 'should validate the access token against the auth server' do
            validate!
            expect(a_request(:get, 'auth.g5search.com/oauth/token/info')
              .with(headers: { 'Authorization' => "Bearer #{token_value}" }))
              .to have_been_made
          end

          it 'should not raise errors during validation' do
            expect { validate! }.to_not raise_error
          end
        end

        context 'when token is invalid' do
          include_context 'invalid access token'

          it 'should re-raise the error' do
            expect { validate! }.to raise_error(OAuth2::Error)
          end
        end
      end

      context 'when strict token validation is disabled' do
        before { G5AuthenticatableApi.strict_token_validation = false }

        it 'should not validate the access token against the auth server' do
          validate!
          expect(a_request(:get, 'authg5search.com/oauth/token/info'))
            .to_not have_been_made
        end

        it 'should not raise errors during validation' do
          expect { validate! }.to_not raise_error
        end
      end
    end

    context 'when there is no token' do
      let(:params) {}
      let(:headers) {}

      it 'should raise an error' do
        expect { validate! }.to raise_error(RuntimeError)
      end

      it 'should set an error on the validator' do
        begin
          validate!
        rescue RuntimeError => validation_error
          expect(validator.error).to eq(validation_error)
        end
      end
    end
  end

  describe '#valid?' do
    subject(:valid?) { validator.valid? }

    context 'when token is valid' do
      include_context 'valid access token'

      it 'should be valid' do
        expect(validator).to be_valid
      end

      it 'should not set an error on the validator' do
        valid?
        expect(validator.error).to be_nil
      end
    end

    context 'when token is invalid' do
      include_context 'invalid access token'

      it 'should not be valid' do
        expect(validator).to_not be_valid
      end

      it 'should set an error on the validator' do
        expect { valid? }.to change { validator.error }
          .from(nil).to(an_instance_of(OAuth2::Error))
      end
    end

    context 'without token' do
      let(:params) {}
      let(:headers) {}

      it 'should not be valid' do
        expect(validator).to_not be_valid
      end

      it 'should set an error on the validator' do
        expect { valid? }.to change { validator.error }
          .from(nil).to(an_instance_of(RuntimeError))
      end
    end
  end

  describe '#auth_response_header' do
    subject(:auth_response_header) { validator.auth_response_header }

    let(:header_parts) { auth_response_header.match(auth_header_regex) }

    context 'with invalid token error' do
      include_context 'invalid access token'
      before { validator.valid? }

      let(:auth_header_regex) do
        /Bearer error="(?<error>.+)",error_description="(?<error_description>.*)"/
      end

      it 'should be in the expected format' do
        expect(auth_response_header).to match(auth_header_regex)
      end

      it 'should have the correct error code' do
        expect(header_parts['error']).to eq(error_code)
      end

      it 'should have the correct error description' do
        expect(header_parts['error_description']).to eq(error_description)
      end
    end

    context 'with generic auth server error' do
      include_context 'OAuth2 error'
      before { validator.valid? }

      let(:auth_header_regex) do
        /Bearer error="(?<error>.+)"/
      end

      it 'should be in the expected format' do
        expect(auth_response_header).to match(auth_header_regex)
      end

      it 'should have the default error code' do
        expect(header_parts['error']).to eq('invalid_request')
      end

      it 'should not have an error description' do
        expect(auth_response_header).to_not match(/error_description/)
      end
    end

    context 'without token' do
      let(:params) {}
      let(:headers) {}
      before { validator.valid? }

      it 'should not include any error data' do
        expect(auth_response_header).to eq('Bearer')
      end
    end

    context 'with valid token' do
      include_context 'valid access token'
      before { validator.valid? }

      it 'should be nil' do
        expect(auth_response_header).to be_nil
      end
    end
  end
end
