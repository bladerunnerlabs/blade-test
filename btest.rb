#!/usr/bin/ruby
# frozen_string_literal: true

require 'yaml'
require 'colorize'

BLADE_TEST_VERSION = '0.1'

# BladeTest - test framework implementation
class BladeTest
  def initialize(config_file)
    @config = YAML.load_file(config_file)
    @result = true
  end

  def run
    print_welcome_and_info
    dump_config
    run_flow
  end

  def print_description
    test_name = 'sample_test'
    test_description = 'demonstrate how the test framework yaml files should be defined'
    puts 'Running test ' + test_name.yellow
    puts 'The test will ' + test_description
    puts
  end

  def run_pretest
    run_execution('PreTest')
  end

  def run_test_case
    # @config.times.times { run_execution('Test') }
  end

  def run_post_set
    run_execution('PostTest')
  end

  def run_analyze_results
    run_execution('AnalyzeResults')
  end

  private

  def run_execution(stage) end

  def dump_config
    puts 'Current configuration:'
    puts @config.to_s.yellow
    puts
  end

  def print_welcome_and_info
    puts "Blade test v#{BLADE_TEST_VERSION}\n\n"
    print_description
  end

  def final_result
    if @result == true
      puts 'PASS'.green
    else
      puts 'FAIL'.red
    end
    puts "\n\n"
  end

  def run_flow
    run_pretest
    run_test_case
    run_post_set
    run_analyze_results

    final_result
  end
end

test = BladeTest.new('./sample/sample_test.yaml')
test.run
