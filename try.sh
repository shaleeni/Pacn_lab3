#!/bin/bash

# Define the links
links=("AB Bi" "AC ci" "BC ci" "CD Di" "DA Ai")
sets=("AB Bi CD Di" "DA Ai BC ci" "AC ci" )
# Define IP addresses
ip_adr=("192.0.2.1" "192.0.2.2" "192.0.2.3" "192.0.2.4" "192.0.2.5" "192.0.2.6" "192.0.2.7" "192.0.2.8" "192.0.2.9")
# Declare an associative array
declare -A map

# Add key-value pairs to the map
map[AB]=0
map[AC]=1
map[Ai]=2
map[BC]=3
map[Bi]=4
map[CD]=5
map[ci]=6
map[DA]=7
map[Di]=8

get_index() {
    local element="$1"
    echo "${map[$element]}"
}
# Function to execute the command
execute_command() {
    local source1="$1"
    local dest1="$2"
    local source2="$3"
    local dest2="$4"
    local ips1="${ip_adr[$(get_index $source1)]}"
    local ipd1="${ip_adr[$(get_index $dest1)]}"
    local ips2="${ip_adr[$(get_index $source2)]}"
    local ipd2="${ip_adr[$(get_index $dest2)]}"
    #finding namespace of source 1
    local index1=$(get_index "$source1")
    local namespace1=""

    if [[ $index1 -ge 0 && $index1 -le 2 ]]; then
        namespace1="A"
    elif [[ $index1 -eq 3 || $index1 -eq 4 ]]; then
        namespace1="B"
    elif [[ $index1 -eq 5 || $index1 -eq 6 ]]; then
        namespace1="C"
    elif [[ $index1 -eq 7 || $index1 -eq 8 ]]; then
        namespace1="D"
    else
        echo "Invalid source index"
    fi
    #finding namespace of source 2
    local index2=$(get_index "$source2")
    local namespace2=""

    if [[ $index2 -ge 0 && $index2 -le 2 ]]; then
        namespace2="A"
    elif [[ $index2 -eq 3 || $index2 -eq 4 ]]; then
        namespace2="B"
    elif [[ $index2 -eq 5 || $index2 -eq 6 ]]; then
        namespace2="C"
    elif [[ $index2 -eq 7 || $index2 -eq 8 ]]; then
        namespace2="D"
    else
        echo "Invalid source index"
    fi

    local command1="sudo ip netns exec $namespace1  timeout 4s  ping -c 200 $ipd1"
    local command2="sudo ip netns exec $namespace2  timeout 4s  ping -c 200  $ipd2"
    echo "commands:"
    echo "$command1"
    echo "$command2"
    echo "  "
    eval "$command1"&
    eval "$command2"
}
fn() {
    local input_set="$1"
    local links=($input_set)
    local source1="${input_set%% *}" # Extracts the first link (e.g., "AB")
    echo "source1" 
    echo $source1
    local rest_link="${input_set#* }"  # Extracts the second link (e.g., "bi CD di")
    local dest1="${rest_link%% *}"   #extracts the Bi
    echo "destination1"
    echo $dest1
    local second_link="${rest_link#* }"   #extracts ("CD Di")
    local source2="${second_link%% *}"    #extracst ("CD")
    echo "source2"
    echo $source2
    local dest2="${second_link#* }"
    echo "dest2"    
    echo $dest2
    #echo "running ping $source1 to $dest1"
    execute_command "$source1" "$dest1" "$source2" "$dest2"
}
main(){
    	fn "${sets[0]}"
	fn "${sets[1]}"
	fn "${sets[2]}"
	fn "${sets[1]}"
	fn "${sets[0]}"
}
main

