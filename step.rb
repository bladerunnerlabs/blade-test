# frozen_string_literal: true

require_relative 'execution_list.rb'

# Step - handle the test step
class Step
  attr_reader :result

  def initialize(step_config)
    @step_config = step_config
    @step_name = @step_config.keys.first
    @times = @step_config[step_config.keys.first]['Times']
    @times = 1 if @times.nil?
    @execution_list = @step_config[step_config.keys.first]['Execute']
    @result = true
  end

  def run
    puts "Running #{@step_name} step #{@times} times..."
    step_start_time = Time.now.to_f
    @times.times { return false unless execute_single_step_iteration }
    print_total_step_time(step_start_time, Time.now.to_f)
    true
  end

  private

  def print_total_step_time(start_time, end_time)
    puts "#{@step_name} total time is: " + (end_time - start_time).to_s.yellow
    puts
    puts
  end

  def print_result(result)
    if result == true
      puts 'PASS'.green
    else
      puts 'FAIL'.red
    end
  end

  def step_failed(exception)
    puts exception
    print_result(false)
    @result = false
  end

  def execute_single_step_iteration
    execution = ExecutionList.new(@step_name, @execution_list)
    execution.run
    print_result(true)
    true
  rescue TestStepException => e
    step_failed(e)
    false
  end
end
