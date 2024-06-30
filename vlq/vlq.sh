#!/bin/bash

# Instructions
# Implement variable length quantity encoding and decoding.

# The goal of this exercise is to implement VLQ encoding/decoding.

# In short, the goal of this encoding is to encode integer values in a way that would save bytes. Only the first 7 bits of each byte are significant (right-justified; sort of like an ASCII byte). So, if you have a 32-bit value, you have to unpack it into a series of 7-bit bytes. Of course, you will have a variable number of bytes depending upon your integer. To indicate which is the last byte of the series, you leave bit #7 clear. In all of the preceding bytes, you set bit #7.

# So, if an integer is between 0-127, it can be represented as one byte. Although VLQ can deal with numbers of arbitrary sizes, for this exercise we will restrict ourselves to only numbers that fit in a 32-bit unsigned integer. Here are examples of integers as 32-bit values, and the variable length quantities that they translate to:

#  NUMBER        VARIABLE QUANTITY
# 00000000              00
# 00000040              40
# 0000007F              7F
# 00000080             81 00
# 00002000             C0 00
# 00003FFF             FF 7F
# 00004000           81 80 00
# 00100000           C0 80 00
# 001FFFFF           FF FF 7F
# 00200000          81 80 80 00
# 08000000          C0 80 80 00
# 0FFFFFFF          FF FF FF 7F

process() {
    local mode="$1"
    local num_val=$( printf "%d" "$((16#$2))")

    i=0 
    bits=0

    while (( num_val > 0 )); do
        case "$mode" in 
        'encode') 
            extracted_bits=$(( num_val & 127 ))
            if (( i > 0 )); then
                (( extracted_bits |= 128 ))
            fi
            (( bits |= extracted_bits << i ))   
            (( i += 8 ))
            (( num_val >>= 7 ))
        ;;
        'decode')
            extracted_bits=$(( num_val & 127 ))
            (( bits |= extracted_bits << i ))        
            (( i += 7 ))
            (( num_val >>= 8 ))
        ;;
        esac
    done

    printf '%02X' "$bits"
}

mode=$1
shift 
output=""

if [[ $mode == "encode" ]]; then
    for arg in "$@"; do
        output+=$(process "encode" "$arg")
    done
    echo "$output" | awk '{gsub(/../,"& "); sub(/[ ]{1}$/,""); print}'
elif [[ $mode == "decode" ]]; then
    current=""
    for arg in "$@"; do
        result=$(( $( printf "%d" "$((16#$arg))") & 128 ))
        if [[ $result -eq 0 ]]; then
            current+="$arg"
            output+=" $(process "decode" "$current")"
            current=""
        else
            current+="$arg"
        fi
    done 

    if [[ "${#current}" -gt 0 ]]; then
        echo "incomplete byte sequence"
        exit 1
    fi

    echo "$output" | awk '{sub(/^[ ]{1}/,""); print}'
else 
    echo "unknown subcommand"
    exit 1
fi