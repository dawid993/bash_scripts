#!/bin/bash

declare -A dict

dict[black]=0
dict[brown]=1
dict[red]=2
dict[orange]=3
dict[yellow]=4
dict[green]=5
dict[blue]=6
dict[violet]=7
dict[grey]=8
dict[white]=9

res=""
counter=0

if [[ ! -v dict["$1"] || ! -v dict["$2"] || ! -v dict["$3"] ]]; then
    exit 1
fi

if [[ "$1" == 'black' && "$2" == 'black' ]]; then
    echo "0 ohms"
    exit 0
fi

x="${dict["$1"]}"
y="${dict["$2"]}"
z="${dict["$3"]}"

if (( x == 0 )); then 
    x=""
fi

if (( y == 0)); then
    y="$x"
    x=""
    (( z+=1 ))
fi

suffix=""

case "$z" in
    "0")
        suffix=" ohms" ;;
    "1")
        suffix="0 ohms" ;;
    "2")
        suffix="00 ohms" ;;
    "3")
        suffix=" kiloohms" ;;
    "4")
        suffix="0 kiloohms" ;;
    "5")
        suffix="00 kiloohms" ;;
    "6")
        suffix=" megaohms" ;;
    "7")
        suffix="0 megaohms" ;;
    "8")
        suffix="00 megaohms" ;;
    "9")
        suffix=" gigaohms" ;;
esac

echo "$x$y$suffix"