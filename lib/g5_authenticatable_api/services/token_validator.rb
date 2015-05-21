require 'g5_authenticatable_api/services/token_info'

module G5AuthenticatableApi
  module Services
    class TokenValidator < TokenInfo
      attr_reader :error

      def validate!
        begin
          token_data unless skip_validation?
        rescue StandardError => @error
          raise error
        end
      end

      def valid?
        begin
          validate!
          true
        rescue StandardError => e
          false
        end
      end

      def auth_response_header
        if error
          auth_header = "Bearer"

          if access_token
            auth_header << " error=\"#{error_code}\""
            auth_header << ",error_description=\"#{error_description}\"" if error_description
          end

          auth_header
        end
      end

      private
      def error_code
        error_code = error.code if error.respond_to?(:code)
        error_code || 'invalid_request'
      end

      def error_description
        error_description = error.description if error.respond_to?(:description)
        error_description
      end

      def skip_validation?
        @warden.try(:user) && !G5AuthenticatableApi.strict_token_validation
      end
    end
  end
end
