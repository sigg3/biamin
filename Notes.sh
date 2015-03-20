#!/bin/bash


. CoreFunctions.sh

CLEAR_LINE="\e[1K\e[80D" # \e[1K - erase to the start of line \e[80D - move cursor 80 columns backward
HR="- ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ "

#-----------------------------------------------------------------------
# Almanac_Notes()
#-----------------------------------------------------------------------
# TODO version 3
# DONE Add creation of mktemp CHAR.notes file that is referenced in $CHARSHEET
# OR add NOTE0-NOTE9 in .sheet file.
# DONE Add opportunity to list (default action in Almanac_Notes), (A)dd or (E)rase notes.
# DONE Notes are "named" by numbers 0-9.
# DONE Notes may not exceed arbitrary ASCII-friendly length.
# DONE Notes must be superficially "cleaned" OR we can simply "list" them with cat <<"EOT".
# 	Just deny user to input EOT :)
#-----------------------------------------------------------------------
Almanac_Notes() {    
    local CHAR_NOTES="$(whoami).notes"
    local NOTES=()		# Array for notes
    local i 			# Counter
    # GX_CharSheet 2 # Display GX banner with ALMANAC header
    # tput sc
    clear
    cat <<"EOF"
                             /T\                           /""""""""\
    o-+----------------------------------------------+-o  /  _ ++ _  \
      |/                                            \|   |  / \  / \  \
      |           A   L   M   A   N   A   C          |   | | , | |, | |
      |                                              |   | |   |_|  | |
      |\                                            /|    \|   ...; |;
    o-+-------------------N O T E S------------------+-o    \______/

EOF
    # this is "N O T E S" position ATM. Is it right? #kstn
    # MvAddStr 6 28 "N O T E S" # add"NOTES" subheader

    echo "$HR"
    if [[ ! -f "$CHAR_NOTES" ]]; then                                           # There is no $CHAR_NOTES file, so let's make it
	tput sc
	echo " In the back of your almanac, there is a page reserved for Your Notes."
	echo " There is only room for 10 lines, but you may erase obsolete information."
	echo	
	echo -e "\n\n\n\n\n\n\n\n\n\n" > "$CHAR_NOTES"                          # making empty notes file
	PressAnyKey
	tput rc
	tput ed
    fi    
    for i in {0..9}; do NOTES[$i]=$(sed -n "$((i + 1))p" "${CHAR_NOTES}"); done # load notes
    for i in {0..9}; do echo " $i - ${NOTES[$i]}"; done                         # display notes    
    echo "$HR"
    tput sc			                                                # store cursor position
    while (true); do                                                      ### main loop
	tput rc 		                                          # restore cursor position
	echo -en "${CLEAR_LINE}$(MakePrompt '(A)dd;(E)rase;(Q)uit')"      # prompt 
	tput ed			                                          # clear to the end of display at case if previous note was longer than 74
	case "$(Read)" in
	    [aA] ) echo -en "${CLEAR_LINE} Which one? [0-9]: ";           # prompt
		   i=$(Read);					          # read note num
		   grep -Eq '^[0-9]$' <<< "$i" || continue ;              # check if user input if int [0-9]
		   # TODO??? check if ${NOTE[$i} is emty
		   echo -en "${CLEAR_LINE} > ";                           # prompt
		   ReadLine ;                                             # read note
		   grep -Eq '^.+$' <<< "$REPLY" || continue;              # check if user input is empty
		   REPLY=$(sed -e 's/^\(.\{74\}\).*/\1/' <<< "$REPLY");   # restrict note length to 74
		   NOTES[$i]="$REPLY";                                    # store note in array
		   sed -i "$(($i + 1))s/^.*$/$REPLY/" "${CHAR_NOTES}";    # store note in file
		   MvAddStr $((9 + i)) 0 "$(tput el) $i - ${NOTES[$i]}";; # redraw note       
	    [eE] ) echo -en "${CLEAR_LINE} Which one? [0-9]: ";           # prompt
		   i=$(Read);				                  # read note num
		   grep -Eq '^[0-9]$' <<< "$i" || continue                # check if user input if int [0-9]
		   NOTES[$i]="";                                          # erase note in array
		   sed -i "$(($i + 1))s/^.*$//" "${CHAR_NOTES}";          # erase note in file
		   MvAddStr $((9 + i)) 0 "$(tput el) $i - ${NOTES[$i]}";; # redraw note
	    [qQ] ) break;;
	    *    ) ;;		
	esac
    done    
} # Return to Almanac()

tput civis
Almanac_Notes
tput cnorm
clear

