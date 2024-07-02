#!/bin/bash

x="$1"
y="$2"
direction="$3"
commands="$4"

if [[ "$#" -eq 0 ]]; then 
    echo "0 0 north"
    exit 0
fi

if [[ ! "$direction" =~ north|south|west|east ]]; then
    echo "invalid direction"
    exit 1
fi

for (( i=0; i<${#commands}; i++ )); do
    arg="${commands:$i:1}"
    if [[ ! "$arg" =~ A|L|R ]]; then
        echo "invalid instruction"
        exit 1
    fi

    case "$direction" in 
        "north")
            case "$arg" in 
                "A")
                    (( y+=1 )) ;;
                "R")
                    direction="east" ;;
                "L")
                    direction="west" ;;
            esac
            ;;
        "east")
            case "$arg" in 
                "A")
                    (( x+=1 )) ;;
                "R")
                    direction="south" ;;
                "L")
                    direction="north" ;;
            esac
            ;;
        "south")
            case "$arg" in 
                "A")
                    (( y-=1 )) ;;
                "R")
                    direction="west" ;;
                "L")
                    direction="east" ;;
            esac
            ;;
        
        "west")
            case "$arg" in 
                "A")
                    (( x-=1 )) ;;
                "R")
                    direction="north" ;;
                "L")
                    direction="south" ;;
            esac
            ;;
    esac
done    
        
echo "$x $y $direction"
