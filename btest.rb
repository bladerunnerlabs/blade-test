#!/usr/bin/ruby
# frozen_string_literal: true

require 'yaml'
require 'colorize'
require 'English'
require_relative 'config.rb'
require_relative 'step.rb'

# BladeTest - test framework implementation
class BladeTest
  BTEST_VERSION = '0.1'
  BTEST_DEFAULT_CFG_FILE = '.btest.yaml'
  BTES_CONFIG_FILE_MSG = %(
    Configuration file not found.
    Please provide configuration file as a parameter to btest
    or create default configuration file ".btest.yaml".
  )
  BTEST_DEFAULT_CONFIG = { 'Name' => 'Test name not provided',
                           'Description' => 'do something unknown' }.freeze

  def initialize(config_file)
    @config_file = config_file
    @config = BTEST_DEFAULT_CONFIG.merge(YAML.load_file(@config_file))
    @result = true
  end

  def run
    dump_config
    print_welcome_and_info
    run_flow
    @result
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
  end

  def run_flow
    test_steps = @config['TestSteps']
    test_steps.each do |step_config|
      step = Step.new(step_config)
      step.run
      unless step.result
        @result = false
        break
      end
    end
    print_final_result
  end
end

begin
  test = BladeTest.new(
    BTestConfig.config_file(BladeTest::BTES_CONFIG_FILE_MSG,
                            BladeTest::BTEST_DEFAULT_CFG_FILE)
  )
  exit(test.run)
rescue ConfigFileException => e
  puts e.to_s.red
  exit(false)
end
