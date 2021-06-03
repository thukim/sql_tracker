require 'active_support/configurable'

module SqlTracker
  class Config
    include ActiveSupport::Configurable
    config_accessor :tracked_paths, :tracked_sql_command, :output_path, :enabled,
                    :sql_value

    class << self
      def apply_defaults
        self.enabled = enabled.nil? ? true : enabled
        self.sql_value = 'xxx'.freeze
        self.tracked_paths ||= %w(app lib).freeze
        self.tracked_sql_command ||= %w(SELECT INSERT UPDATE DELETE).freeze
        self.output_path ||= begin
          if defined?(::Rails) && ::Rails.root
            File.join(::Rails.root.to_s, 'tmp'.freeze)
          else
            'tmp'.freeze
          end
        end
        self
      end
    end
  end
end
