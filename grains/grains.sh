#!/bin/bash
if [[ $1 == "total" ]]; then
        printf "%lu\n" $(( 2**64 -1 ))
        exit 0
fi
n=$1
if [[ $n -lt 1 || $n -gt 64 ]]; then
        echo "Error: invalid input"
        exit 1
fi
printf "%lu\n" $(( 2** (n-1) ))
exit 0