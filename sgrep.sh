#!/bin/bash

# Search files for lines matching a search string and return all matching lines.

# The Unix grep command searches files for lines that match a regular expression. Your task is to implement a simplified grep command, which supports searching for fixed strings.

# The grep command takes three arguments:

# The string to search for.
# Zero or more flags for customizing the command's behavior.
# One or more files to search in.
# It then reads the contents of the specified files (in the order specified), finds the lines that contain the search string, and finally returns those lines in the order in which they were found. When searching in multiple files, each matching line is prepended by the file name and a colon (':').

# Flags
# The grep command supports the following flags:

# -n Prepend the line number and a colon (':') to each line in the output, placing the number after the filename (if present).
# -l Output only the names of the files that contain at least one matching line.
# -i Match using a case-insensitive comparison.
# -v Invert the program -- collect all lines that fail to match.
# -x Search only for lines where the search string matches the entire line.

to_lower() {
        echo "$1" | tr "[:upper:]" "[:lower:]"
}
is_match() {
        local match="false"
        local line=$1
        local search_term=$2
        if [[ "$v_flag" == "true" ]]; then
                match=$( [[ ! "$line" =~ $search_term ]] && echo "true" || echo "false")
        elif [[ "$x_flag" == "true" ]]; then
                match=$( [[ "$line" == "$search_term" ]] && echo "true" || echo "false")
        else
                match=$( [[ "$line" =~ $search_term ]] && echo "true" || echo "false")
        fi
        echo "$match"
}
grep_file() {
        local file=$1
        counter=1
        while IFS= read -r line; do
                orig_line=$line
                if [[ "$i_flag" == "true" ]]; then
                        line=$(to_lower "$line")
                        search_term=$(to_lower "$search_term")
                fi
                if [[ "$(is_match "$line" "$search_term")"  == "true" ]]; then
                        if [[ "$l_flag" == "true" ]]; then
                                echo "$file"
                                break;
                        fi
                        out=""
                        if [[ ${#files[@]} -gt 1 ]]; then
                                out+="$file:"
                        fi
                        if [[ "$n_flag" == "true" ]]; then
                                out+="$counter:"
                        fi
                        out+="$orig_line"
                        echo "$out"
                fi
                counter=$((counter+1))
        done < "$file"
}
#Parsing input to retrieve flag arguments
n_flag=false
l_flag=false
i_flag=false
v_flag=false
x_flag=false
while [[ "$1" == -* ]]; do
        case "$1" in
                -n) n_flag=true ;;
                -l) l_flag=true ;;
                -i) i_flag=true ;;
                -v) v_flag=true ;;
                -x) x_flag=true ;;
        esac
        shift
done
search_term="$1"
shift
files=("$@")
for file in "${files[@]}"; do
        grep_file "$file"
done
exit 0