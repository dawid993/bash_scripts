#!/bin/bash

# Instructions
# Given a 3 x 4 grid of pipes, underscores, and spaces, determine which number is represented, or whether it is garbled.

# Step One
# To begin with, convert a simple binary font to a string containing 0 or 1.

# The binary font uses pipes and underscores, four rows high and three columns wide.

#      _   #
#     | |  # zero.
#     |_|  #
#          # the fourth row is always blank
# Is converted to "0"

#          #
#       |  # one.
#       |  #
#          # (blank fourth row)
# Is converted to "1"

# If the input is the correct size, but not recognizable, your program should return '?'

# If the input is the incorrect size, your program should return an error.

# Step Two
# Update your program to recognize multi-character binary strings, replacing garbled numbers with ?

# Step Three
# Update your program to recognize all numbers 0 through 9, both individually and as part of a larger string.

#  _
#  _|
# |_

# Is converted to "2"

#       _  _     _  _  _  _  _  _  #
#     | _| _||_||_ |_   ||_||_|| | # decimal numbers.
#     ||_  _|  | _||_|  ||_| _||_| #
#                                  # fourth line is always blank
# Is converted to "1234567890"

# Step Four
# Update your program to handle multiple numbers, one per line. When converting several lines, join the lines with commas.

#     _  _
#   | _| _|
#   ||_  _|

#     _  _
# |_||_ |_
#   | _||_|

#  _  _  _
#   ||_||_|
#   ||_| _|

# Is converted to "123,456,789".

declare -A board;

render() {
    local output=""
    local total_columns=$1
    local start_row=$2
    
    for (( column=0; column < total_columns; column = column + 3 )); do
        one_iter_out=""
        for (( row = start_row; row < start_row + 4; row++ )); do
            for (( count=column; count < column + 3; count++ )); do
                case ${board["$row,$count"]} in
                    " ") one_iter_out+="x" ;;
                    * ) one_iter_out+="${board["$row,$count"]}" ;;
                esac
            done
        done
        
        case "$one_iter_out" in
            "x_x|x||_|") output+="0" ;;
            "xxxxx|xx|") output+="1" ;;
            "x_xx_||_x") output+="2" ;;
            "x_xx_|x_|") output+="3" ;;
            "xxx|_|xx|") output+="4" ;;
            "x_x|_xx_|") output+="5" ;;
            "x_x|_x|_|") output+="6" ;;
            "x_xxx|xx|") output+="7" ;;
            "x_x|_||_|") output+="8" ;;
            "x_x|_|x_|") output+="9" ;;
            "")          output+="" ;;
            *)           output+="?" ;;
        esac
    done  
    
    echo "$output"
}

i=0
j=0
tc=0

while IFS= read -r -n1 char && [[ $char != $'\04' ]]; do    
    if [[ $char == "" ]]; then
        i=$(( i + 1 ))
        if (( j > tc )); then
            tc=$j
        fi
        j=0
    else
        if (( (i + 1) % 4 != 0 )); then
            board["$i,$j"]=$char
            j=$(( j + 1 ))
        fi
    fi
done

if ((i % 4 != 0 )); then
    echo "Number of input lines is not a multiple of four"
    exit 1
fi

if ((tc % 3 != 0 )); then
    echo "Number of input columns is not a multiple of three"
    exit 1
fi

ocr=""

for (( x = 0; x < i; x = x + 4)); do
    if (( x > 0 )); then
        ocr+=","
    fi
    ocr+="$(render $tc $x)"
done

echo "$ocr"

exit 0
