#! /usr/bin/env bash

# This script generates an expected output file for a specified
# input file.

if [ $# -eq 0 ]; then
  echo "No"
  exit 1
fi

testname=$(basename $1 .in)

$ASSIGN01_DIR/minicalc $1 > expected_output/$testname.out
