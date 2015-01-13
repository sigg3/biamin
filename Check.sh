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

    # TODO check BASH version

    # CRITICAL
    for PROGRAM in "tput" "awk" "bc" "sed" "critical program 1" "critical program 2"
    do
	IsInstalled "$PROGRAM" || CRITICAL+=("$PROGRAM")
    done
    
    # NONCRITICAL
    for PROGRAM in "curl" "wget"  "non-critical program 1" "non-critical program 2"
    do
	IsInstalled "$PROGRAM" || NONCRITICAL+=("$PROGRAM")
    done

    echo

    if [[ "${CRITICAL[*]}" || "${NONCRITICAL[*]}" ]]; then

	[[ "${CRITICAL[*]}" ]] && echo "For successfull biamin playing you need install:"
	for ((i = 0; ; i++)); do
	    [[ "${CRITICAL[i]}" ]] || break
	    echo -e "\t${CRITICAL[i]}";
	done

	[[ "${NONCRITICAL[*]}" ]] && echo "Optionals:"
	for ((i = 0; ; i++)); do
	    [[ "${NONCRITICAL[i]}" ]] || break
	    echo -e "\t${NONCRITICAL[i]}";
	done

	
	[[ "${CRITICAL[*]}" ]] && Die || read -sn 1	
	
    else
	echo ""
    fi

    # TODO update old saves
}

#-----------------------------------------------------------------------
# IsInstalled()
# Checks if $1 installed
# Arguments: $PROGRAM(string)
# Used CheckDependencies()
#
# There can be used tput for nicer output but I'm not sure if it is a
# good idea - to use tput in function which check tput.
#-----------------------------------------------------------------------
IsInstalled() {
    echo -n "$1"
    if [[ $(which "$1" 2>/dev/null) ]]; then
	# echo "$(tput hpa 68)[$(tput setaf 2)OK$(tput setaf 7)]"
	echo -e "\t\t[OK]"
	return 0
    else
	# echo "$(tput hpa 68)[$(tput setaf 1)FAIL$(tput setaf 7)]"
	echo -e "\t\t[FAIL]"
	return 1
    fi
}

CheckDependencies
