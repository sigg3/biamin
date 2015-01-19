#!/bin/bash

Die()        { echo -e "$1" && exit 1 ;}                                           # Display $1 and exit script.

#-----------------------------------------------------------------------
# CheckDependencies()
# Checks needed programs
# Used: CoreRuntime.sh
#-----------------------------------------------------------------------
CheckDependencies() {
    declare -a CRITICAL NONCRITICAL
    clear
    echo "Checking dependencies..."

    # Check BASH version (we don't need it now, but will need after 2.0 #kstn) 
    # (( "${BASH_VERSINFO[0]}" < 4)) && Die "Biamin requires BASH version >= 4 to run (atm $BASH_VERSION)"
    
    # CRITICAL
    for PROGRAM in "tput" "awk" "bc" "sed" "printf" "critical program 1" "critical program 2"
    do
	IsInstalled "$PROGRAM" || CRITICAL+=("$PROGRAM")
    done

    # NONCRITICAL
    for PROGRAM in "curl" "wget" "non-critical program 1" "non-critical program 2"
    do
	IsInstalled "$PROGRAM" || NONCRITICAL+=("$PROGRAM")
    done

    echo

    if [[ "${CRITICAL[*]}" || "${NONCRITICAL[*]}" ]]; then
	echo "In order to play 'Back in a Minute', please install:"
	for ((i = 0; ; i++)); do
	    [[ "${CRITICAL[i]}" ]] || break
	    echo -e "\tRequired:\t${CRITICAL[i]}";
	done

	for ((i = 0; ; i++)); do
	    [[ "${NONCRITICAL[i]}" ]] || break
	    echo -e "\tOptional:\t${NONCRITICAL[i]}";
	done

	[[ "${CRITICAL[*]}" ]] && Die || read -sn 1

    fi

    # TODO check screen size (80x24 minimum)
    (( $(tput cols) > 79 && $(tput lines) > 23)) || Die "Biamin requires at least a 24x80 screen to run on (atm $(tput lines)x$(tput cols))."
    # TODO update old saves
}

#-----------------------------------------------------------------------
# IsInstalled()
# Checks if $1 installed
# Arguments: $PROGRAM(string)
# Used CheckDependencies()
#-----------------------------------------------------------------------
IsInstalled() {
    if [[ $(which "$1" 2>/dev/null) ]]; then
	return 0
    else
	return 1
    fi
}

CheckDependencies
