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
    awk '{ print index("ABCDEFGHIJKLMNOPQR", substr($0, 1 ,1));
           print substr($0, 2); }' <<< "$1"
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
    local DEST
    read -r MAP_X MAP_Y <<< $(GPStoXY "$CHAR_GPS") # Fixes LOCATION in CHAR_GPS "A1" to a place on the MapNav "X1,Y1"
    case "$1" in
	m | M ) GX_Map ;                           # If player want to see the map
	                                           # If COLOR==0, YELLOW and RESET =="" so string'll be without any colors
	    echo -e " ${YELLOW}o ${CHAR}${RESET} is currently in $CHAR_GPS ($PLACE)\n$HR" ; # PLACE var defined in GX_Place()
	    echo -n " I want to go  (W) North  (A) West  (S)outh  (D) East  (Q)uit :  " ;
	    DEST=$(Read);;
	* ) DEST="$1" ;                            # The player did NOT toggle map, just moved without looking from NewSector()..
	    GX_Place "$SCENARIO" ;                 # Shows the _current_ scenario scene, not the destination's.
    esac

    case "$DEST" in                                # Fix for 80x24. Dirty but better than nothing #kstn
	[wWnN] ) echo -n "You go North";           # Going North (Reversed: Y-1)
		 ((MAP_Y != 1 )) && ((MAP_Y--)) || echo -en "${CLEAR_LINE}You wanted to visit Santa, but walked in a circle.." ;;
	[dDeE] ) echo -n "You go East"             # Going East (X+1)
		 ((MAP_X != 18)) && ((MAP_X++)) || echo -en "${CLEAR_LINE}You tried to go East of the map, but walked in a circle.." ;;
	[sS]   ) echo -n "You go South"            # Going South (Reversed: Y+1)
		 ((MAP_Y != 15)) && ((MAP_Y++)) || echo -en "${CLEAR_LINE}You tried to go someplace warm, but walked in a circle.." ;;
	[aA]   ) echo -n "You go West"             # Going West (X-1)
		 ((MAP_X != 1 )) && ((MAP_X--)) || echo -en "${CLEAR_LINE}You tried to go West of the map, but walked in a circle.." ;;
	[qQ]   ) CleanUp ;;                        # Save and exit
	*      ) echo -n "Loitering.."
    esac
    CHAR_GPS=$(XYtoGPS "$MAP_X" "$MAP_Y")          # Translate MAP_X numeric back to A-R and store
    Sleep 1.5
}

#-----------------------------------------------------------------------
# NewSector_GetScenario()
# Get scenario char at current GPS
# Arguments: $CHAR_GPS(string[A-R][1-15])
#-----------------------------------------------------------------------
NewSector_GetScenario() {
    read -r MAP_X MAP_Y <<< $(GPStoXY "$1")                                   # Fixes LOCATION in CHAR_GPS "A1" to a place on the MapNav "X1,Y1"
    awk '{ if ( NR == '$((MAP_Y+2))') { print $'$((MAP_X+2))'; }}' <<< "$MAP" # MAP_Y+2 MAP_X+2 - padding for borders
}

#-----------------------------------------------------------------------
# NewTurn()
# Increase turn and set new date
# Used: NewSector(), TavernRest()
#-----------------------------------------------------------------------
NewTurn() {
    ((TURN++))   # Nev turn, new date
    DateFromTurn # Get year, month, day, weekday
}

#-----------------------------------------------------------------------
# NewSector()
# Main game loop
# Used in runtime section
#-----------------------------------------------------------------------
NewSector() {
    while (true); do                                          # While (player-is-alive) :)
	NewTurn                                               # Increase turn and set new date
	CheckForItem "$CHAR_GPS"                              # Look for treasure @ current GPS location
	SCENARIO=$(NewSector_GetScenario "$CHAR_GPS")         # Get scenario char at current GPS
	GX_Place "$SCENARIO"                                  # Display current $SCENARIO ASCII
	if [[ "$NODICE" ]] ; then                             # Do not attack player at the first turn of after finding item
	    unset NODICE                                      # Reset flag
	else
	    CheckForFight "$SCENARIO" || GX_Place "$SCENARIO" # Redraw $SCENARIO ASCII if there was fight
	fi
	CheckForStarvation                                    # Food check
	CheckForWorldChangeEconomy                            # Change economy if success

	while (true); do                                      # Secondary loop, at current $SCENARIO 
	    GX_Place "$SCENARIO"
	    case "$SCENARIO" in                               # Determine promt
		T | C ) echo -n "     (C)haracter    (R)est    (G)o into Town    (M)ap and Travel    (Q)uit" ;;
		H )     echo -n "     (C)haracter     (B)ulletin     (R)est     (M)ap and Travel     (Q)uit" ;;
		* )     echo -n "        (C)haracter        (R)est        (M)ap and Travel        (Q)uit"    ;;
	    esac
	    local ACTION=$(Read)	                      # Read only one symbol
	    case "$ACTION" in
		[cC] ) DisplayCharsheet ;;
		[rR] ) Rest "$SCENARIO";;                     # # Player may be attacked during the rest :)
		[qQ] ) CleanUp ;;                             # Leaving the realm of magic behind ....
		[bB] ) [[ "$SCENARIO" == "H" ]] && GX_Bulletin "$BBSMSG" ;;
		[gG] ) [[ "$SCENARIO" == "T" || "$SCENARIO" == "C" ]] && GoIntoTown ;;
		*    ) MapNav "$ACTION"; break ;;             # Go to Map then move or move directly (if not WASD, then loitering :)
	    esac
	done
    done
}

#                                                                      #
#                                                                      #
########################################################################

