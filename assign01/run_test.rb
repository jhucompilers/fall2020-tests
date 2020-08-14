#! /usr/bin/env ruby

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

puts "TOOD: stuff"
