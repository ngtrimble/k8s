#!/bin/bash

# Declare an array (indices start at 0)
my_array=("apple")

# The slice "${my_array[@]:1}" creates a list starting from index 1 ("banana")
echo "Looping through array slice starting at index 1:"
for item in "${my_array[@]:1}"; do
  echo "Processing: $item"
done