#!/bin/bash
encode() {
    str="$1"
    counter=1
    last=""
    res=""

    j=1
    for (( i=0; i<${#str}; i++ )); do
        if [[ $j -lt ${#str} && "${str:$i:1}" == "${str:$j:1}" ]]; then
            (( counter ++ ))
        else
            if (( counter > 1)); then
                res+="$counter"
            fi
            res+="${str:$i:1}"
            counter=1
        fi
        (( j++ ))
    done
    echo "$res"
}

decode() {
    str="$1"
    counter=""
    res=""
    for (( i=0; i<${#str}; i++ )); do
        char="${str:$i:1}"
        if [[ "$char" =~ [1-9] ]]; then
            counter="$counter$char"
        else          
            for (( j=0; j < ${counter:-1}; j++ )); do
                res+="$char"
            done
            counter=""
        fi
    done

    echo "$res"
}

mode="$1"
shift

if [[ "$mode" == 'encode' ]]; then
    echo "$(encode "$@")"
else
    echo "$(decode "$@")"
fi

