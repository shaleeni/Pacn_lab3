#!/bin/bash

# Define the links
links=("AB Bi" "AC ci" "BC Ci" "CD Di" "DA Ai")

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

    
# Function to get the index of an element in ip_adr array
get_index() {
    local element="$1"
    echo "${map[$element]}"
}


# Function to execute the command
execute_command() {
    local source="$1"
    local destination="$2"
    local ips="${ip_adr[$(get_index $source)]}"
    local ipd="${ip_adr[$(get_index $destination)]}"
    local index=$(get_index "$source")
    local namespace=""

    if [[ $index -ge 0 && $index -le 2 ]]; then
        namespace="A"
    elif [[ $index -eq 3 || $index -eq 4 ]]; then
        namespace="B"
    elif [[ $index -eq 5 || $index -eq 6 ]]; then
        namespace="C"
    elif [[ $index -eq 7 || $index -eq 8 ]]; then
        namespace="D"
    else
        echo "Invalid source index"
    fi

    local command="sudo ip netns exec $namespace  timeout 4s  ping $ipd"

    echo "$command"
    $command   
# timeout 5s $command
}


fn(){
      # Select a random link
    random_index=$(( RANDOM % ${#links[@]} ))
    random_link="${links[$random_index]}"
    source="${random_link%% *}"
    destination="${random_link#* }"
    echo "Selected link: $source to $destination"
    execute_command "$source" "$destination"
}

# Main function
main() {
    # Run the function 10 times using a loop
    for ((i=1; i<=10; i++)); do
        fn
    done
}

# Execute main function
main
