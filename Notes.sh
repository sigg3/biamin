#!/bin/bash

. CoreFunctions.sh

CLEAR_LINE="\e[1K\e[80D" # \e[1K - erase to the start of line \e[80D - move cursor 80 columns backward
HR="- ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ "

CHAR_NOTES="$(whoami).notes"


# TODO version 3
# Add creation of mktemp CHAR.notes file that is referenced in $CHARSHEET
# OR add NOTE0-NOTE9 in .sheet file.
# Add opportunity to list (default action in Almanac_Notes), (A)dd or (E)rase notes.
# Notes are "named" by numbers 0-9.
# Notes may not exceed arbitrary ASCII-friendly length.
# Notes must be superficially "cleaned" OR we can simply "list" them with cat <<"EOT".
# 	Just deny user to input EOT :)

Almanac_Notes() {    
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
    tput sc

    

    # tput rc
    if [[ ! -f "$CHAR_NOTES" ]]; then # There is no $CHAR_NOTES file, so let's make it
	echo " In the back of your almanac, there is a page reserved for Your Notes."
	echo " There is only room for 10 lines, but you may erase obsolete information."
	echo
	# making notes file
	touch "$CHAR_NOTES"	
        for i in {0..9}; do echo "note $i" >> "$CHAR_NOTES"; done
	read -sn1 -p "press anykey"
	tput rc && tput ed
    fi

    NOTES=()
    # load notes
    for i in {0..9}; do
	NOTES[$i]=$(sed -n "$((i + 1))p" "${CHAR_NOTES}")
    done

    # display notes
    for i in {0..9}; do
	if [[ "${NOTES[$i]}" ]]; then # display note
	    echo " $i - ${NOTES[$i]}"
	else			# display empty folder
	    echo " $i - ............................................................"
	fi
    done
    
    echo "$HR"

    # loop
    while (true); do
	echo -en "${CLEAR_LINE}"
	MakePrompt '(A)dd;(E)rase;(Q)uit'
	case "$(Read)" in
	    [aA] ) echo -en "${CLEAR_LINE} Which one? [0-9]: ";
		   i=$(Read);
		   # TODO check for user input
		   # TODO check if note is emty
		   # TODO read note
		   echo -en "${CLEAR_LINE} > "
		   ReadLine
		   # TODO check note length
		   # TODO store note
		   NOTES[$i]="$REPLY"
		   # TODO store note in file
		   sed -i "$(($i + 1))s/^.*$/$REPLY/" "${CHAR_NOTES}" # erase note in file
		   # TODO redraw note
		   tput rc && tput ed		   
		   # display notes
		   for i in {0..9}; do
		       if [[ "${NOTES[$i]}" ]]; then # display note
			   echo " $i - ${NOTES[$i]}"
		       else			# display empty folder
			   echo " $i - ............................................................"
		       fi
		   done
		   
		   echo "$HR"

		   ;;
	    [eE] ) echo -en "${CLEAR_LINE} Which one? [0-9]: ";
		   i=$(Read);
		   # TODO check for user input
		   # TODO check if note is emty
		   NOTES[$i]=""	# erase note in array
		   sed -i "$(($i + 1))s/^.*$//" "${CHAR_NOTES}" # erase note in file
		   # TODO redraw note
		   tput rc && tput ed		   
		   # display notes
		   for i in {0..9}; do
		       if [[ "${NOTES[$i]}" ]]; then # display note
			   echo " $i - ${NOTES[$i]}"
		       else			# display empty folder
			   echo " $i - ............................................................"
		       fi
		   done
		   
		   echo "$HR"

		   ;;
	    [qQ] ) break;;
	    *    ) ;;		
	esac

    done
    
} # Return to Almanac()

Almanac_Notes
clear
