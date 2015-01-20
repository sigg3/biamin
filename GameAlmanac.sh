########################################################################
#                               Almanac                                #
#                                                                      #

# TODO Adjust Almanac_Moon etc. for -1 Y positions (moved ASCII upwards, Jan 2015)

# GAME ACTION: USE INV_ALMANAC (MOON info, NOTES, MAIN info)
Almanac_Moon() { # Used in Almanac()
    GX_CharSheet 2 # Display GX Header with ALMANAC header
    # Substitute "NOTES" with MOON string in banner
    tput sc
    case "${MOON_STR[$MOON]}" in
	"Full Moon" | "New Moon" | "Old Moon" )                    MvAddStr 5 27 " ${MOON^^} "                  ;;
	"First Quarter" | "Third Quarter")                         MvAddStr 5 16 "THE MOON IS IN THE ${MOON^^}" ;;
	"Waning Gibbous" | "Growing Gibbous" | "Waning Crescent" ) MvAddStr 5 25 "${MOON^^}"                    ;;
	"Growing Crescent" )                                       MvAddStr 5 24 "${MOON^^}"                    ;;
    esac
    tput rc

    GX_Moon # Draw Moon

    # Add "picture frame" ASCII to Moon
    local VERTI_FRAME="||"
    local HORIZ_FRAME="_______________________"
    tput sc
    MvAddStr  9 50 "$HORIZ_FRAME"
    MvAddStr 10 48 ".j                       l." # spaces rem "Full Moon" dots..
    for framey in {11..18} ; do
	MvAddStr $framey 48 "$VERTI_FRAME"
	MvAddStr $framey 73 "$VERTI_FRAME"
    done
    tput cup 19 49 && echo -n "l" && echo -n "$HORIZ_FRAME" && echo "j"
    if [ "$MOON" = "Full Moon" ] ; then # Remove "shiny" dots ..
	MvAddStr 20 57 "        "
	MvAddStr 11 52 " "
	MvAddStr 11 71 " "
	MvAddStr 13 50 " "
	MvAddStr 17 50 " "
	MvAddStr 17 72 " "
    fi
    tput rc

    # TODO v3 Add Left-aligned text "box" (without borders)
    # Follow template:
    # 1. Name of phase
    # 2. Mythological significance (Gods etc.)
    # 3. Normal consequences
    #      - Wildlife & people ("What stirs under a $MOON"?)
    #        e.g. People can "go crazy" + werewolves under Full Moon
    # 4. Special consequences
    #       - Abilities (e.g. +1 LUCK)
    #       - Omens (bad fortune, death, starvation)
    # 5. Relation to Wandering Moon

    echo "$HR"
    read -sn 1
} # Return to Almanac()

Almanac_Notes() {
    GX_CharSheet 2 # Display GX banner with ALMANAC header
    tput sc
    MvAddStr 6 28 "N O T E S" # add"NOTES" subheader
    tput rc
    [ -z "$CHAR_NOTES" ] && echo -e " In the back of your almanac, there is a page reserved for Your Notes.\n There is only room for 10 lines, but you may erase obsolete information.\n"

    # TODO version 3
    # Add creation of mktemp CHAR.notes file that is referenced in $CHARSHEET
    # OR add NOTE0-NOTE9 in .sheet file.
    # Add opportunity to list (default action in Almanac_Notes), (A)dd or (E)rase notes.
    # Notes are "named" by numbers 0-9.
    # Notes may not exceed arbitrary ASCII-friendly length.
    # Notes must be superficially "cleaned" OR we can simply "list" them with cat <<"EOT".
    # 	Just deny user to input EOT :)
    echo "$HR"
    read -n 1 ### debug
} # Return to Almanac()



