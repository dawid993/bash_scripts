#!/bin/bash

concatenated="$*"
concatenated=${concatenated// /}

declare -i sum=0 num len=${#concatenated}

if [[ $len -le 1 || ! "$concatenated" =~ ^[0-9]+$ ]]; then
    echo "false"
    exit 0
fi

# Iterate character by character
for (( i=len - 1; i >= 0; i-- )); do
    num=${concatenated:$i:1}
    if (( (len - i) % 2 == 0 )); then
        (( num = num * 2 ))
        (( num > 9 )) && (( num = num - 9 ))
    fi

    sum+=$num
done

(( sum % 10 == 0 )) && echo "true"  || echo "false"

