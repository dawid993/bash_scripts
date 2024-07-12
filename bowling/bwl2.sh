#!/bin/bash

error () {
  echo "$1"
  exit 1
}

onFrameFinish() {
    inFrame=0
    inFramePoints=0
    (( frames++ ))
}

testFill() {
    local expArgs="$1"
    shift 2
    local count=0
    for arg in "$@"; do
       (( arg > 10 )) && error "Pin count exceeds pins on the lane"
       (( count++ ))
    done

    (( expArgs > count)) && error "Score cannot be taken until the end of the game"
    (( expArgs < count)) && error "Cannot roll after game is over"
    (( expArgs == 2 && ( $1 != 10 && ($1 + ${2:-0} > 10) ) )) && error "Pin count exceeds pins on the lane"
}

points=0
frames=0
inFrame=0
inFramePoints=0

while (( $# > 0 )); do
    (( frames > 9 )) && error "Cannot roll after game is over"
    (( ${1} > 10 )) && error "Pin count exceeds pins on the lane"
    (( ${1} < 0)) && error "Negative roll is invalid"
    (( points += ${1}, inFrame++, inFramePoints += ${1}))    
    (( inFramePoints > 10)) && error "Pin count exceeds pins on the lane"

    if (( inFrame == 2 && inFramePoints == 10 )); then       
        points=$(( points + ${2:-0} ))       
        onFrameFinish 
        (( frames > 9 )) && { testFill 1 "$@"; break; }            
    elif (( inFrame == 1 && inFramePoints == 10 )); then
        points=$(( points + ${2:-0} + ${3:-0} ))
        onFrameFinish  
        (( frames > 9 )) && { testFill 2 "$@"; break; }    
    elif (( inFrame == 2 )); then
        onFrameFinish   
    fi    
    shift
done

(( frames < 9)) && error "Score cannot be taken until the end of the game"

echo "$points"
    