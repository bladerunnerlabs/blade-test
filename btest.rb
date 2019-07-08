#!/usr/bin/ruby
# frozen_string_literal: true

require 'yaml'

BLADE_TEST_VERSION = '0.1'

# BladeTest - test framework implementation
class BladeTest
  def initialize(config_file)
    @config = YAML.load_file(config_file)

    dump_config
  end

  def run
    print_welcome_and_info
    run_flow
  end

  def print_description
    puts 'Running btest...'
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
    puts @config
  end

  def print_welcome_and_info
    puts "Blade test v#{BLADE_TEST_VERSION}"
    print_description
  end

  def run_flow
    run_pretest
    run_test_case
    run_post_set
    run_analyze_results
  end
end

test = BladeTest.new('./sample/sample_test.yaml')
test.run
