########################################################################
#                            Main game loop                            #
#                                                                      #

#-----------------------------------------------------------------------
# GPStoXY()
# Converts $GPS(string [A-R][1-15]) to $X(int [1-18]) $Y(int)
# Arguments: $CHAR_GPS(string [A-R][1-15])
# Used: NewSector(), HotzonesDistribute()
#-----------------------------------------------------------------------
GPStoXY() {
    awk '{
          print index("ABCDEFGHIJKLMNOPQR", substr($0, 1 ,1));
          print substr($0, 2);
         }' <<< "$1"
}

#-----------------------------------------------------------------------
# XYtoGPS()
# Converts $X(int [1-18]) $Y(int) to $GPS(string [A-R][1-15])
# Arguments: $X(int) $Y(int)
# Used: MapNav()
#-----------------------------------------------------------------------
XYtoGPS() {
    awk '{ print substr("ABCDEFGHIJKLMNOPQR", $1, 1) $2; }' <<< "$1 $2"
}

#-----------------------------------------------------------------------
# GX_Map()
# Display map and ItemToSee if player have GiftOfSight and haven't all
# items
# Used: MapNav()
#-----------------------------------------------------------------------
GX_Map() {
    local ITEM2C_Y=0 ITEM2C_X=0 # Lazy fix for awk - it falls when see undefined variable #kstn
    # Check for Gift of Sight. Show ONLY the NEXT item viz. "Item to see" (ITEM2C).
    # Remember, the player won't necessarily find items in HOTZONE array's sequence.
    # Retrieve item map positions e.g. 1-15 >> X=1 Y=15. There always will be item in HOTZONE[0]!
    HaveItem "$GIFT_OF_SIGHT" && ((CHAR_ITEMS < MAX_ITEMS)) && read -r "ITEM2C_X" "ITEM2C_Y" <<< $(GPStoXY "${HOTZONE[0]}")

    clear
    awk 'BEGIN { FS = "   " ; OFS = "   "; }
    { # place "o" (player) on map
      if (NR == '$(( MAP_Y + 2 ))') {  # lazy fix for ASCII borders
         if ('$MAP_X' == 18 ) { $'$(( MAP_X + 1 ))'="o ("; }
         else                 { $'$(( MAP_X + 1 ))'="o";   } 
         }
      # if player has Gift-Of-Sight and not all items are found
      if ( '${CHAR_ITEMS}' > 0 && '${CHAR_ITEMS}' < 8) {
         # place ITEM2C on map 
         # ITEM2C_Y+2 and ITEM2C_X+1 - fix for boards
 	 if (NR == '$(( ITEM2C_Y + 2 ))') {
            if ( '$ITEM2C_X' == 18 ) { $'$(( ITEM2C_X + 1 ))'="~ ("; }
            else                     { $'$(( ITEM2C_X + 1 ))'="~";   } 
            }
         }
      # All color on map sets here
      if ('${COLOR}' == 1 ) {
         # Terminal color scheme bugfix
         if ( NR == 1 ) { gsub(/^/, "'$(printf "%s" "${RESET}")'"); } 
         # colorise "o" (player) and "~" (ITEM2C)
	 if ( NR > 2 && NR < 19 ) {
 	    gsub(/~/, "'$(printf "%s" "${YELLOW}~${RESET}")'")
	    gsub(/o/, "'$(printf "%s" "${YELLOW}o${RESET}")'")
	    }
         }
      print; }' <<< "$MAP"
}

