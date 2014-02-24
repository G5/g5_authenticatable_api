require 'spec_helper'

describe G5AuthenticatableApi::TokenValidator do
  let(:validator) { described_class.new(access_token) }
  let(:access_token) { 'abc123' }

  context 'with valid token' do
    include_context 'valid access token'

    it 'should be valid' do
      expect { validator.validate_token! }.to_not raise_error
    end
  end

  context 'with invalid token' do
    include_context 'invalid access token'

    it 'should not be valid' do
      expect { validator.validate_token! }.to raise_error
    end
  end
end
