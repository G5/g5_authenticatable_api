# frozen_string_literal: true

# Support migration version syntax in rails 4
ActiveSupport.on_load(:active_record) do
  unless ActiveRecord::Migration.respond_to?(:[])
    ActiveRecord::Migration.define_singleton_method(:[]) do |version|
      self if version.to_s.starts_with?('4')
    end
  end
end
