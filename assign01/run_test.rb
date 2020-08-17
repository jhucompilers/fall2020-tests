#! /usr/bin/env ruby

require 'open3'

# Run a test for assignment 1.
# The ASSIGN01_DIR environment variable must be set to the directory
# containing the "minicalc" executable.

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

# Make sure that expected output file exists
expected_output_filename = "expected_output/#{testname}.out"
raise "Missing expected output file #{expected_output_filename}" if !(FileTest.readable?(expected_output_filename))

# Run the executable on the named test
cmd = [exe, input_file]
#puts "cmd is: #{cmd.join(' ')}"
stdout_str, stderr_str, status = Open3.capture3(*cmd, stdin_data: '')
if !status.success?
  puts "Test command failed"
  if !stderr_str.empty?
    puts "Error output is:"
    puts stderr_str
  end
  exit 1
end

# write output to actual_output directory
Dir.mkdir('actual_output') if !FileTest.directory?('actual_output')
actual_output_filename = "actual_output/#{testname}.out"
File.open(actual_output_filename, 'w') do |out|
  out.print stdout_str
end

# Diff actual output against expected output
cmd = ['diff', actual_output_filename, expected_output_filename]
stdout_str, stderr_str, status = Open3.capture3(*cmd, stdin_data: '')
if status.success?
  puts "Test passed!"
else
  puts "Test failed"
  puts "Diff output:"
  puts stdout_str
end
