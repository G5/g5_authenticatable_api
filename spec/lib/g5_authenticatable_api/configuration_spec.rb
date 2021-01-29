# frozen_string_literal: true

require 'spec_helper'

RSpec.describe G5AuthenticatableApi::Configuration do

  subject(:test_module) do
    module TestModule
      extend G5AuthenticatableApi::Configuration
    end
  end

  let(:logger) { double }
  let(:username) {'username'}
  let(:password) {'password'}
  let(:client_id) {'client id'}
  let(:client_secret) {'client secret'}
  let(:redirect_uri) {'/stuff'}
  let(:endpoint){ 'http://endpoint.com' }
  let(:authorization_code){ 'code' }
  let(:access_token) { 'access_token_test' }
  let(:allow_password_credentials) { 'false' }
  let(:first_name) { 'Joe' }
  let(:last_name) { 'Person' }
  let(:organization_name) { 'Things, Inc.' }
  let(:phone_number) { '8675309123' }
  let(:title) { 'Developer' }

  after { test_module.reset }

  it 'should respond to configure' do
    expect(test_module).to respond_to(:configure)
  end

  context 'with default configuration' do

    it 'should not be debug' do
      expect(test_module.debug?).to be false
    end

    it 'should have a logger' do
      expect(test_module.logger).to be_instance_of(Logger)
    end

    it 'should have nil username' do
      expect(test_module.username).to be_nil
    end

    it 'should have nil password' do
      expect(test_module.password).to be_nil
    end

    it 'should have default client id' do
      expect(test_module.client_id).to eq(G5AuthenticatableApi::DEFAULT_CLIENT_ID)
    end

    it 'should have default client_secret' do
      expect(test_module.client_secret).to eq(G5AuthenticatableApi::DEFAULT_CLIENT_SECRET)
    end

    it 'should have default redirect_uri' do
      expect(test_module.redirect_uri).to eq(G5AuthenticatableApi::DEFAULT_REDIRECT_URI)
    end

    it 'should have default endpoint' do
      expect(test_module.endpoint).to eq(G5AuthenticatableApi::DEFAULT_ENDPOINT)
    end

    it 'should have nil authorization_code' do
      expect(test_module.authorization_code).to be_nil
    end

    it 'should have nil access_token' do
      expect(test_module.access_token).to be_nil
    end

    it 'should allow password credentials' do
      expect(test_module.allow_password_credentials).to eq(G5AuthenticatableApi::DEFAULT_ALLOW_PASSWORD_CREDENTIALS)
    end
  end

  context 'with environment variable configuration' do
    before do
      ENV['G5_AUTH_CLIENT_ID'] = client_id
      ENV['G5_AUTH_CLIENT_SECRET'] = client_secret
      ENV['G5_AUTH_REDIRECT_URI'] = redirect_uri
      ENV['G5_AUTH_ENDPOINT'] = endpoint
      ENV['G5_AUTH_USERNAME'] = new_username
      ENV['G5_AUTH_ALLOW_PASSWORD_CREDENTIALS'] = new_allow_password_credentials
    end

    after do
      ENV['G5_AUTH_CLIENT_ID'] = nil
      ENV['G5_AUTH_CLIENT_SECRET'] = nil
      ENV['G5_AUTH_REDIRECT_URI'] = nil
      ENV['G5_AUTH_ENDPOINT'] = nil
    end

    let(:new_username) { 'foo' }

    let(:new_allow_password_credentials) { 'false' }

    it 'should not be debug' do
      expect(test_module.debug?).to be false
    end

    it 'should have a logger' do
      expect(test_module.logger).to be_instance_of(Logger)
    end

    it 'should have username' do
      expect(test_module.username).to eq(new_username)
    end

    it 'should have nil password' do
      expect(test_module.password).to be_nil
    end

    it 'should have default client id' do
      expect(test_module.client_id).to eq(client_id)
    end

    it 'should have default client_secret' do
      expect(test_module.client_secret).to eq(client_secret)
    end

    it 'should have default redirect_uri' do
      expect(test_module.redirect_uri).to eq(redirect_uri)
    end

    it 'should have default endpoint' do
      expect(test_module.endpoint).to eq(endpoint)
    end

    it 'should have nil authorization_code' do
      expect(test_module.authorization_code).to be_nil
    end

    it 'should have nil access_token' do
      expect(test_module.access_token).to be_nil
    end

    it 'should not allow password credentials' do
      expect(test_module.allow_password_credentials).to eq(new_allow_password_credentials)
    end

  end

  describe '.configure' do
    subject(:configure) { test_module.configure(&config_block) }

    context 'with full configuration' do
      let(:config_block) do
        lambda do |config|
          config.debug = true
          config.logger = logger
          config.username = username
          config.password = password
          config.client_id = client_id
          config.client_secret = client_secret
          config.redirect_uri = redirect_uri
          config.endpoint = endpoint
          config.authorization_code = authorization_code
          config.access_token = access_token
          config.allow_password_credentials = allow_password_credentials
        end
      end

      it 'should be debug' do
        expect(configure.debug?).to be true
      end

      it 'should have a logger' do
        expect(configure.logger).to eq(logger)
      end

      it 'should have username' do
        expect(configure.username).to eq(username)
      end

      it 'should have the correct password' do
        expect(configure.password).to eq(password)
      end

      it 'should have the correct client id' do
        expect(configure.client_id).to eq(client_id)
      end

      it 'should have the correct client_secret' do
        expect(configure.client_secret).to eq(client_secret)
      end

      it 'should have the correct redirect_uri' do
        expect(configure.redirect_uri).to eq(redirect_uri)
      end

      it 'should have the correct endpoint' do
        expect(configure.endpoint).to eq(endpoint)
      end

      it 'should have the correct authorization_code' do
        expect(configure.authorization_code).to eq(authorization_code)
      end

      it 'should have the correct access_token' do
        expect(configure.access_token).to eq(access_token)
      end

      it 'should have the correct value for allowing password credentials' do
        expect(configure.allow_password_credentials).to eq(allow_password_credentials)
      end
    end

    context 'with partial configuration' do
      let(:config_block) do
        lambda do |config|
          config.debug = new_debug
          config.username = new_username
          config.password = new_password
        end
      end

      let(:new_username) { 'foo' }
      let(:new_password) { 'bar' }
      let(:new_debug) { true }

      it 'should be debug' do
        expect(configure.debug?).to be new_debug
      end

      it 'should have a logger' do
        expect(configure.logger).to be_instance_of(Logger)
      end

      it 'should have username' do
        expect(configure.username).to eq(new_username)
      end

      it 'should have the correct password' do
        expect(configure.password).to eq(new_password)
      end

      it 'should have default client id' do
        expect(test_module.client_id).to eq(G5AuthenticatableApi::DEFAULT_CLIENT_ID)
      end

      it 'should have default client_secret' do
        expect(test_module.client_secret).to eq(G5AuthenticatableApi::DEFAULT_CLIENT_SECRET)
      end

      it 'should have default redirect_uri' do
        expect(test_module.redirect_uri).to eq(G5AuthenticatableApi::DEFAULT_REDIRECT_URI)
      end

      it 'should have default endpoint' do
        expect(test_module.endpoint).to eq(G5AuthenticatableApi::DEFAULT_ENDPOINT)
      end

      it 'should have nil authorization_code' do
        expect(configure.authorization_code).to be_nil
      end

      it 'should have nil access_token' do
        expect(configure.access_token).to be_nil
      end

      it 'should not allow password credentials' do
        expect(configure.allow_password_credentials).to eq(G5AuthenticatableApi::DEFAULT_ALLOW_PASSWORD_CREDENTIALS)
      end

      context 'when there is an env variable default' do

        let(:access_token_value) { 'test' }

        before do
          ENV['G5_AUTH_ACCESS_TOKEN']=access_token_value
        end

        after do
          ENV['G5_AUTH_ACCESS_TOKEN']=nil
        end

        it 'should have correct access_token' do
          expect(configure.access_token).to eq(access_token_value)
        end
      end
    end
  end

  it 'should reset' do
    expect(test_module).to respond_to(:reset)
  end

  describe '.reset' do
    before do
      test_module.configure do |config|
        config.debug = true
        config.logger = logger
        config.username = 'foo'
        config.password = 'bar'
        config.endpoint = 'blah'
        config.client_id = 'blah'
        config.client_secret = 'blah'
        config.redirect_uri = 'blah'
        config.authorization_code = 'blah'
        config.access_token = 'blah'
        config.allow_password_credentials = 'false'
      end
    end

    subject(:reset) { test_module.reset;test_module }

    it 'should not be debug' do
      expect(reset.debug?).to be false
    end

    it 'should have a logger' do
      expect(reset.logger).to be_instance_of(Logger)
    end

    it 'should have nil username' do
      expect(reset.username).to be_nil
    end

    it 'should have nil password' do
      expect(reset.password).to be_nil
    end

    it 'should have default client id' do
      expect(reset.client_id).to eq(G5AuthenticatableApi::DEFAULT_CLIENT_ID)
    end

    it 'should have default client_secret' do
      expect(reset.client_secret).to eq(G5AuthenticatableApi::DEFAULT_CLIENT_SECRET)
    end

    it 'should have default redirect_uri' do
      expect(reset.redirect_uri).to eq(G5AuthenticatableApi::DEFAULT_REDIRECT_URI)
    end

    it 'should have default endpoint' do
      expect(reset.endpoint).to eq(G5AuthenticatableApi::DEFAULT_ENDPOINT)
    end

    it 'should have nil authorization_code' do
      expect(reset.authorization_code).to be_nil
    end

    it 'should have nil access_token' do
      expect(reset.access_token).to be_nil
    end

    it 'should allow password credentials' do
      expect(reset.allow_password_credentials).to eq(G5AuthenticatableApi::DEFAULT_ALLOW_PASSWORD_CREDENTIALS)
    end
  end

  describe '.options' do
    before do
      test_module.configure do |config|
        config.debug = true
        config.logger = logger
        config.username = username
        config.password = password
        config.endpoint = endpoint
        config.client_id = client_id
        config.client_secret = client_secret
        config.redirect_uri = redirect_uri
        config.authorization_code = authorization_code
        config.access_token = access_token
        config.allow_password_credentials = allow_password_credentials
      end
    end

    subject(:options) { test_module.options }

    it 'should have correct options' do
      expect(options).to include(
                             debug: 'true',
                             username: username,
                             password: password,
                             endpoint: endpoint,
                             client_id: client_id,
                             client_secret: client_secret,
                             redirect_uri: redirect_uri,
                             authorization_code: authorization_code,
                             access_token: access_token,
                             allow_password_credentials: allow_password_credentials
                         )
    end
  end

end
