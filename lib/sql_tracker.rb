require 'sql_tracker/config'
require 'sql_tracker/handler'
require 'sql_tracker/report'

module SqlTracker
  def self.initialize!
    raise 'sql tracker initialized twice' if @already_initialized

    config = SqlTracker::Config.apply_defaults
    handler = SqlTracker::Handler.new(config)
    handler.subscribe
    @already_initialized = true

    at_exit { handler.save }
  end

  def self.track(sql_value: 'xxx')
    config = SqlTracker::Config.apply_defaults.new
    config.enabled = true
    config.sql_value = sql_value
    handler = SqlTracker::Handler.new(config)
    handler.subscribe
    yield
    handler.unsubscribe
    handler.data
  end

  def self.output_csv(csv_delimiter: '|', sql_value: '?', trace_level: 1)
    config = SqlTracker::Config.apply_defaults.new
    config.enabled = true
    config.sql_value = sql_value
    config.trace_level = trace_level
    handler = SqlTracker::Handler.new(config)
    handler.subscribe
    yield
    handler.unsubscribe
    handler.print_csv(csv_delimiter: csv_delimiter)
  end
end

if defined?(::Rails) && ::Rails::VERSION::MAJOR.to_i >= 3
  require 'sql_tracker/railtie'
end
