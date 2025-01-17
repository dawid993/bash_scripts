#!/bin/bash

num_count() {
    local num=$1
    local str="$2"

    count=$(echo "$str" | grep -o "$num" | wc -l)

    echo $(( num * count))
}

occ_count() {
    echo "$1" | tr ' ' '\n' | sort | uniq -c | awk '{print $1}' | paste -s -d ''
}

sum() {
    str="$*"
    sum=0
    for num in $str; do
        ((sum += num))
    done
    echo "$sum"
}

_sort() {
    echo "$1" | tr ' ' '\n' | sort -n | tr '\n' ' '
}

category="$1"

shift

dices="$*"

case "$category" in 
    "ones") echo $(num_count 1 "$dices") ;;
    "twos") echo $(num_count 2 "$dices") ;;
    "threes") echo $(num_count 3 "$dices") ;;
    "fours") echo $(num_count 4 "$dices") ;;
    "fives") echo $(num_count 5 "$dices") ;;
    "sixes") echo $(num_count 6 "$dices") ;;
    "full house") {
        score=$(occ_count "$dices")
        ((score == 32 || score == 23)) && echo $(sum "$dices") || echo 0
    } ;;    
    "four of a kind") {
        score=$(occ_count "$dices")
        if ((score == 41 || score == 14 || score == 5)); then 
            sorted="$(_sort "$dices")"
            if (( ${sorted:0:1} != ${sorted:2:1} )); then
                echo $(( ${sorted:2:1} * 4 ))
            else
                echo $(( ${sorted:0:1} * 4 ))
            fi
        else
            echo 0
    fi

    };;
    "little straight") {        
        [[ "$(_sort "$dices")" == "1 2 3 4 5 " ]] && echo 30 || echo 0
    };;    
    "big straight") {
        [[ "$(_sort "$dices")" == "2 3 4 5 6 " ]] && echo 30 || echo 0
    };;
    "choice") echo $(sum "$dices");;
    "yacht") {
        score=$(occ_count "$dices")
        (( score == 5 )) && echo 50 || echo 0
    } 
esac



