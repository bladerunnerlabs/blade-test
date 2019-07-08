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

# BladeTest - test framework implementation
class BladeTest
  BLADE_TEST_VERSION = '0.1'
  BTEST_DEFAULT_CFG_FILE = '.btest.yaml'

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
    @config = YAML.load_file(@config_file)
    @result = true
  end

  def run
    print_welcome_and_info
    dump_config
    run_flow
  end

  def print_description
    test_name = " tet name "# @config['Description']
    test_description = 'demonstrate how the test framework yaml files should '\
    'be defined'
    puts 'Running test ' + test_name.yellow
    puts 'The test will ' + test_description
    puts
  end

  def run_pretest
    run_execution('PreTest')
  end

  def run_test_case
    # @config.times.times { run_execution('Test') }
    run_execution('Test')
  end

  def run_post_set
    run_execution('PostTest')
  end

  def run_analyze_results
    run_execution('AnalyzeResults')
  end

  private

  def print_result(result)
    if result == true
      puts 'PASS'.green
    else
      puts 'FAIL'.red
    end
  end

  def run_execution(stage)
    stage_result = true

    begin
      puts 'Running ' + stage.yellow
    rescue
      stage_result = false
    end

    print_result(stage_result)
    stage_result
  end

  def dump_config
    puts "Current configuration from #{@config_file}:"
    puts @config.to_s.yellow
    puts
  end

  def print_welcome_and_info
    puts "Blade test v#{BLADE_TEST_VERSION}\n\n"
    print_description
  end

  def print_final_result
    puts 'Final result:'
    print_result(@result)
    puts "\n\n"
  end

  def run_flow
    begin
      run_pretest
      run_test_case
      run_post_set
      run_analyze_results
    rescue
      @result = false
    end

    print_final_result
  end
end

begin
  test = BladeTest.new(BladeTest.config_file)
  test.run
rescue => e
  puts e.to_s.red
end
