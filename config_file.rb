# frozen_string_literal: true

# ConfigFileException - exception class for configuration file
class ConfigFileException < StandardError
  CONFIG_FILE_ERROR = %(
    Configuration file not found.
    Please provide configuration file as a parameter to btest
    or create default configuration file ".btest.yaml".
  )
  def initialize(msg = CONFIG_FILE_ERROR)
    super
  end
end

# BTestConfigFile - class to handle config files
class BTestConfigFile
  def self.config_file(default_file)
    config_file = default_file if File.exist?(default_file)

    if ARGV.length >= 1
      config_file = ARGV[0] if File.exist?(ARGV[0])
    end

    raise ConfigFileException if config_file.nil?

    config_file
  end
end