#-----------------------------------------------------------------------
# Almanac()
# Almanac (calendar).
# Used: DisplayCharsheet()
# TODO: when INV_ALMANAC=1 add NOTES 0-9 in charsheet.
#-----------------------------------------------------------------------
Almanac() {
    GX_CharSheet 2 # Display GX banner with ALMANAC header
    # Add DATE string subheader
    ALMANAC_SUB="$(WeekdayString $WEEKDAY) $(Ordial $DAY) of $(MonthString $MONTH)"
    tput sc
    MvAddStr 5 $((32 - ( $(Strlen "$ALMANAC_SUB") / 2) )) "$ALMANAC_SUB" # centered sub
    tput rc
    
    # Draw graphics
    cat <<"EOT"
                                                     ringday
           Mo Be Mi Ba Me Wa Ri              washday    o    moonday
                                                     o . . o
                                         melethday  o . x . o  brenday
                                                     o . . o
                                             braigday   o   midweek
                                                       .^.


EOT
    # Draw calendar
    MakeCalendar
    local CAL_Y=10 CAL_X=10 # tput initial coordinates for calendar
    tput sc
    for ((i = 0; ; i++)) ; do
	[[ "${CALENDAR[i]}" ]] || break
	MvAddStr $(($CAL_Y + $i)) $CAL_X "${CALENDAR[i]}"
    done
    tput rc

    # Add MONTH HEADER to CALENDAR
    tput sc
    local CAL_MONTH_HEADER=$(MonthString $MONTH)
    case $(Strlen $(MonthString "$MONTH")) in
	18 | 17 ) MvAddStr 8 13 "${CAL_MONTH_HEADER^}" ;;
	13      ) MvAddStr 8 14 "${CAL_MONTH_HEADER^}" ;;
	12 | 11 ) MvAddStr 8 15 "${CAL_MONTH_HEADER^}" ;;
	10 | 9  ) MvAddStr 8 16 "${CAL_MONTH_HEADER^}" ;;
	8       ) MvAddStr 8 17 "${CAL_MONTH_HEADER^}" ;;
    esac
    tput rc

    # Magnify WEEKDAY in HEPTOGRAM
    tput sc
    case $(WeekdayString "$WEEKDAY") in
	"Ringday (Holiday)" ) tput cup 8 53 ;;
	"Moonday" )   tput cup 9 61         ;;
	"Brenday" )   tput cup 11 63        ;;
	"Midweek" )   tput cup 13 60        ;;
	"Braigday" )  tput cup 13 45        ;;
	"Melethday" ) tput cup 11 41        ;;
	"Washday" )   tput cup 9 45         ;;
    esac
    ((WEEKDAY == 0))  && echo "RINGDAY" || echo "$(Toupper $(WeekdayString "$WEEKDAY"))"
    tput rc

    # Add MOON PHASE to HEPTOGRAM (bottom)
    tput sc
    case "$MOON" in
	0 | 4 )     MvAddStr 15 52 "$(Toupper ${MOON_STR[$MOON]})" ;;
	2 | 5 | 6 ) MvAddStr 15 50 "$(Toupper ${MOON_STR[$MOON]})" ;;
	1 | 3 | 7 ) MvAddStr 15 49 "$(Toupper ${MOON_STR[$MOON]})" ;;
    esac
    tput rc

    local TRIVIA_HEADER="$(WeekdayString "$WEEKDAY") - $(WeekdayTriviaShort "$WEEKDAY")" # Add DEFAULT Trivia header

    # Add PARTICULAR Trivia body
    # Database of significant constellations of dates, months and phases

    # CUSTOM Powerful combinations (may overrule the above AND have gameplay consequences)
    case "$DAY+$MONTH_REMINDER+$MOON" in
	"12+12+Full Moon" ) local TRIVIA1="Very holy" && local TRIVIA2="Yes, indeed. [+1 LUCK]" ;;
    esac
    # TODO IDEA These powerful combos can adjust things like luck, animal attacks etc.
    # TODO make custom trivia a separate function instead..

    if [ -z "$TRIVIA1" ] && [ -z "$TRIVIA2" ] ; then
	case "$(WeekdayString $WEEKDAY)+$MOON" in
	    "Moonday+Full Moon" ) local TRIVIA1="A Full Moon on Moon's day is considered a powerful combination." ;;
	    "Moonday+Waning Crescent" ) local TRIVIA1="An aging Crescent on Moon's Day makes evil magic more powerful." ;;
	    "Brenday+New Moon" )  local TRIVIA1="New Moon on Brenia's day means your courage will be needed." ;;
	    "Midweek+Old Moon" )  local TRIVIA1="An old moon midweek is the cause of imbalance. Show great care." ;;
	    "Ringday (Holiday)+New Moon" ) local TRIVIA1="New Moon on Ringday is a blessed combination. Be joyeful!" ;;
	    * ) local TRIVIA1=$(WeekdayTriviaLong "$WEEKDAY") ;;                     # display default info about the day
	esac

	# CUSTOM Month and Moon combinations (TRIVIA2)
	case "$(MonthString $MONTH)+$MOON" in
	    "Harvest Month+Growing Crescent" ) local TRIVIA2="A Growing Crescent in Harvest Month foretells a Good harvest!" ;;
	    "Ringorin+Old Moon" ) local TRIVIA2="An Old Moon in Ringorin means the ancestors are watching. Tread Careful." ;;
	    "Ringorin+New Moon" ) local TRIVIA2="A New Moon in Ringorin is a good omen for the future if the aim is true." ;;
	    "Marrsuckur+Waning Crescent" ) local TRIVIA2="A crescent declining during Marrow-sucker sometimes foretell Starvation." ;;
	    * ) local TRIVIA2="$(MonthString $MONTH) - $(MonthTrivia $MONTH)" ;; # display default info about the month
	esac
    fi

    # Output Trivia (mind the space before sentences)
    echo -e " $TRIVIA_HEADER\n $TRIVIA1\n\n $TRIVIA2"
    echo "$HR"
    read -sn 1 -p "$(MakePrompt '(R)eturn')" # TODO change/update when features are ready
    # TODO v. 3
    #    read -sn 1 -p "$(MakePrompt '(M)oon phase;(N)otes;(R)eturn')" ALM_OPT 2>&1
    #    case "$ALM_OPT" in
    #	 M | m ) Almanac_Moon ;;
    #	 N | n ) Almanac_Notes ;;
    #     esac
    #    unset ALM_OPT
} # Return to DisplayCharsheet()


#                                                                      #
#                                                                      #
########################################################################
