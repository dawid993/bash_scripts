#!/bin/bash
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