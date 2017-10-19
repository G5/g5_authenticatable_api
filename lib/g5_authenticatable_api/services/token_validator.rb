# frozen_string_literal: true

require 'g5_authenticatable_api/services/token_info'

module G5AuthenticatableApi
  module Services
    # Validates an access token against the G5 Auth server
    class TokenValidator < TokenInfo
      attr_reader :error

      def validate!
        token_data unless skip_validation?
      rescue StandardError => @error
        raise error
      end

      def valid?
        validate!
        true
      rescue StandardError
        false
      end

      def auth_response_header
        return unless error

        auth_header = String.new('Bearer')

        if access_token
          auth_header << " error=\"#{error_code}\""

          if error_description.present?
            auth_header << ",error_description=\"#{error_description}\""
          end
        end

        auth_header
      end

      private

      def error_code
        error_code = error.code if error.respond_to?(:code)
        error_code || 'invalid_request'
      end

      def error_description
        return unless error.respond_to?(:description)
        error.description
      end

      def skip_validation?
        @warden.try(:user) && !G5AuthenticatableApi.strict_token_validation
      end
    end
  end
end
