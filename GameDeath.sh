########################################################################
#                   Death and death-related functions                  #
#                                                                      #

#-----------------------------------------------------------------------
# $DEATH_* - named variables for types of Death :)
# Used: Death(), GX_Death()
#-----------------------------------------------------------------------
declare -r DEATH_FIGHT=0
declare -r DEATH_STARVATION=1

#-----------------------------------------------------------------------
# ResetStarvation()
# Reset STARVATION and restore lost ability (race-depended) after
# overcoming starvation
# Used: CheckForStarvation(), TavernRest()
#-----------------------------------------------------------------------
ResetStarvation() {
    if (( STARVATION >= 8 )) ; then
	case "$CHAR_RACE" in
	    1 | 3 ) (( STRENGTH++ ));
		    # echo "+1 STRENGTH: You restore your body to healthy condition (STRENGTH: $STRENGTH)" ;;
		    Echo "You restore your body to healthy condition" "[+1 STRENGTH]" ;;
	    2 | 4 ) (( ACCURACY++ ));
		    # echo "+1 ACCURACY: You restore your body to healthy condition (ACCURACY: $ACCURACY)" ;;
		    Echo "You restore your body to healthy condition" "[+1 ACCURACY]" ;;
	    *     ) Die "BUG in ResetStarvation() with \$CHAR_RACE >>>${CHAR_RACE}<<<" ;;
	esac
    fi
    STARVATION=0
    read -sn 1
}

#-----------------------------------------------------------------------
# CheckForStarvation()
# Food check
# Used: NewSector()
# TODO: not check for food at the 1st turn ??? Yes, skip it the 1st round, like NODICE
# TODO: make lesser sleep after successful check
#-----------------------------------------------------------------------
CheckForStarvation(){
    if (( $(bc <<< "${CHAR_FOOD} > 0") )) ; then
	CHAR_FOOD=$( bc <<< "${CHAR_FOOD} - 0.25" )
	Echo "You eat from your stock: $CHAR_FOOD remaining .." "[-.25 FOOD]"
	echo 			# empty line
	((STARVATION)) && ResetStarvation
    else
	((STARVATION++))	
	# Starvation penalty -5HP per turn
	local PROMPT="You're starving on the $(Ordial "${STARVATION}") "
	case "$STARVATION" in
	    1 )  PROMPT+="day and feeling hungry .."            ;;
	    2 )  PROMPT+="day and feeling weak .."              ;;
	    3 )  PROMPT+="day and feeling weaker .."            ;;
	    4 )  PROMPT+="day and feeling weaker and weaker .." ;;
	    15 ) PROMPT+="day, slowly starving to death .."     ;;
	    * )  PROMPT+="day, you're famished .."              ;;
	esac
	# echo "-5 HEALTH: Your body is suffering from starvation .. (HEALTH: $CHAR_HEALTH)"
	# Echo "Your body is suffering from starvation .. (HEALTH: $CHAR_HEALTH)" "[-5 HEALTH]"
	(( CHAR_HEALTH -= 5 )) 
	Echo "${PROMPT}" "[-5 HEALTH]"
	if (( STARVATION == 8 )); then # Extreme Starvation penalty
	    case "$CHAR_RACE" in
		1 | 3 ) (( STRENGTH-- ));
			# echo "-1 STRENGTH: You're slowly starving to death .. (STRENGTH: $STRENGTH)" ;;
			Echo "\nYou're slowly starving to death... (STRENGTH: $STRENGTH)" "[-1 STRENGTH]" ;;
		2 | 4 ) (( ACCURACY-- ));
			# echo "-1 ACCURACY: You're slowly starving to death .. (ACCURACY: $ACCURACY)" ;;
			Echo "\nYou're slowly starving to death... (ACCURACY: $ACCURACY)" "[-1 ACCURACY]" ;;
		*     ) Die "BUG in CheckForStarvation() with \$CHAR_RACE >>>${CHAR_RACE}<<<" ;;
	    esac
	fi
	if (( CHAR_HEALTH <= 0 )) ; then
	    Sleep 2.5
	    Death "$DEATH_STARVATION"
	fi
	Sleep 2 # Sleep penalty when starving (game goes slower)
    fi
    Sleep 1.5 # DEBUG     # sleep 4.5 # (too slow for play-testing:)
}


#-----------------------------------------------------------------------
# Death()
# Used: FightMode()
# Arguments: $TYPE_OF_DEATH(int)
#-----------------------------------------------------------------------
Death() {
    GX_Death "$1"
    echo " The $BIAMIN_DATE_STR:"
    echo " In such a short life, this sorry $CHAR_RACE_STR gained $CHAR_EXP Experience Points."
    local COUNTDOWN=20
    while ((COUNTDOWN--)); do
	echo -en "${CLEAR_LINE} We honor $CHAR with $COUNTDOWN secs silence."
    	read -sn 1 -t 1 && break
    done
    unset COUNTDOWN
    # Output example "400;Legolas;2;20;7;6;17th;Fore-Mystery;14th"
    echo "$CHAR_EXP;$CHAR;$CHAR_RACE;$CHAR_BATTLES;$CHAR_KILLS;$CHAR_ITEMS;$(Ordial $DAY);$(MonthString $MONTH);$(Ordial $YEAR)" >> "$HIGHSCORE"
    [[ -f "$CHARSHEET" ]] && rm -f "${CHARSHEET}" # A sense of loss is important for gameplay:)
    unset CHARSHEET CHAR CHAR_RACE CHAR_HEALTH CHAR_EXP CHAR_GPS SCENARIO CHAR_BATTLES CHAR_KILLS CHAR_ITEMS # Zombie fix     # Do we need it ????
    # Showing Highscore list here
    GX_HighScore  # HighScore()
    echo "" # empty line TODO fix it
    HighscoreRead 	# Show 10 highscore entries 
    echo ""  # empty line TODO fix it
    PressAnyKey 
    CleanUp
}

#                                                                      #
#                                                                      #
########################################################################

