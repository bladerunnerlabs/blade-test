# frozen_string_literal: true

# TestStepException - exception class for test stage execution list failures
class TestStepException < StandardError
  def initialize(msg = 'Test step failed')
    super
  end
end

# ExecutionList - handle the list of commands that should be executed
class ExecutionList
  def initialize(stage_name, command_list)
    @stage_name = stage_name
    @command_list = command_list
  end

  def run
    puts 'Running ' + @stage_name.yellow
    return if skip_execution

    run_commands
  end

  private

  def skip_execution
    if @command_list.nil?
      puts 'SKIPPING'.yellow
      puts
      return true
    end

    false
  end

  def run_commands
    command_numbers = 1
    @command_list.each do |command|
      puts "#{command_numbers}: Executing: #{command.yellow}"
      command_numbers += 1

      result = system(command)
      command_execution_error(command, result)
    end
  end

  def command_execution_error(command, result)
    if result.nil?
      raise TestStepException,
            "Stage #{@stage_name}, command #{command} not found"
    end

    unless result
      raise TestStepException,
            "Stage #{@stage_name}," \
            "command #{command} failed: #{$CHILD_STATUS}"
    end
  end
end
