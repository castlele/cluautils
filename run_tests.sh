#!/bin/bash

tests_dir=./tests
FILTER=$1

for test_file in $tests_dir/${FILTER}.lua; do
    echo -e "\033[35mRunning tests for $test_file\033[0m"

    lua $test_file

    echo -e "\033[35mTests finished for $test_file\033[0m"
done
