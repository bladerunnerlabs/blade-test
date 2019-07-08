#!/usr/bin/ruby
# frozen_string_literal: true

require 'yaml'
require 'colorize'

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

class TestStepException < StandardError
  def initialize(msg = 'Test step failed')
    super
  end
end

# BladeTest - test framework implementation
class BladeTest
  BTEST_VERSION = '0.1'
  BTEST_DEFAULT_CFG_FILE = '.btest.yaml'
  BTEST_DEFAULT_CONFIG = { "Name" => "Test name not provided",
                            "Description" => "do something unknown"
                          }

  def self.config_file
    config_file = BTEST_DEFAULT_CFG_FILE if File.exist?(BTEST_DEFAULT_CFG_FILE)

    if ARGV.length >= 1
      config_file = ARGV[0] if File.exist?(ARGV[0])
    end

    raise ConfigFileException if config_file.nil?

    config_file
  end

  def initialize(config_file)
    @config_file = config_file
    @config = BTEST_DEFAULT_CONFIG.merge(YAML.load_file(@config_file))
    @result = true
  end

  def run
    dump_config
    print_welcome_and_info
    run_flow
  end

private

  def print_description
    test_name = @config['Name']
    test_description = @config['Description']
    puts 'Running test ' + test_name.yellow
    puts 'The test will ' + test_description
    puts
  end

  def print_result(result)
    if result == true
      puts 'PASS'.green
    else
      puts 'FAIL'.red
    end
  end

  def dump_config
    puts "Current configuration from #{@config_file}:"
    puts @config.to_s.yellow
    puts
  end

  def print_welcome_and_info
    puts "Blade test v#{BTEST_VERSION}\n\n"
    print_description
  end

  def print_final_result
    puts 'Final result:'
    print_result(@result)
    puts "\n\n"
  end

  def run_execution(stage, commands)
    stage_result = true

    begin
      puts 'Running ' + stage.yellow
    rescue
      stage_result = false
    end

    print_result(stage_result)
    stage_result
  end

  def run_step(step_config)
    step_name = step_config.keys.first
    times = step_config[step_config.keys.first]["Times"]
    execution_list = step_config[step_config.keys.first]["Execute"]

    times = 1 if times.nil?
    puts "Running #{step_name} step #{times} times..."
    times.times {run_execution(step_name, execution_list)}
  end

  def run_flow
    begin
      test_steps = @config['TestSteps']
      test_steps.each { |step| run_step(step) }
    rescue TestStepException => e
      @result = false
    end

    print_final_result
  end
end

begin
  test = BladeTest.new(BladeTest.config_file)
  test.run
rescue ConfigFileException => e
  puts e.to_s.red
end
