#!/bin/bash
declare -A board;

echo "Enter multiline input (Ctrl-D to end):"

i=0
j=0
max_j=0
# Read input character by character until EOF
while IFS= read -r -n1 char; do

    if [[ $char == $'\04' ]]; then
        break
    fi

    # Check if the input is empty, which happens at new lines
    if [[ $char == "" ]]; then
        if (( (j + 1 ) % 3 != 0 )); then
                board["$i,$(( j + 1 ))"]=" "               
        fi
        i=$(( i + 1 ))

        if (( j > max_j )); then
            max_j=$j
        fi
        
        j=0
    else
        board["$i,$j"]=$char
        j=$(( j + 1 ))
    fi
done

echo $i $max_j

output=""
for ((col=0; col<i; col++)); do
    for ((rows=0; rows<max_j; rows++)); do
        case ${board["$col,$rows"]} in     
            " ") output+="x" ;;
            * ) output+="${board["$col,$rows"]}" ;;
        esac
    done
done

echo $output
case "$output" in
    "x_x|x||_|") echo "0" ;;
    "xxxxx|xx|") echo "1" ;;
    "x_xx_||_x") echo "2" ;;
    "x_xx_|x_|") echo "3" ;;
    "xxx|_|xx|") echo "4" ;;
    "x_x|_xx_|") echo "5" ;;
    "x_x|_x|_|") echo "6" ;;
    "x_xxx|xx|") echo "7" ;;
    "x_x|_||_|") echo "8" ;;
    "x_x|_|x_|") echo "9" ;;
esac