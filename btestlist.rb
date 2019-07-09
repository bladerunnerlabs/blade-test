#!/usr/bin/ruby
# frozen_string_literal: true

require 'yaml'
require 'colorize'
require_relative 'config.rb'

# BladeTestList -  run list of tests with btest framework
class BladeTestList
  BTESTLIST_CONFIG_FILE_MSG = %(
    Configuration file not found.
    Please provide configuration file as a parameter to btestlist.
  )

  def initialize(config_file)
    @config_file = config_file
    @config = YAML.load_file(@config_file)
  end

  def run
    print_description
    run_list
    true
  end

  private

  def run_list
    tests = @config['Tests']
    puts tests

    tests.each do |test|
      command = './btest.rb ' + test
      puts "Executing: #{command.yellow}"

      result = system(command)
    end
  end

  def print_description
    test_name = @config['Name']
    test_description = @config['Description']
    puts 'Running test list ' + test_name.yellow
    puts 'The tests will ' + test_description
    puts
  end
end

begin
  test_list = BladeTestList.new(
    BTestConfig.config_file(BladeTestList::BTESTLIST_CONFIG_FILE_MSG)
  )
  exit(test_list.run)
rescue ConfigFileException => e
  puts e.to_s.red
  exit(false)
end
