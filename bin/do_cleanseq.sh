#!/bin/bash

arg_input=$0
arg_output=$1

# remove illlegal characters and convert the code if necessary
cat $arg_input | tr -c '[:print:]\n' ' ' | sed 's/\*//g' > $arg_output
