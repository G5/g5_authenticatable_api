require 'oauth2'

module G5AuthenticatableApi
  module Services
    class AuthClient

      attr_writer *G5AuthenticatableApi::VALID_CONFIG_OPTIONS

      G5AuthenticatableApi::VALID_CONFIG_OPTIONS.each do |opt|
        define_method(opt) { get_value(opt) }
      end

      def debug?
        self.debug.to_s == 'true'
      end

      def initialize(options={})
        options.each { |k,v| self.send("#{k}=", v) if self.respond_to?("#{k}=") }
      end

      def allow_password_credentials?
        allow_password_credentials=='true'
      end

      def get_access_token
        oauth_access_token.token
      end

      def get_value(attribute)
        instance_variable_get("@#{attribute}") || G5AuthenticatableApi.send(attribute)
      end

      def username_pw_access_token
        raise_if_blank('username')
        raise_if_blank('password')
        raise 'allow_password_credentials must be enabled for username/pw access' unless allow_password_credentials?
        oauth_client.password.get_token(username, password)
      end

      private

      def raise_if_blank(client_attribute)
        attr = send(client_attribute)
        if attr.nil? || attr.strip == ''
          raise G5AuthenticatableApi::Error.
              new("#{client_attribute} is blank, provide a #{client_attribute} by setting it in the client instance or adding a G5_AUTH_#{client_attribute.upcase} env variable.")
        end
      end

      def oauth_client
        OAuth2::Client.new(client_id, client_secret, site: endpoint)
      end

      def oauth_access_token
        @oauth_access_token ||= if access_token
                                  OAuth2::AccessToken.new(oauth_client, access_token)
                                elsif authorization_code
                                  oauth_client.auth_code.get_token(authorization_code, redirect_uri: redirect_uri)
                                elsif allow_password_credentials?
                                  username_pw_access_token
                                else
                                  raise "Insufficient credentials for access token.  Supply a username/password or authentication code"
                                end
      end

    end
  end
end
