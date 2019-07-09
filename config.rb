# frozen_string_literal: true

# ConfigFileException - exception class for configuration file
class ConfigFileException < StandardError
  def initialize(msg)
    super
  end
end

# BTestConfigFile - class to handle configuration
class BTestConfig
  def self.config_file(msg, default_file = '')
    config_file = default_file if File.exist?(default_file)

    if ARGV.length >= 1
      config_file = ARGV[0] if File.exist?(ARGV[0])
    end

    raise ConfigFileException, msg if config_file.nil?

    config_file
  end
end
