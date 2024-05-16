#!/bin/bash

print_arr() {
        local arr_name=$1
        eval "local arr_elems=(\"\${${arr_name}[@]}\")"
        for elem in "${arr_elems[@]}"; do
                echo "$elem"
        done;
}

search_term=$1
flag_param_index=-1

if [ $# -lt 3 ]; then
        echo "sgrip search_term [flags] files"
        exit 1
fi

# Parsing input to retrieve flag arguments

n_flag=false
l_flag=false

for (( i=2; i<=$#; i=i+1 )); do
        arg="${!i}"
        if [[ $arg != -* ]]; then
                break
        fi

        if [[ "$arg" == "-n" ]]; then
                n_flag=true
        elif [[ "$arg" == "-l" ]]; then
                l_flag=true
        fi

        flag_param_index=$i
done

# Build files arrays
if [ $flag_param_index -eq -1 ]; then
        files=("${@:2}")
else
        files=("${@:$((flag_param_index+1))}")
fi


if [ ${#files[@]} -eq 0 ]; then
        echo "Missing files argument: sgrip search_term [flags] files"
        exit 1
fi

# Nice to debug input
# echo "Files: ${files[@]}"
# echo "Number of files: ${#files[@]}"

results=()
files_results=()

for file in ${files[@]}; do
        counter=0
        while IFS= read -r line; do
                if [[ $line =~ $search_term ]]; then
                        if [[ "$n_flag" == "true" ]]; then
                                results+=("$file:$counter:$line")
                        else
                                results+=("$line")
                        fi

                        if [[ "$l_flag" == "true" ]]; then
                                files_results+=("$file")
                        fi

                fi
        done < "$file"
done

#echo "Results: ${results[@]}"
if [[ "$l_flag" == "true" ]]; then
        print_arr "files_results"
else
        print_arr "results"
fi

exit 0