#! /usr/bin/env ruby

require 'open3'

# Run a test for assignment 1.
# The ASSIGN01_DIR environment variable must be set to the directory
# containing the "minicalc" executable.

# ----------------------------------------------------------------------
# Functions
# ----------------------------------------------------------------------

def write_output(dirname, filename, s)
  if !s.empty?
    Dir.mkdir(dirname) if !FileTest.directory?(dirname)

    output_filename = "#{dirname}/#{filename}"
    File.open(output_filename, 'w') do |out|
      out.print s
    end
  end
end

def check_actual_vs_expected_output(actual_output_filename, expected_output_filename, exit_code)
  if exit_code != 0
    puts "Program exited with non-zero exit code"
    exit 1
  end

  # Diff actual output against expected output
  cmd = ['diff', actual_output_filename, expected_output_filename]
  stdout_str, stderr_str, status = Open3.capture3(*cmd, stdin_data: '')
  if status.success?
    puts "Test passed!"
    exit 0
  else
    puts "Test failed"
    puts "Diff output:"
    puts stdout_str
    exit 1
  end
end

def check_actual_vs_expected_error(actual_error_filename, expected_error_filename, exit_code)
  puts "TODO: check error output"
  exit 1
end

# ----------------------------------------------------------------------
# Main script
# ----------------------------------------------------------------------

raise 'ASSIGN01_DIR environment variable must be set' if !ENV.has_key?('ASSIGN01_DIR')
exe_dir = ENV['ASSIGN01_DIR']

# make sure executable exists
exe = "#{exe_dir}/minicalc"
raise "#{exe} is not executable" if !FileTest.executable?(exe)

# command line argument is the test name
raise "Usage: ./run_test.rb <testname>" if ARGV.length != 1
testname = ARGV.shift

# Make sure that input file exists (otherwise, the test doesn't exist)
input_file = "input/#{testname}.in"
raise "No such test input #{input_file}" if !(FileTest.readable?(input_file))

# Make sure that either the expected output file or expected error file exists
expected_output_filename = "expected_output/#{testname}.out"
expected_error_filename = "expected_error/#{testname}.out"
if !FileTest.readable?(expected_output_filename) && !FileTest.readable?(expected_error_filename)
  raise "Neither expected output nor expected error files exist"
end

# Run the executable on the named test
cmd = [exe, input_file]
#puts "cmd is: #{cmd.join(' ')}"
stdout_str, stderr_str, status = Open3.capture3(*cmd, stdin_data: '')
if !status.exited?
  puts "Test command failed"
  if !stderr_str.empty?
    puts "Error output is:"
    puts stderr_str
  end
  exit 1
end

# write output to actual_output directory
write_output('actual_output', "#{testname}.out", stdout_str)

# write error outout to actual_error directory
write_output('actual_error', "#{testname}.out", stderr_str)

if FileTest.readable?(expected_output_filename)
  check_actual_vs_expected_output("actual_output/#{testname}.out", expected_output_filename, status.exitstatus)
else
  check_actual_vs_expected_error("actual_error/#{testname}.out", expected_error_filename, status.exitstatus)
end
