# frozen_string_literal: true

require 'g5_authenticatable_api/helpers/rails'

module G5AuthenticatableApi
  # Hook into the rails app initialization
  class Railtie < Rails::Railtie
    initializer 'g5_authenticatable.helpers' do
      ActiveSupport.on_load(:action_controller) do
        include G5AuthenticatableApi::Helpers::Rails
      end
    end
  end
end