#-----------------------------------------------------------------------
# MapNav()
# Game action: show map and move or move directly
# Arguments: $DESTINATION(string)
# Used: NewSector()
#-----------------------------------------------------------------------
MapNav() { 
    if [[ "$1" == "m" || "$1" == "M" ]] ; then	# If player want to see the map
	GX_Map
	# If COLOR==0, YELLOW and RESET =="" so string'll be without any colors
	echo -e " ${YELLOW}o ${CHAR}${RESET} is currently in $CHAR_GPS ($PLACE)\n$HR" # PLACE var defined in GX_Place()
	read -sn 1 -p " I want to go  (W) North  (A) West  (S)outh  (D) East  (Q)uit :  " DEST 2>&1
    else  # The player did NOT toggle map, just moved without looking from NewSector()..
	DEST="$1"
	GX_Place "$SCENARIO"    # Shows the _current_ scenario scene, not the destination's.
    fi

    case "$DEST" in # Fix for 80x24. Dirty but better than nothing #kstn
	w | W | n | N ) echo -n "You go North"; # Going North (Reversed: Y-1)
	    (( MAP_Y != 1  )) && (( MAP_Y-- )) || echo -en "${CLEAR_LINE}You wanted to visit Santa, but walked in a circle.." ;;
	d | D | e | E ) echo -n "You go East" # Going East (X+1)
	    (( MAP_X != 18 )) && (( MAP_X++ )) || echo -en "${CLEAR_LINE}You tried to go East of the map, but walked in a circle.." ;;
	s | S ) echo -n "You go South" # Going South (Reversed: Y+1)
	    (( MAP_Y != 15 )) && (( MAP_Y++ )) || echo -en "${CLEAR_LINE}You tried to go someplace warm, but walked in a circle.." ;; 
	a | A ) echo -n "You go West" # Going West (X-1)
	    (( MAP_X != 1  )) && (( MAP_X-- )) || echo -en "${CLEAR_LINE}You tried to go West of the map, but walked in a circle.." ;;
	q | Q ) CleanUp ;; # Save and exit
	* ) echo -n "Loitering.."
    esac
    CHAR_GPS=$(XYtoGPS "$MAP_X" "$MAP_Y") # Translate MAP_X numeric back to A-R
    sleep 1.5 # Merged with sleep from 'case "$DEST"' section
}

#-----------------------------------------------------------------------
# NewSector()
# Main game loop
# Used in runtime section
#-----------------------------------------------------------------------
NewSector() { 
    while (true); do  # While (player-is-alive) :) 
	((TURN++)) # Nev turn, new date
	DateFromTurn # Get year, month, day, weekday
	read -r MAP_X MAP_Y <<< $(GPStoXY "$CHAR_GPS") # Fixes LOCATION in CHAR_GPS "A1" to a place on the MapNav "X1,Y1"
	SCENARIO=$(awk '{ if ( NR == '$((MAP_Y+2))') { print $'$((MAP_X+2))'; }}' <<< "$MAP" ) # MAP_Y+2 MAP_X+2 - padding for borders
	CheckForItem "$CHAR_GPS" # Look for treasure @ current GPS location  - Checks current section for treasure
	GX_Place "$SCENARIO"	
	if [[ "$NODICE" ]] ; then # Do not attack player at the first turn of after finding item
	    unset NODICE 
	else
	    CheckForFight "$SCENARIO" # Defined in FightMode.sh
	    GX_Place "$SCENARIO"
	fi

	CheckForStarvation         # Food check
	CheckForWorldChangeEconomy # Change economy if success

	while (true); do # GAME ACTIONS MENU BAR
	    GX_Place "$SCENARIO"
	    case "$SCENARIO" in # Determine promt
		T | C ) echo -n "     (C)haracter    (R)est    (G)o into Town    (M)ap and Travel    (Q)uit" ;;
		H )     echo -n "     (C)haracter     (B)ulletin     (R)est     (M)ap and Travel     (Q)uit" ;;
		* )     echo -n "        (C)haracter        (R)est        (M)ap and Travel        (Q)uit"    ;;
	    esac
	    ACTION=$(Read)	# Read only one symbol
	    case "$ACTION" in
		c | C ) DisplayCharsheet ;;
		r | R ) Rest "$SCENARIO";;      # Player may be attacked during the rest :)
		q | Q ) CleanUp ;;              # Leaving the realm of magic behind ....
		b | B ) [[ "$SCENARIO" -eq "H" ]] && GX_Bulletin "$BBSMSG" ;;
		g | G ) [[ "$SCENARIO" -eq "T" || "$SCENARIO" -eq "C" ]] && GoIntoTown ;;
		* ) MapNav "$ACTION"; break ;;	# Go to Map then move or move directly (if not WASD, then loitering :)
	    esac
	done
    done
}

#                                                                      #
#                                                                      #
########################################################################

