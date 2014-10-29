########################################################################
#                               Almanac                                #
#                                                                      #


# GAME ACTION: USE ALMANAC (MOON info, NOTES, MAIN info)
Almanac_Moon() { # Used in Almanac()
    GX_CharSheet 2 # Display GX Header with ALMANAC header
    # Substitute "NOTES" with MOON string in banner
    tput sc
    case "$MOON" in
	"Full Moon" | "New Moon" | "Old Moon" )                    MvAddStr 6 27 " ${MOON^^} "                  ;;
	"First Quarter" | "Third Quarter")                         MvAddStr 6 16 "THE MOON IS IN THE ${MOON^^}" ;;
	"Waning Gibbous" | "Growing Gibbous" | "Waning Crescent" ) MvAddStr 6 25 "${MOON^^}"                    ;;
	"Growing Crescent" )                                       MvAddStr 6 24 "${MOON^^}"                    ;;
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

    # TODO Add Left-aligned text "box" (without borders)
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

    # TODO
    # Add creation of mktemp CHAR.notes file that is referenced in $CHARSHEET
    # OR add NOTE0-NOTE9 in .sheet file.
    # Add opportunity to list (default action in Almanac_Notes), (A)dd or (E)rase notes.
    # Notes are "named" by numbers 0-9.
    # Notes may not exceed arbitrary ASCII-friendly length.
    # Notes must be superficially "cleaned" OR we can simply "list" them with cat <<"EOT".
    # 	Just deny user to input EOT :)
    echo "$HR"
} # Return to Almanac()


Almanac() { # Almanac (calendar). Used in DisplayCharsheet() #FIX_DATE !!!
    # TODO The Almanac must be "unlocked" in gameplay, e.g. bought from Merchant. This is random (20% chance he has one)
    # TODO Add ALMANAC=0 in default charsheets
    # TODO When Almanac is found ALMANAC=1 is saved.
    # TODO when ALMANAC=1 add NOTES 0-9 in charsheet.

    GX_CharSheet 2 # Display GX banner with ALMANAC header
    # Add DATE string subheader
    ((WEEKDAY_NUM == 0)) && local ALMANAC_SUB="Ringday $DAY of $MONTH" || local ALMANAC_SUB="$(WeekdayString $WEEKDAY_NUM) $DAY of $MONTH"
    tput sc
    case $(Strlen "$ALMANAC_SUB") in
	35 | 34 ) MvAddStr 6 15 "$ALMANAC_SUB" ;;
	33 | 32 ) MvAddStr 6 16 "$ALMANAC_SUB" ;;
	31 | 30 ) MvAddStr 6 17 "$ALMANAC_SUB" ;;
	29 | 28 ) MvAddStr 6 18 "$ALMANAC_SUB" ;;
	27 | 26 ) MvAddStr 6 19 "$ALMANAC_SUB" ;;
	25 | 24 ) MvAddStr 6 20 "$ALMANAC_SUB" ;;
    esac 
    tput rc

    # Calculate which day the first of the month is
    # Source: en.wikipedia.org/wiki/Determination_of_the_day_of_the_week
    case "$MONTH_NUM" in # month table (without leap years) # add _REMAINDER to DateFromTurn()
	1 | 10 )     local FIMON=0 ;;
	2 | 3 | 11 ) local FIMON=3 ;;
	4 | 7 )      local FIMON=6 ;;
	5 )          local FIMON=1 ;;
	6 )          local FIMON=4 ;;
	8 )          local FIMON=2 ;;
	9 | 12 )     local FIMON=5 ;;
    esac

    case $(bc <<< "$YEAR % 100") in # last 2 of year
	00 | 06 | 17 | 23 | 28 | 34 | 45 | 51 | 56 | 62 | 73 | 79 | 84 | 90 )      local FIYEA=0 ;;
	01 | 07 | 12 | 18 | 29 | 35 | 40 | 46 | 57 | 63 | 68 | 74 | 85 | 91 | 96 ) local FIYEA=1 ;;
	02 | 13 | 19 | 24 | 30 | 41 | 47 | 52 | 58 | 69 | 75 | 80 | 86 | 97 )      local FIYEA=2 ;;
	03 | 08 | 14 | 25 | 31 | 36 | 42 | 53 | 59 | 64 | 70 | 81 | 87 | 92 | 98 ) local FIYEA=3 ;;
	09 | 15 | 20 | 26 | 37 | 43 | 48 | 54 | 65 | 71 | 76 | 82 | 93 | 99 )      local FIYEA=4 ;;
	04 | 10 | 21 | 27 | 32 | 38 | 49 | 55 | 60 | 66 | 77 | 83 | 88 | 94 )      local FIYEA=5 ;;
	05 | 11 | 16 | 22 | 33 | 39 | 44 | 50 | 61 | 67 | 72 | 78 | 89 | 95 )      local FIYEA=6 ;;
    esac

    case "$CENTURY" in # centuries
         90 | 400 |  800 | 1200 | 1600 | 2000 ) local FICEN=6 ;; # way too big :P
	100 | 500 |  900 | 1300 | 1700 )        local FICEN=4 ;; # TODO: Trim it
	200 | 600 | 1000 | 1400 | 1800 )        local FICEN=2 ;; # This table
	300 | 700 | 1100 | 1500 | 1900 )        local FICEN=0 ;; # is currently

    esac

    # LEGEND: d+m+y+(y/4)+c mod 7
    # If the result is 0, the date was a Ringday (Sunday), 1 Moonday (Monday) etc.
    FIRSTDAY=$(bc <<< "(1 + $FIMON + $FIYEA + ($FIYEA/4) + $FICEN) % 7")
    # DRAW CALENDAR
    cat <<"EOT"
                                                     ringday
           Mo Be Mi Ba Me Wa Ri              washday    o    moonday  
                                                     o . . o
                                         melethday  o . x . o  brenday
                                                     o . . o
                                             braigday   o   midweek
                                                       .^.

