# frozen_string_literal: true

require 'spec_helper'
require 'g5_authenticatable_api/services/auth_client'
require 'json'

RSpec.describe G5AuthenticatableApi::Services::AuthClient do

  subject(:client) { described_class.new(options) }

  after { G5AuthenticatableApi.reset }

  let(:debug) { true }
  let(:logger) { double() }
  let(:username) {'username'}
  let(:password) {'password'}
  let(:client_id) {'client id'}
  let(:client_secret) {'client secret'}
  let(:redirect_uri) {'/stuff'}
  let(:endpoint){ 'http://endpoint.com' }
  let(:authorization_code){ 'code' }
  let(:allow_password_credentials){ 'false' }

  let(:options) { default_options }
  let(:default_options) do
    {
        debug: debug,
        logger: logger,
        endpoint: endpoint,
        username: username,
        password: password,
        client_id: client_id,
        client_secret: client_secret,
        redirect_uri: redirect_uri,
        authorization_code: authorization_code,
        access_token: access_token,
        allow_password_credentials: allow_password_credentials
    }
  end

  let(:access_token) { access_token_value }
  let(:access_token_value) { 'test_token' }
  let(:token_type) { 'Bearer' }

  context 'with default configuration' do
    subject(:client) { described_class.new }

    it 'should not be debug' do
      expect(client.debug?).to_not be true
    end

    it 'should have a logger' do
      expect(client.logger).to be_an_instance_of(Logger)
    end

    it 'should not have a user name' do
      expect(client.username).to be_nil
    end

    it 'should not have a password' do
      expect(client.password).to be_nil
    end

    it 'should have default client id' do
      expect(client.client_id).to eq(G5AuthenticatableApi::DEFAULT_CLIENT_ID)
    end

    it 'should have default client secret' do
      expect(client.client_secret).to eq(G5AuthenticatableApi::DEFAULT_CLIENT_SECRET)
    end

    it 'should have default redirect uri' do
      expect(client.redirect_uri).to eq(G5AuthenticatableApi::DEFAULT_REDIRECT_URI)
    end

    it 'should have default endpoint' do

      expect(client.endpoint).to eq(G5AuthenticatableApi::DEFAULT_ENDPOINT)
    end

    it 'should have nil authorization code' do
      expect(client.authorization_code).to be_nil
    end

    it 'should have nil access token' do
      expect(client.access_token).to be_nil
    end

    it 'should have default allow_password_credentials' do
      expect(client.allow_password_credentials).to eq('true')
    end

  end

  context 'with non-default configuration' do

    it 'should have debug' do
      expect(client.debug).to be true
    end

    describe '#debug=' do
      subject { client.debug = new_debug }

      context 'with nil debug' do
        let(:new_debug) { nil }

        context 'when there is a debug flag configured at the top-level module' do
          let(:configured_debug) { 'true' }
          before { G5AuthenticatableApi.configure { |config| config.debug = configured_debug } }

          it 'should set the debug flag according to the configuration' do
            expect { subject }.to_not change { client.debug? }
          end
        end

        context 'when there is no debug flag configured at the top level' do
          it 'should set the debug flag to the default' do
            expect { subject }.to change { client.debug? }.to(false)
          end
        end
      end

      context 'with new setting' do
        let(:new_debug) { 'false' }

        it 'should change the value of the debug flag to match the new value' do
          expect { subject }.to change { client.debug? }.from(true).to(false)
        end
      end
    end

    describe '#logger=' do
      subject { client.logger = new_logger }

      context 'with nil logger' do
        let(:new_logger) { nil }

        context 'when there is a logger configured at the top-level module' do
          let(:configured_logger) { double() }
          before { G5AuthenticatableApi.configure { |config| config.logger = configured_logger } }

          it 'should change the value of the logger to match the configuration' do
            expect { subject }.to change { client.logger }.from(logger).to(configured_logger)
          end
        end

        context 'when there is no logger configured at the top level' do
          it 'should change the value of the logger to the default' do
            expect { subject }.to change { client.logger }
            expect(client.logger).to be_an_instance_of(Logger)
          end
        end
      end

      context 'with new logger' do
        let(:new_logger) { double() }

        it 'should change the value of the logger to match the new value' do
          expect { subject }.to change { client.logger }.from(logger).to(new_logger)
        end
      end
    end

    it 'should have username' do
      expect(client.username).to eq(username)
    end

    it_should_behave_like 'a module configured attribute',:username, nil

    it 'should have password' do
      expect(client.password).to eq(password)
    end

    it_should_behave_like 'a module configured attribute', :password, nil

    it 'should have endpoint' do
      expect(client.endpoint).to eq(endpoint)
    end

    it_should_behave_like 'a module configured attribute', :endpoint, G5AuthenticatableApi::DEFAULT_ENDPOINT

    it 'should have client_id' do
      expect(client.client_id).to eq(client_id)
    end

    it_should_behave_like 'a module configured attribute', :client_id, G5AuthenticatableApi::DEFAULT_CLIENT_ID

    it 'should have client_secret' do
      expect(client.client_secret).to eq(client_secret)
    end

    it_should_behave_like 'a module configured attribute', :client_secret, G5AuthenticatableApi::DEFAULT_CLIENT_SECRET

    it 'should have redirect_uri' do
      expect(client.redirect_uri).to eq(redirect_uri)
    end

    it_should_behave_like 'a module configured attribute', :redirect_uri, G5AuthenticatableApi::DEFAULT_REDIRECT_URI

    it 'should have authorization_code' do
      expect(client.authorization_code).to eq(authorization_code)
    end

    it_should_behave_like 'a module configured attribute', :authorization_code, nil

    it 'should have access_token' do
      expect(client.access_token).to eq(access_token)
    end

    it_should_behave_like 'a module configured attribute', :access_token, nil

    it 'should have allow_password_credentials' do
      expect(client.allow_password_credentials).to eq(allow_password_credentials)
    end

    it_should_behave_like 'a module configured attribute', :allow_password_credentials, 'true'

  end

  describe '#allow_password_credentials??' do
    subject{ client.allow_password_credentials? }

    context 'when the allow_password_credentials is set to true' do
      let(:allow_password_credentials) {'true'}
      it { is_expected.to be true }
    end

    context 'when the allow_password_credentials is set to false' do
      let(:allow_password_credentials) {'false'}
      it { is_expected.to be false }
    end
  end

  describe '#get_access_token' do
    subject(:get_access_token) { client.get_access_token }

    it "should return the access token" do
      expect(subject).to eq(access_token)
    end
  end

  describe '#username_pw_access_token' do
    let(:token) {'asdf'}
    before do
      oauth_client = double(OAuth2::AccessToken, password: double(:pw, get_token: token))
      allow(client).to receive(:oauth_client).and_return(oauth_client)
      client.allow_password_credentials = 'true'
    end

    context 'allow_password_credentials is `true`' do
      it 'delegates token retrieval to oauth_client' do
        expect(client.username_pw_access_token).to eq(token)
      end
    end

    context 'username is blank' do
      let(:options) { default_options.merge(username: " ") }
      it 'raises an error' do
        expect { client.username_pw_access_token }.to raise_error(G5AuthenticatableApi::Error, 'username is blank, provide a username by setting it in the client instance or adding a G5_AUTH_USERNAME env variable.')
      end
    end

    context 'password is blank' do
      let(:options) { default_options.merge(password: " ") }
      it 'raises an error' do
        expect { client.username_pw_access_token }.to raise_error(G5AuthenticatableApi::Error, 'password is blank, provide a password by setting it in the client instance or adding a G5_AUTH_PASSWORD env variable.')
      end
    end
  end

end
