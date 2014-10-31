########################################################################
#                            Main game loop                            #
#                                                                      #

#-----------------------------------------------------------------------
# GPStoXY()
# Converts $GPS(string [A-R][1-15]) to $X(int [1-18]) $Y(int)
# Arguments: $CHAR_GPS(string [A-R][1-15])
# Used: NewSector()
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
	CheckForItem "$MAP_X" "$MAP_Y" # Look for treasure @ current GPS location  - Checks current section for treasure
	GX_Place "$SCENARIO"	
	if [[ "$NODICE" ]] ; then # Do not attack player at the first turn of after finding item
	    unset NODICE 
	else
	    CheckForFight "$SCENARIO" # Defined in FightMode.sh
	    GX_Place "$SCENARIO"
	fi

	CheckForStarvation # Food check
	# --WorldChangeCounter THEN Check for WORLD EVENT: Economy
	(( --WORLDCHANGE_COUNTDOWN <= 0 )) && WorldChangeEconomy # Change economy if success

	while (true); do # GAME ACTIONS MENU BAR
	    GX_Place "$SCENARIO"
	    case "$SCENARIO" in # Determine promt
		T | C ) read -sn 1 -p "     (C)haracter    (R)est    (G)o into Town    (M)ap and Travel    (Q)uit" ACTION 2>&1;;
		H )     read -sn 1 -p "     (C)haracter     (B)ulletin     (R)est     (M)ap and Travel     (Q)uit" ACTION 2>&1;;
		* )     read -sn 1 -p "        (C)haracter        (R)est        (M)ap and Travel        (Q)uit"    ACTION 2>&1;;
	    esac

	    case "$ACTION" in
		c | C ) DisplayCharsheet ;;
		r | R ) Rest  "$SCENARIO";;     # Player may be attacked during the rest :)
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