EOT

    # DRAWING CALENDAR
    #    local WEEKDAY_NUM=$FIRSTDAY
    local MONTH_LENGTH=$(MonthLength "$MONTH_NUM")
    local ARRAY=()
    local COUNT=0    

    SPACES=$(( (FIRSTDAY + 6) % 7 ))
    while ((SPACES--)); do 
	ARRAY[((COUNT))]+="   ";
    done

    for i in $(seq 1 "$MONTH_LENGTH") ; do
	ARRAY[((COUNT))]+=$(printf '%2s ' $i;)
	[[ $(awk '{print length;}' <<< "${ARRAY[$COUNT]}") -eq 21 ]] && ((COUNT++));
    done

    tput sc
    COUNT=0
    local YPOS=11
    while (true) ; do
	tput cup $YPOS 11 
	printf "%s\n" "${ARRAY[$COUNT]}";
	[[ ${ARRAY[((++COUNT))]} ]] || break
	(( YPOS++ ))
    done
    tput rc
    # DONE DRAVING CALENDAR

    tput sc # save cursor pos
    # local YPOS=11
    # local MTYPE=$(MonthLength "$MONTH_NUM")
    # (( DAY_NUM <= 9 )) && local CALDATE="_$DAY_NUM" || local CALDATE="$DAY_NUM"
    # while (( YPOS <= 16 )) ; do
    # 	local CALKEY="$FIRSTDAY-$YPOS-$MTYPE"
    # 	tput cup $YPOS 11
    # 	case "$CALKEY" in                                                          # Month starts on $FIRSTDAY
    # 	    "0-11-31" | "0-11-30" | "0-11-28" ) local CALSTR="                  _1" ;; # Ringday
    # 	    "0-12-31" | "0-12-30" | "0-12-28" ) local CALSTR="_2 _3 _4 _5 _6 _7 _8" ;;
    # 	    "0-13-31" | "0-13-30" | "0-13-28" ) local CALSTR="_9 10 11 12 13 14 15" ;;
    # 	    "0-14-31" | "0-14-30" | "0-14-28" ) local CALSTR="16 17 18 19 20 21 22" ;;
    # 	    "0-15-28" )                         local CALSTR="23 24 25 26 27 28"    ;;
    # 	    "0-15-31" | "0-15-30" )             local CALSTR="23 24 25 26 27 28 29" ;;
    # 	    "0-16-30" )                         local CALSTR="30"                   ;;
    # 	    "0-16-31" )                         local CALSTR="30 31"                ;;
    # 	    "1-11-31" | "1-11-30" | "1-11-28")  local CALSTR="_1 _2 _3 _4 _5 _6 _7" ;; # Moonday
    # 	    "1-12-31" | "1-12-30" | "1-12-28")  local CALSTR="_8 _9 10 11 12 13 14" ;;
    # 	    "1-13-31" | "1-13-30" | "1-13-28")  local CALSTR="15 16 17 18 19 20 21" ;;
    # 	    "1-14-31" | "1-14-30" | "1-14-28")  local CALSTR="22 23 24 25 26 27 28" ;;
    # 	    "1-15-30" )                         local CALSTR="29 30"                ;;
    # 	    "1-15-31" )                         local CALSTR="29 30 31"             ;;
    # 	    "2-11-31" | "2-11-30" | "2-11-28" ) local CALSTR="   _1 _2 _3 _4 _5 _6" ;; # Brenday
    # 	    "2-12-31" | "2-12-30" | "2-12-28" ) local CALSTR="_7 _8 _9 10 11 12 13" ;;
    # 	    "2-13-31" | "2-13-30" | "2-13-28" ) local CALSTR="14 15 16 17 18 19 20" ;;
    # 	    "2-14-31" | "2-14-30" | "2-14-28" ) local CALSTR="21 22 23 24 25 26 27" ;;
    # 	    "2-15-28" )                         local CALSTR="28"                   ;;
    # 	    "2-15-30" )                         local CALSTR="28 29 30"             ;;
    # 	    "2-15-31" )                         local CALSTR="28 29 30 31"          ;;
    # 	    "3-11-31" | "3-11-30" | "3-11-28" ) local CALSTR="      _1 _2 _3 _4 _5" ;; # Midweek
    # 	    "3-12-31" | "3-12-30" | "3-12-28" ) local CALSTR="_6 _7 _8 _9 10 11 12" ;;
    # 	    "3-13-31" | "3-13-30" | "3-13-28" ) local CALSTR="13 14 15 16 17 18 19" ;;
    # 	    "3-14-31" | "3-14-30" | "3-14-28" ) local CALSTR="20 21 22 23 24 25 26" ;;
    # 	    "3-15-28" )                         local CALSTR="27 28"                ;;
    # 	    "3-15-30" )                         local CALSTR="27 28 29 30"          ;;
    # 	    "3-15-31" )                         local CALSTR="27 28 29 30 31"       ;;
    # 	    "4-11-31" | "4-11-30" | "4-11-28" ) local CALSTR="         _1 _2 _3 _4" ;; # Braigday
    # 	    "4-12-31" | "4-12-30" | "4-12-28" ) local CALSTR="_5 _6 _7 _8 _9 10 11" ;;
    # 	    "4-13-31" | "4-13-30" | "4-13-28" ) local CALSTR="12 13 14 15 16 17 18" ;;
    # 	    "4-14-31" | "4-14-30" | "4-14-28" ) local CALSTR="19 20 21 22 23 24 25" ;;
    # 	    "4-15-28" )                         local CALSTR="26 27 28"             ;;
    # 	    "4-15-30" )                         local CALSTR="26 27 28 29 30"       ;;
    # 	    "4-15-31" )                         local CALSTR="26 27 28 29 30 31"    ;;
    # 	    "5-11-31" | "5-11-30" | "5-11-28" ) local CALSTR="            _1 _2 _3" ;; # Melethday
    # 	    "5-12-31" | "5-12-30" | "5-12-28" ) local CALSTR="_4 _5 _6 _7 _8 _9 10" ;;
    # 	    "5-13-31" | "5-13-30" | "5-13-28" ) local CALSTR="11 12 13 14 15 16 17" ;;
    # 	    "5-14-31" | "5-14-30" | "5-14-28" ) local CALSTR="18 19 20 21 22 23 24" ;;
    # 	    "5-15-28" )                         local CALSTR="25 26 27 28"          ;;
    # 	    "5-15-30" )                         local CALSTR="25 26 27 28 29 30"    ;;
    # 	    "5-15-31" )                         local CALSTR="25 26 27 28 29 30 31" ;;
    # 	    "6-11-31" | "6-11-30" | "6-11-28" ) local CALSTR="               _1 _2" ;; # Washday
    # 	    "6-12-31" | "6-12-30" | "6-12-28" ) local CALSTR="_3 _4 _5 _6 _7 _8 _9" ;;
    # 	    "6-13-31" | "6-13-30" | "6-13-28" ) local CALSTR="10 11 12 13 14 15 16" ;;
    # 	    "6-14-31" | "6-14-30" | "6-14-28" ) local CALSTR="17 18 19 20 21 22 23" ;;
    # 	    "6-15-28" )                         local CALSTR="24 25 26 27 28"       ;;
    # 	    "6-15-31" | "6-15-30" )             local CALSTR="24 25 26 27 28 29 30" ;;
    # 	    "6-16-31" )                         local CALSTR="31"                   ;;
    # 	    * ) local CALSTR="X" ;; # Don't draw anything
    #  esac
    #  if [ "$CALSTR" != "X" ] ; then
    # 	 if (( DAY_NUM <= 9 )) ; then # TODO check compatibility of grey bg color here..
    # 	     echo "$CALSTR" | sed ''/"$CALDATE"/s//$(printf "\e[100m_$DAY_NUM\e[0m")/'' | tr '_' ' '
    # 	 else
    # 	     echo "$CALSTR" | sed ''/"$CALDATE"/s//$(printf "\e[100m$DAY_NUM\e[0m")/'' | tr '_' ' '
    # 	 fi
    #  fi
    #  (( YPOS++ ))
    #  done

     tput rc

     # Add MONTH HEADER to CALENDAR
     tput sc
     case $(Strlen $(MonthString "$MONTH_NUM")) in
	 18 | 17 ) MvAddStr 9 13 "${MONTH^}" ;;
	 13      ) MvAddStr 9 14 "${MONTH^}" ;;
	 12 | 11 ) MvAddStr 9 15 "${MONTH^}" ;;
	 10 | 9  ) MvAddStr 9 16 "${MONTH^}" ;;
	 8       ) MvAddStr 9 17 "${MONTH^}" ;;
     esac 
     tput rc

     # Magnify WEEKDAY in HEPTOGRAM
     tput sc
     case $(WeekdayString "$WEEKDAY_NUM") in
	 "Ringday (Holiday)" ) tput cup 9 53 ;;
	 "Moonday" ) tput cup 10 61          ;;
	 "Brenday" ) tput cup 12 63          ;;
	 "Midweek" ) tput cup 14 60          ;;
	 "Braigday" )  tput cup 14 45        ;;
	 "Melethday" ) tput cup 12 41        ;;
	 "Washday" ) tput cup 10 45          ;;
     esac
     ((WEEKDAY_NUM == 0))  && echo "RINGDAY" || echo "$(Toupper $(WeekdayString "$WEEKDAY_NUM"))"
     tput rc

     # Add MOON PHASE to HEPTOGRAM (bottom)
     tput sc
     case "$MOON" in
	 "Old Moon" | "New Moon" | "Full Moon" )                      MvAddStr 16 52 "$(Toupper $MOON)" ;;
	 "First Quarter" | "Third Quarter" | "Waning Gibbous" )       MvAddStr 16 50 "$(Toupper $MOON)" ;;
	 "Growing Gibbous" | "Waning Crescent" | "Growing Crescent" ) MvAddStr 16 49 "$(Toupper $MOON)" ;;
     esac
     tput rc

     local TRIVIA_HEADER="$(WeekdayString "$WEEKDAY_NUM") - $(WeekdayTriviaShort "$WEEKDAY_NUM")" # Add DEFAULT Trivia header

     # Add PARTICULAR Trivia body
     # Database of significant constellations of dates, months and phases

     # CUSTOM Powerful combinations (may overrule the above AND have gameplay consequences)
     case "$DAY+$MONTH_REMINDER+$MOON" in
	 "12+12+Full Moon" ) local TRIVIA1="Very holy" && local TRIVIA2="Yes, indeed. [+1 LUCK]" ;;
     esac
     # TODO IDEA These powerful combos can adjust things like luck, animal attacks etc.
     # TODO make custom trivia a separate function instead..

     if [ -z "$TRIVIA1" ] && [ -z "$TRIVIA2" ] ; then
	 case "$(WeekdayString $WEEKDAY_NUM)+$MOON" in
	     "Moonday+Full Moon" ) local TRIVIA1="A Full Moon on Moon's day is considered a powerful combination." ;;
	     "Moonday+Waning Crescent" ) local TRIVIA1="An aging Crescent on Moon's Day makes evil magic more powerful." ;;
	     "Brenday+New Moon" )  local TRIVIA1="New Moon on Brenia's day means your courage will be needed." ;;
	     "Midweek+Old Moon" )  local TRIVIA1="An old moon midweek is the cause of imbalance. Show great care." ;;
	     "Ringday (Holiday)+New Moon" ) local TRIVIA1="New Moon on Ringday is a blessed combination. Be joyeful!" ;;
	     * ) local TRIVIA1=$(WeekdayTriviaLong "$WEEKDAY_NUM") ;;                     # display default info about the day
	 esac

	 # CUSTOM Month and Moon combinations (TRIVIA2)
	 case "$(MonthString $MONTH_NUM)+$MOON" in
	     "Harvest Month+Growing Crescent" ) local TRIVIA2="A Growing Crescent in Harvest Month foretells a Good harvest!" ;;
	     "Ringorin+Old Moon" ) local TRIVIA2="An Old Moon in Ringorin means the ancestors are watching. Tread Careful." ;;
	     "Ringorin+New Moon" ) local TRIVIA2="A New Moon in Ringorin is a good omen for the future if the aim is true." ;;
	     "Marrsuckur+Waning Crescent" ) local TRIVIA2="A crescent declining during Marrow-sucker sometimes foretell Starvation." ;;
	     * ) local TRIVIA2="$(MonthString $MONTH_NUM) - $(MonthTrivia $MONTH_NUM)" ;; # display default info about the month
	 esac
     fi

     # Output Trivia (mind the space before sentences)
     echo -e " $TRIVIA_HEADER\n $TRIVIA1\n\n $TRIVIA2"
     echo "$HR"
     read -sn 1 -p "$(MakePrompt '(M)oon phase;(N)otes;(R)eturn')" ALM_OPT 2>&1
     case "$ALM_OPT" in
	 M | m ) Almanac_Moon ;;
	 N | n ) Almanac_Notes ;;
     esac
     unset ALM_OPT
 } # Return to DisplayCharsheet()


#                                                                      #
#                                                                      #
########################################################################

