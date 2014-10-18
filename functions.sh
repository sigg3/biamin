########################################################################
#                                                                      #
#                          1. FUNCTIONS                                #
#                    All program functions go here!                    #

Die() { echo -e "$1" && exit 1 ;}

Capitalize() { awk '{ print substr(toupper($0), 1,1) substr($0, 2); }' <<< "$*" ;} # Capitalize $1

Toupper() { awk '{ print toupper($0); }' <<< "$*" ;} # Convert $* to uppercase

Strlen() { awk '{print length($0);}' <<< "$*" ;} # Return lenght of string $*. "Strlen" is traditional name :)

MvAddStr() { tput cup "$1" "$2"; printf "%s" "$3"; } # move cursor to $1 $2 and print $3. "mvaddstr" is name similar function from ncurses.h

Ordial() { # Add postfix to $1 (NUMBER)
    grep -Eq '[^1]?1$'  <<< "$1" && echo "${1}st" && return 0
    grep -Eq '[^1]?2$'  <<< "$1" && echo "${1}nd" && return 0
    grep -Eq '[^1]?3$'  <<< "$1" && echo "${1}rd" && return 0
    grep -Eq '^[0-9]+$' <<< "$1" && echo "${1}th" && return 0
    Die "Bug in Ordial with ARG $1"
}

MakePrompt() { # Make centered to 79px promt from $@. Arguments should be separated by ';'
    awk '   BEGIN { FS =";" }
        {
            MAXLEN = 79;
            COUNT = NF; 
            for ( i=1; i<= NF; i++ ) { STRLEN += length($i); }
            if ( STRLEN > MAXLEN ) { exit 1 ; }
            SPACES = MAXLEN - STRLEN;
            REMAINDER = SPACES % (NF + 1 ) ;
            SPACER = (SPACES - REMAINDER ) / (NF + 1) ;
            if ( REMAINDER % 2  == 1 ) { REMAINDER -= 1 ; }
            SPACES_IN = REMAINDER / 2 ;
            while (SPACES_IN-- > 0 ) { INTRO = INTRO " "; }
            while (SPACER-- > 0 ) { SEPARATOR = SEPARATOR " " }
            STR = INTRO; 
            for ( i=1; i<=NF; i++ ) { STR = STR SEPARATOR $i; }
            STR = STR SEPARATOR INTRO
        }
        END { print STR; }' <<< "$@" || Die "Too long promt >>>$*<<<"
}

CleanUp() { # Used in MainMenu(), NewSector(),
    GX_BiaminTitle
    echo -e "\n$HR"
    if [[ "$FIGHTMODE" ]]; then #  -20 HP -20 EXP Penalty for exiting CTRL+C during battle!
	((CHAR_HEALTH -= 20))
    	((CHAR_EXP -=20))
    	echo -e "PENALTY for CTRL+Chickening out during battle: -20 HP -20 EXP\nHEALTH: $CHAR_HEALTH\tEXPERIENCE: $CHAR_EXP"
    fi
    [[ "$CHAR" ]] && SaveCurrentSheet # Don't try to save if we've nobody to save :)
    echo -e "\nLeaving the realm of magic behind ....\nPlease submit bugs and feedback at <$WEBURL>"
    exit 0
}
# PRE-CLEANUP tidying function for buggy custom maps
CustomMapError() { # Used in MapCreate(), GX_Place() and NewSector()
    local ERROR_MAP=$1
    clear
    echo "Whoops! There is an error with your map file!
Either it contains unknown characters or it uses incorrect whitespace.
Recognized characters are: x . T @ H C
Please run game with --map argument to create a new template as a guide.

What to do?
1) rename $ERROR_MAP to ${ERROR_MAP}.error or
2) delete template file CUSTOM.map (deletion is irrevocable)."
    read -n 1 -p "Please select 1 or 2: " MAP_CLEAN_OPTS 2>&1
    case "$MAP_CLEAN_OPTS" in
	1 ) mv "${ERROR_MAP}" "${ERROR_MAP}.error" ;
	    echo -e "\nCustom map file moved to ${ERROR_MAP}.error" ;
	    sleep 4 ;;
	2 ) rm -f "${ERROR_MAP}" ;
	    echo -e "\nCustom map deleted!" ;
	    sleep 4 ;;
	* ) Die "\nBad option! Quitting.." ;;
    esac
}

### DISPLAY MAP
GX_Map() { # Used in MapNav()
    local ITEM2C_Y=0 ITEM2C_X=0 # Lazy fix for awk - it falls when see undefined variable #kstn
    # Check for Gift of Sight. Show ONLY the NEXT item viz. "Item to see" (ITEM2C).
    # Remember, the player won't necessarily find items in HOTZONE array's sequence.
    # Retrieve item map positions e.g. 1-15 >> X=1 Y=15. There always will be item in HOTZONE[0]!
    [[ ((CHAR_ITEMS > 0)) && ((CHAR_ITEMS < 8)) ]] && IFS="-" read -r "ITEM2C_X" "ITEM2C_Y" <<< "${HOTZONE[0]}" 

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

# SAVE CHARSHEET
SaveCurrentSheet() { # Saves current game values to CHARSHEET file (overwriting)
    echo "CHARACTER: $CHAR
RACE: $CHAR_RACE
BATTLES: $CHAR_BATTLES
EXPERIENCE: $CHAR_EXP
LOCATION: $CHAR_GPS
HEALTH: $CHAR_HEALTH
ITEMS: $CHAR_ITEMS
KILLS: $CHAR_KILLS
HOME: $CHAR_HOME
GOLD: $CHAR_GOLD
TOBACCO: $CHAR_TOBACCO
FOOD: $CHAR_FOOD
BBSMSG: $BBSMSG
VAL_GOLD: $VAL_GOLD
VAL_TOBACCO: $VAL_TOBACCO
VAL_CHANGE: $VAL_CHANGE
STARVATION: $STARVATION
TURN: $TURN
ALMANAC: $ALMANAC" > "$CHARSHEET"
}

# CHAR SETUP

Intro() { # Used in BiaminSetup() . Intro function basically gets the game going
    SHORTNAME=$(Capitalize "$CHAR") # Create capitalized FIGHT CHAR name
    (( TURN == 0 )) && TodaysDate # Fetch today's date in Warhammer calendar (Used in DisplayCharsheet() and FightMode() )
    MapCreate          # Create session map in $MAP  
    HotzonesDistribute "$CHAR_ITEMS" # Place items randomly in map
    WORLDCHANGE_COUNTDOWN=0 # WorldChange Counter (0 or negative value allow changes)    
    # Create strings for economical situation..
    VAL_GOLD_STR=$( awk '{ printf "%4.2f", $0 }' <<< $VAL_GOLD )       # Usual printf is locale-depended - it cant work with '.' as delimiter when
    VAL_TOBACCO_STR=$( awk '{ printf "%4.2f", $0 }' <<< $VAL_TOBACCO ) # locale's delimiter is ',' (cyrillic locale for instance) #kstn
    WorldPriceFixing # Set all prices
    GX_Intro # With countdown
    NODICE=1 # Do not roll on first section after loading/starting a game in NewSector()
    NewSector
}



## WORLD EVENT functions

WorldPriceFixing() { # Used in WorldChangeEconomy() and Intro()
    local VAL_FOOD=1 # Why constant? Player eats .25/day, so it's always true that 1 FOOD = 4 turns.
    # Warning! Old-style echo used on purpose here. Otherwise bc gives "illegal char" due to \n CRs 
    PRICE_FxG=$( echo "scale=2;$VAL_FOOD/$VAL_GOLD" | bc )
    PRICE_FxT=$( echo "scale=2;$VAL_FOOD/$VAL_TOBACCO" | bc ) # Price of 1 Food in Tobacco
    PRICE_GxT=$( echo "scale=2;$VAL_GOLD/$VAL_TOBACCO" | bc )
    PRICE_GxF=$( echo "scale=2;$VAL_GOLD/$VAL_FOOD" | bc )    # Price of 1 Gold in Food
    PRICE_TxG=$( echo "scale=2;$VAL_TOBACCO/$VAL_GOLD" | bc )
    PRICE_TxF=$( echo "scale=2;$VAL_TOBACCO/$VAL_FOOD" | bc )
    # Items are arbitrarily priced & not set here, but the same logic IxG applies.
}

WorldChangeEconomy() {  # Used in NewSector()
    (( $(RollDice2 100) > 15 )) && return 0 # Roll to 15% chance for economic event transpiring or leave immediately
    BBSMSG=$(RollDice2 12) # = Number of possible scenarios (+ default 0) and Update BBSMSG
    
    case "$BBSMSG" in
    	# Econ '+'=Inflation, '-'=deflation | 1=Tobacco, 2=Gold | Severity 12=worst (0.25-3.00 change), 5=lesser (0.25-1.25 change)
    	1 )  local CHANGE="+"; local UNIT="Tobacco" ; RollDice 12 ;; # Wild Fire Threatens Tobacco (serious inflation)
    	2 )  local CHANGE="+"; local UNIT="Tobacco" ; RollDice 5  ;; # Hobbits on Strike (lesser inflation)
    	3 )  local CHANGE="-"; local UNIT="Tobacco" ; RollDice 12 ;; # Tobacco Overproduction (serious deflation)
    	4 )  local CHANGE="-"; local UNIT="Tobacco" ; RollDice 5  ;; # Tobacco Import Increase (lesser deflation)
    	5 )  local CHANGE="+"; local UNIT="Gold"    ; RollDice 12 ;; # Gold Demand Increases due to War (serious inflation)
    	6 )  local CHANGE="+"; local UNIT="Gold"    ; RollDice 5  ;; # Gold Required for New Fashion (lesser inflation)
    	7 )  local CHANGE="-"; local UNIT="Gold"    ; RollDice 12 ;; # New Promising Gold Vein (serious deflation)
    	8 )  local CHANGE="-"; local UNIT="Gold"    ; RollDice 5  ;; # Discovery of Artificial Gold Prices (lesser deflation)
    	9 )  local CHANGE="-"; local UNIT="Gold"    ; RollDice 4  ;; # Alchemists promise gold (lesser deflation)
    	10 ) local CHANGE="+"; local UNIT="Tobacco" ; RollDice 4  ;; # Water pipe fashion (lesser inflation)
    	11 ) local CHANGE="+"; local UNIT="Gold"    ; RollDice 10 ;; # King Bought Tracts of Land (serious inflation)
    	12 ) local CHANGE="-"; local UNIT="Tobacco" ; RollDice 10 ;; # Rumor of Tobacco Pestilence false (serious deflation)
    esac

    local FLUX=$( bc <<< "$DICE * $VAL_CHANGE" ) # Determine severity
    
    case "$UNIT" in # Which market is affected?
	"Tobacco" )  
	    VAL_TOBACCO=$( bc <<< "$VAL_TOBACCO $CHANGE $FLUX" ) ;     # How is tobacco affected?	    
	    (( $(bc <<< "$VAL_TOBACCO <= 0") )) && VAL_TOBACCO=0.25  ; # Adjusted for min 0.25 value
	    VAL_TOBACCO_STR=$( awk '{ printf "%4.2f", $0 }' <<< "$VAL_TOBACCO" ) ;; # Used in GX_Bulletin()
	"Gold"    )  
	    VAL_GOLD=$( bc <<< "$VAL_GOLD $CHANGE $FLUX" ) ;           # How is gold affected?
	    (( $(bc <<< "$VAL_GOLD <= 0") )) && VAL_GOLD=0.25	       # Adjusted for min 0.25 value
	    VAL_GOLD_STR=$( awk '{ printf "%4.2f", $0 }'  <<< "$VAL_GOLD" ) ;; # Used in GX_Bulletin()
	* ) Die "BUG in WorldChangeEconomy() with unit >>>${UNIT}<<< and scenario >>>${DICE}<<<" ;;
    esac
    WORLDCHANGE_COUNTDOWN=20 # Give the player a 20 turn break TODO Test how this works..
    SaveCurrentSheet         # Save world changes to charsheet # LAST!!!
    WorldPriceFixing         # Update all prices    
} # Return to NewSector()

# Other WorldChangeFUNCTIONs go here:)

################### MENU SYSTEM #################

MainMenu() {
    while (true) ; do # Forever, because we exit through CleanUp()
	GX_Banner 		
	read -sn 1 -p "$(MakePrompt '(P)lay;(L)oad game;(H)ighscore;(C)redits;(Q)uit')" TOPMENU_OPT 2>&1
	case "$TOPMENU_OPT" in
	    p | P ) GX_Banner ; 
 		read -p " Enter character name (case sensitive): " CHAR 2>&1 ;
		[[ "$CHAR" ]] && BiaminSetup;; # Do nothing if CHAR is empty
	    l | L ) LoadGame && BiaminSetup;; # Do nothing if CHAR is empty
	    h | H ) GX_HighScore ;	      # HighScore
		echo "";
		# Show 10 highscore entries or die if Highscore list is empty
		[[ -s "$HIGHSCORE" ]] && HighscoreRead || echo -e " The highscore list is unfortunately empty right now.\n You have to play some to get some!";
		echo "" ; # empty line TODO fix it
		read -sn 1 -p "$(MakePrompt 'Press the any key to go to (M)ain menu')" 2>&1 ;;
	    c | C ) GX_Credits ; # Credits
		read -sn 1 -p "$(MakePrompt '(H)owTo;(L)icense;(M)ain menu')" "CREDITS_OPT" 2>&1 ;
		case "$CREDITS_OPT" in
		    L | l ) License ;;
		    H | h ) GX_HowTo ;;
		esac ;;
	    q | Q ) CleanUp ;;
	esac
    done
}
# Highscore
HighscoreRead() { # Used in Announce() and HighScore()
    sort -g -r "$HIGHSCORE" -o "$HIGHSCORE"
    local HIGHSCORE_TMP=" #;Hero;EXP;Wins;Items;Entered History\n;"
    local i=1
    # Read values from highscore file (BashFAQ/001)
    while IFS=";" read -r highEXP highCHAR highRACE highBATTLES highKILLS highITEMS highDATE highMONTH highYEAR; do
	(( i > 10 )) && break	
	case "$highRACE" in
	    1 ) highRACE="Human" ;;
	    2 ) highRACE="Elf" ;;
	    3 ) highRACE="Dwarf" ;;
	    4 ) highRACE="Hobbit" ;;
	esac
	if [[ "$highMONTH" ]] ; then # fix for "Witching Day", etc
	    HIGHSCORE_TMP+=" $i.;$highCHAR the $highRACE;$highEXP;$highKILLS/$highBATTLES;$highITEMS/8;$highMONTH $highDATE ($highYEAR)\n"
	else
	    HIGHSCORE_TMP+=" $i.;$highCHAR the $highRACE;$highEXP;$highKILLS/$highBATTLES;$highITEMS/8;the $highDATE ($highYEAR)\n"
	fi
	((i++))
    done < "$HIGHSCORE"
    echo -e "$HIGHSCORE_TMP" | column -t -s ";" # Nice tabbed output!
    unset HIGHSCORE_TMP
}

PrepareLicense() { # gets licenses and concatenates into "LICENSE" in $GAMEDIR
    # TODO add option to use wget if systen hasn't curl (Debian for instance) -kstn
    # TODO I'm not sure. I was told to use curl because it has greater compatibility than wget..? - s3
    echo " Download GNU GPL Version 3 ..."
    GPL=$(curl -s "http://www.gnu.org/licenses/gpl-3.0.txt" || "") # I did not know we could do that :)
    echo " Download CC BY-NC-SA 4.0 ..."
    CC=$(curl -s "http://creativecommons.org/licenses/by-nc-sa/4.0/legalcode.txt" || "")
    if [[ $GPL && $CC ]] ; then 
	echo -e "\t\t   BACK IN A MINUTE BASH CODE LICENSE:\t\t\t(Q)uit\n
$HR
$GPL
\n$HR\n\n\t\t   BACK IN A MINUTE ARTWORK LICENSE:\n\n
$CC"  > "$GAMEDIR/LICENSE"
	echo " Licenses downloaded and concatenated!"
	sleep 1
	return 0
    else
	echo "Couldn't download license files :( Do you have Internet access?"
	sleep 1
	return 1
    fi
}
    
License() { # Used in Credits()
    # Displays license if present or runs PrepareLicense && then display it..
    GX_BiaminTitle
    if [[ ! -f "$GAMEDIR/LICENSE" ]]; then
	echo -e "\n License file currently missing in $GAMEDIR/ !"
	read -p " To DL licenses, about 60kB, type YES (requires internet access): " "DL_LICENSE_OPT" 2>&1
	case "$DL_LICENSE_OPT" in
	    YES ) PrepareLicense ;;
	    * )   echo -e "
Code License:\t<http://www.gnu.org/licenses/gpl-3.0.txt>
Art License:\t<http://creativecommons.org/licenses/by-nc-sa/4.0/legalcode.txt>
More info:\t<${WEBURL}about#license>
Press any key to go back to main menu!";
		read -sn 1;
		return 0;;
	esac
    fi
    [[ "$PAGER" ]] && "$PAGER" "$GAMEDIR/LICENSE" || { echo -e "\n License file available at $GAMEDIR/LICENSE" ; PressAnyKey ;} # ShowLicense()
}   # Return to Credits() 

LoadGame() { # Used in MainMenu()
    local SHEETS FILES i=0 LIMIT=9 OFFSET=0 NUM=0 a # Declare all needed local variables
    # xargs ls -t - sort by date, last played char'll be the first in array
    for loadSHEET in $(find "$GAMEDIR/" -name '*.sheet') ; do # Find all sheets and add to array if any
	((++i)) 
	FILES[$i]="$loadSHEET"
   	SHEETS[$i]=$(awk '{ # Character can consist from two and more words, not only "Corum" but "Corum Jhaelen Irsei" for instance 
                   if (/^CHARACTER:/)  { RLENGTH = match($0,/: /); CHARACTER = substr($0, RLENGTH+2); }
                   if (/^RACE:/)       { if ($2 == 1 ) { RACE="Human"; }
               		                 if ($2 == 2 ) { RACE="Elf"; }
             		                 if ($2 == 3 ) { RACE="Dwarf"; }
            		                 if ($2 == 4 ) { RACE="Hobbit";} }
                   if (/^LOCATION:/)   { LOCATION = $2 }
                   if (/^HEALTH:/)     { HEALTH = $2 }
                   if (/^ITEMS:/)      { ITEMS = $2 }
                   if (/^EXPERIENCE:/) { EXPERIENCE = $2 } }
                 END { 
                 print "\"" CHARACTER "\" the " RACE " (" HEALTH " HP, " EXPERIENCE " EXP, " ITEMS " items, sector " LOCATION ")" 
                 }' "$loadSHEET")
    done
    GX_LoadGame 		# Just one time!
    tput sc
    if [[ ! "${SHEETS[@]}" ]] ; then # If no one sheet was found
    	echo " Sorry! No character sheets in $GAMEDIR/"
    	read -sn 1 -p " Press any key to return to (M)ain menu and try (P)lay" 2>&1 # St. Anykey - patron of cyberneticists :)
    	return 1   # BiaminSetup() will not be run after LoadGame()
    fi
    while (true) ; do
	tput rc 		# Restore cursor position
	tput ed			# Clear to the end of screen
    	for (( a=1; a <= LIMIT ; a++)); do [[ ${SHEETS[((a + OFFSET))]} ]] && echo "${a}. ${SHEETS[((a + OFFSET))]}" || break ; done
    	(( i > LIMIT)) && echo -en "\n You have more than $LIMIT characters. Use (P)revious or (N)ext to list," # Don't show it if there are chars < LIMIT
    	echo -en "\n Enter NUMBER of character to load or any letter to return to (M)ain Menu: "
    	read -sn 1 NUM # TODO replace to read -p after debug
    	case "$NUM" in
    	    n | N ) ((OFFSET + LIMIT < i)) && ((OFFSET += LIMIT)) ;; # Next part of list
    	    p | P ) ((OFFSET > 0))         && ((OFFSET -= LIMIT)) ;; # Previous part of list
    	    [1-9] ) NUM=$((NUM + OFFSET)); break;;                   # Set NUM = selected charsheet num
    	    *     ) break;; # NUM == 0 to prevent fall in [[ ! ${FILES[$NUM]} ]] if user press ESC, KEY_UP etc. ${FILES[0]} is always empty
    	esac
     done
    echo "" # TODO empty line - fix it later
    [[ ! "${SHEETS[$NUM]}" ]] && return 1 # BiaminSetup() will not be run after LoadGame()
    CHAR=$(awk '{if (/^CHARACTER:/) { RLENGTH = match($0,/: /); print substr($0, RLENGTH+2);}}' "${FILES[$NUM]}" );
}   # return to MainMenu()


################### GAME SYSTEM #################

#-----------------------------------------------------------------------
# Reseed RANDOM. Needed only once at start, so moved to separate section
case "$OSTYPE" in
    openbsd* ) RANDOM=$(date '+%S');;
    *)         RANDOM=$(date '+%N')
esac
# TODO:
#  ? Move it to runtime section
#  ? Make separate file with system-depended things
#  ? Use /dev/random or /dev/urandom
#-----------------------------------------------------------------------
# SEED=$(head -1 /dev/urandom | od -N 1 | awk '{ print $2 }'| sed s/^0*//)
# RANDOM=$SEED
# Suggestion from: http://tldp.org/LDP/abs/html/randomvar.html
#-----------------------------------------------------------------------

RollDice() {     # Used in RollForEvent(), RollForHealing(), etc
    DICE_SIZE=$1         # DICE_SIZE used in RollForEvent()
    DICE=$((RANDOM%$DICE_SIZE+1))
}

RollDice2() { RollDice $1 ; echo "$DICE" ; } # Temp wrapper for RollDice()

## GAME ACTION: MAP + MOVE
MapNav() { # Used in NewSector()
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
    MAP_X=$(awk '{print substr("ABCDEFGHIJKLMNOPQR", '$MAP_X', 1)}' <<< "$MAP_X") # Translate MAP_X numeric back to A-R
    CHAR_GPS="$MAP_X$MAP_Y" 	# Set new [A-R][1-15] to CHAR_GPS
    sleep 1.5 # Merged with sleep from 'case "$DEST"' section
}   # Return NewSector()

# GAME ACTION: DISPLAY CHARACTER SHEET
DisplayCharsheet() { # Used in NewSector() and FightMode()
    MURDERSCORE=$(bc <<< "if ($CHAR_KILLS > 0) {scale=zero; 100 * $CHAR_KILLS/$CHAR_BATTLES } else 0" ) # kill/fight percentage
    local RACE=$(Capitalize "$CHAR_RACE_STR") # Capitalize
    GX_CharSheet
    cat <<EOF
 Character:                 $CHAR ($RACE)
 Health Points:             $CHAR_HEALTH
 Experience Points:         $CHAR_EXP
 Current Location:          $CHAR_GPS ($PLACE)
 Number of Battles:         $CHAR_BATTLES
 Enemies Slain:             $CHAR_KILLS ($MURDERSCORE%)
 Items found:               $CHAR_ITEMS of 8
 Special Skills:            Healing $HEALING, Strength $STRENGTH, Accuracy $ACCURACY, Flee $FLEE
 Inventory:                 $CHAR_GOLD Gold, $CHAR_TOBACCO Tobacco, $CHAR_FOOD Food
 Current Date:              $TODAYS_DATE_STR
 Turn (DEBUG):              $TURN (don't forget to remove it :) ) 
 Biamin Date:               $BIAMIN_DATE_STR
EOF
    case "$ALMANAC" in
	1) read -sn 1 -p "$(MakePrompt '(D)isplay Race Info;(A)lmanac;(C)ontinue;(Q)uit')"  CHARSHEET_OPT 2>&1 ;; # Player has "unlocked" Almanac
	*) read -sn 1 -p "$(MakePrompt '(D)isplay Race Info;(A)ny key to continue;(Q)uit')" CHARSHEET_OPT 2>&1 ;; # Player does not have Almanac
    esac
    case "$CHARSHEET_OPT" in
	d | D ) GX_Races && PressAnyKey ;;
	a | A ) ((ALMANAC)) && Almanac ;;
	q | Q ) CleanUp ;;
    esac
}

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


EchoFightFormula() { # Display Formula in Fighting. Used in FightMode()
    # req.: dice-size | formula | skill-abbrevation
    local DICE_SIZE="$1" FORMULA="$2" SKILLABBREV="$3"
    (( DICE_SIZE <= 9 )) && DICE_SIZE+=" "

    case "$FORMULA" in
	eq )    FORMULA="= " ;;
	gt )    FORMULA="> " ;;
	lt )    FORMULA="< " ;;
	ge )    FORMULA=">=" ;;
	le )    FORMULA="<=" ;;
	times ) FORMULA="x " ;;
    esac

    # skill & roll
    echo -n "Roll D${DICE_SIZE} $FORMULA $SKILLABBREV ( "
    # The actual symbol in $DICE vs eg $CHAR_ACCURACY is already
    # determined in the if and cases of the Fight Loop, so don't repeat here.
}

Death() { # Used in FightMode() and also should be used in check-for-starvation
    GX_Death
    # echo " The $TODAYS_DATE_STR:"
    echo " The $BIAMIN_DATE_STR:"
    echo " In such a short life, this sorry $CHAR_RACE_STR gained $CHAR_EXP Experience Points."
    local COUNTDOWN=20
    while (( COUNTDOWN > 0 )); do
	echo -en "${CLEAR_LINE} We honor $CHAR with $COUNTDOWN secs silence." 
    	read -sn 1 -t 1 && break || ((COUNTDOWN--))
    done
    unset COUNTDOWN
    #echo "$CHAR_EXP;$CHAR;$CHAR_RACE;$CHAR_BATTLES;$CHAR_KILLS;$CHAR_ITEMS;$TODAYS_DATE;$TODAYS_MONTH;$TODAYS_YEAR" >> "$HIGHSCORE"
    echo "$CHAR_EXP;$CHAR;$CHAR_RACE;$CHAR_BATTLES;$CHAR_KILLS;$CHAR_ITEMS;$DAY;$MONTH;$(Ordial $YEAR)" >> "$HIGHSCORE"
    rm -f "$CHARSHEET" # A sense of loss is important for gameplay:)
    unset CHARSHEET CHAR CHAR_RACE CHAR_HEALTH CHAR_EXP CHAR_GPS SCENARIO CHAR_BATTLES CHAR_KILLS CHAR_ITEMS # Zombie fix     # Do we need it ????
    #    DEATH=1 
    CleanUp
}



# GAME ACTION: REST
RollForHealing() { # Used in Rest()
    RollDice 6
    echo -e "Rolling for healing: D6 <= $HEALING\nROLL D6: $DICE"
    (( DICE > HEALING )) && echo "$2" || ( (( CHAR_HEALTH + $1 )) && echo "You slept well and gained $1 Health." )
    ((TURN++))
    sleep 2
}   # Return to Rest()

# GAME ACTION: REST
# Game balancing can also be done here, if you think players receive too much/little health by resting.
Rest() {  # Used in NewSector()
    PLAYER_RESTING=1 # Set flag for FightMode()
    RollDice 100
    GX_Rest
    echo "$HR"
    case "$1" in
	H ) if (( CHAR_HEALTH < 100 )); then
		CHAR_HEALTH=100
		echo "You slept well in your own bed. Health restored to 100."
	    else
		echo "You slept well in your own bed, and woke up to a beautiful day."
	    fi
	    ((TURN++))
	    ;;
	x ) RollForEvent 60 "fight" && FightMode || RollForHealing 5  "The terrors of the mountains kept you awake all night.." ;;
	. ) RollForEvent 30 "fight" && FightMode || RollForHealing 10 "The dangers of the roads gave you little sleep if any.." ;;
	T ) RollForEvent 15 "fight" && FightMode || RollForHealing 15 "The vices of town life kept you up all night.." ;;
	@ ) RollForEvent 35 "fight" && FightMode || RollForHealing 5  "Possibly dangerous wood owls kept you awake all night.." ;;
	C ) RollForEvent 5  "fight" && FightMode || RollForHealing 35 "Rowdy castle soldiers on a drinking binge kept you awake.." ;;
    esac
    unset PLAYER_RESTING # Reset flag
    sleep 2
}   # Return to NewSector()

# THE GAME LOOP

RollForEvent() { # Used in NewSector() and Rest()
    # $1 - dice size, $2 - event
    echo -e "Rolling for $2: D${DICE_SIZE} <= $1\nD${DICE_SIZE}: $DICE" 
    sleep 2
    (( DICE <= $1 )) && return 0 || return 1
}   # Return to NewSector() or Rest()

GX_Place() {     # Used in NewSector() and MapNav()
    # Display scenario GFX and define place name for MapNav() and DisplayCharsheet()
    case "$1" in
	H ) GX_Home      ; PLACE="Home" ;;
	x ) GX_Mountains ; PLACE="Mountain" ;;
	. ) GX_Road      ; PLACE="Road" ;;
	T ) GX_Town      ; PLACE="Town" ;;
	@ ) GX_Forest    ; PLACE="Forest" ;;
	C ) GX_Castle    ; PLACE="Oldburg Castle" ;;
	Z | * ) CustomMapError;;
    esac
}   # Return to NewSector() or MapNav()

DiceGameCompetition() {
    case "$1" in # DGAME_COMP
	2 | 12 ) DGAME_COMP=3 ;;  # 1/36 = 03 %
	3 | 11 ) DGAME_COMP=6 ;;  # 2/36 = 06 % 
	4 | 10 ) DGAME_COMP=9 ;;  # 3/36 = 09 %
	5 | 9  ) DGAME_COMP=12 ;; # 4/36 = 12 %
	6 | 8  ) DGAME_COMP=14 ;; # 5/36 = 14 %
	7      ) DGAME_COMP=17 ;; # 1/6  = 17 % == 61 %
    esac
}

MiniGame_Dice() { # Small dice based minigame used in Tavern()
	echo -en "${CLEAR_LINE}"

	# How many players currently at the table
	DGAME_PLAYERS=$((RANDOM%6)) # 0-5 players
	(( DGAME_PLAYERS == 0 )) && read -sn1 -p "There's no one at the table. May be you should come back later?" 2>&1 && return 0  # leave
	# Determine stake size
	DGAME_STAKES=$( bc <<< "$(RollDice2 6) * $VAL_CHANGE" ) # min 0.25, max 1.5
	# Check if player can afford it
	if (( $(bc <<< "$CHAR_GOLD <= $DGAME_STAKES") )); then
	    read -sn1 -p "No one plays with a poor, Goldless $CHAR_RACE_STR! Come back when you've got it.." 2>&1
	    return 0 # leave
	fi

	GX_DiceGame_Table
	case "$DGAME_PLAYERS" in # Ask whether player wants to join
	    1 ) read -sn1 -p "There's a gambler wanting to roll dice for $DGAME_STAKES Gold a piece. Want to [J]oin?" JOIN_DICE_GAME 2>&1 ;;
	    * ) read -sn1 -p "There are $DGAME_PLAYERS players rolling dice for $DGAME_STAKES Gold a piece. Want to [J]oin?" JOIN_DICE_GAME 2>&1 ;;	    
	esac
	case "$JOIN_DICE_GAME" in
	    j | J | y | Y ) ;; # Game on! Do nothing.
	    * ) echo -e "\nToo high stakes for you, $CHAR_RACE_STR?" ; sleep 2; return 0;; # Leave.
	esac

	GAME_ROUND=1
	CHAR_GOLD=$(bc <<< "$CHAR_GOLD - $DGAME_STAKES" )
	echo -e "\nYou put down $DGAME_STAKES Gold and pull out a chair .. [ -$DGAME_STAKES Gold ]" && sleep 3
	
	# Determine starting pot size
	DGAME_POT=$( bc <<< "$DGAME_STAKES * ( $DGAME_PLAYERS + 1 )" )
	
	# DICE GAME LOOP
	while ( true ) ; do
	    GX_DiceGame_Table
	    if (( $(bc <<< "$CHAR_GOLD < $DGAME_STAKES") )) ; then # Check if we've still got gold for 1 stake...
		echo "You're out of gold, $CHAR_RACE_STR. Come back when you have some more!"
		break # if not, leave immediately		
	    fi		
	    read -p "Round $GAME_ROUND. The pot's $DGAME_POT Gold. Bet (2-12), (I)nstructions or (L)eave Table: " DGAME_GUESS 2>&1
	    echo " " # Empty line for cosmetical purposes # TODO
	    
	    # Dice Game Instructions (mostly re: payout)
	    case "$DGAME_GUESS" in
		i | I ) GX_DiceGame_Instructions ; continue ;;     # Start loop from the beginning
		1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 ) # Stake!
		    if (( GAME_ROUND > 1 )) ; then                 # First round is already paid
		    	CHAR_GOLD=$(bc <<< "$CHAR_GOLD - $DGAME_STAKES" )
		    	echo "Putting down your stake in the pile.. [ -$DGAME_STAKES Gold ]" && sleep 3
		    fi ;;
		*)  echo "See you around, $CHAR_RACE_STR. Come back with more Gold!" # or leave table
		    break # leave immediately
	    esac

	    DiceGameCompetition $DGAME_GUESS # Determine if we're sharing the bet based on odds percentage.. # TODO. Do these calculations just once/round!
	    
	    # Run that through a loop of players num and % dice..
	    DGAME_PLAYERS_COUNTER=$DGAME_PLAYERS
	    DGAME_COMPETITION=0
	    while (( DGAME_PLAYERS_COUNTER > 0 )) ; do		
		(( $(RollDice2 100) <= DGAME_COMP )) && (( DGAME_COMPETITION++ )) # Sharing!
		(( DGAME_PLAYERS_COUNTER-- ))
	    done
	    
	    # Roll the dice (pray for good luck!)
	    echo -n "Rolling for $DGAME_GUESS ($DGAME_COMP% odds).. " && sleep 1
	    case "$DGAME_COMPETITION" in
		0 ) echo "No one else playing for $DGAME_GUESS!" ;;
		1 ) echo "Sharing bet with another player!" ;;	    
		* ) echo "Sharing bet with $DGAME_COMPETITION other players!"		    
	    esac
	    sleep 1
	    
	    DGAME_DICE_1=$(RollDice2 6) 
	    DGAME_DICE_2=$(RollDice2 6) 
	    DGAME_RESULT=$( bc <<< "$DGAME_DICE_1 + $DGAME_DICE_2" )
	    # IDEA: If we later add an item or charm for LUCK, add adjustments here.
	    
	    GX_DiceGame "$DGAME_DICE_1" "$DGAME_DICE_2" # Display roll result graphically
	    
	    # Calculate % of POT (initial DGAME_WINNINGS) to be paid out given DGAME_RESULT (odds)
	    case "$DGAME_RESULT" in
	    2 | 12 ) DGAME_WINNINGS=$DGAME_POT ;;		       # 100%  # TODO
	    3 | 11 ) DGAME_WINNINGS=$( bc <<< "$DGAME_POT * 0.85" ) ;; # 85%   # PLAY TEST THESE %s
	    4 | 10 ) DGAME_WINNINGS=$( bc <<< "$DGAME_POT * 0.70" ) ;; # 70%
	    5 | 9  ) DGAME_WINNINGS=$( bc <<< "$DGAME_POT * 0.55" ) ;; # 55%
	    6 | 8  ) DGAME_WINNINGS=$( bc <<< "$DGAME_POT * 0.40" ) ;; # 40%
	    7      ) DGAME_WINNINGS=$( bc <<< "$DGAME_POT * 0.25" ) ;; # 25%
	    esac
	    
	    if (( DGAME_GUESS == DGAME_RESULT )) ; then # You won
   		DGAME_POT=$( bc <<< "$DGAME_POT - $DGAME_WINNINGS" )  # Adjust winnings to odds
		DGAME_WINNINGS=$( bc <<< "$DGAME_WINNINGS / ( $DGAME_COMPETITION + 1 )" ) # no competition = winnings/1
		echo "You rolled $DGAME_RESULT and won $DGAME_WINNINGS Gold! [ +$DGAME_WINNINGS Gold ]"
		CHAR_GOLD=$( bc <<< "$CHAR_GOLD + $DGAME_WINNINGS" )
		sleep 3
	    else # You didn't win
		echo -n "You rolled $DGAME_RESULT and lost.. "
		
		# Check if other player(s) won the pot
		DGAME_COMPETITION=$( bc <<< "$DGAME_PLAYERS - $DGAME_COMPETITION" )
		DGAME_OTHER_WINNERS=0
		
		DiceGameCompetition $DGAME_RESULT # Chances of any player picking the resulting number
		
		while (( DGAME_COMPETITION >= 1 )) ; do
		    RollDice 100 # bugfix
		    (( DICE <= DGAME_COMP )) && (( DGAME_OTHER_WINNERS++ )) # +1 more winner
		    (( DGAME_COMPETITION-- ))
		done
		
		case "$DGAME_OTHER_WINNERS" in
		    0) echo "luckily there were no other winners either!" ;;
		    1) echo "another player got $DGAME_RESULT and won $DGAME_WINNINGS Gold.";;
		    *) echo "but $DGAME_OTHER_WINNERS other players rolled $DGAME_RESULT and $DGAME_WINNINGS Gold." ;;			
		esac
		(( DGAME_OTHER_WINNERS > 0 )) && DGAME_POT=$( bc <<< "$DGAME_POT - $DGAME_WINNINGS" ) # Adjust winnings to odds
	    fi
	    sleep 3
	    
	    # Update pot size
	    DGAME_STAKES_TOTAL=$( bc <<< "$DGAME_STAKES * ( $DGAME_PLAYERS + 1 ) " ) # Assumes player is with us next round too
	    DGAME_POT=$( bc <<< "$DGAME_POT + $DGAME_STAKES_TOTAL" )		     # If not, the other players won't complain:)

	    (( GAME_ROUND++ ))	# Increment round
	done
	sleep 3 # After 'break' in while-loop
	SaveCurrentSheet
}

Tavern() { # Used in GoIntoTown()
    while (true); do
	GX_Tavern # Tavern gained +30 HEALTH - Town*2
	read -sn1 -p "     (R)ent a room and rest safely     (P)lay dice     (A)ny key to Exit" VAR 2>&1
	case "$VAR" in
	    r | R) 
		GX_Tavern
		read -sn1 -p "      rent for 1 (G)old      rent for 1 (T)obacco      (A)ny key to Exit" CUR 2>&1
		case "$CUR" in
		    g | G ) 
			if (( $(bc <<< "$CHAR_GOLD <= 1") )); then # check for money
			    echo "You don't have enough Gold to rent a room in the Tavern"
			else
			    GX_Rest
			    CHAR_GOLD=$(bc <<< "$CHAR_GOLD - 1")
			    echo -n "You got some much needed rest .."
			    if (( CHAR_HEALTH < 150 )); then
				(( CHAR_HEALTH += 30 ))
				(( CHAR_HEALTH > 150 )) && CHAR_HEALTH=150
				echo " and your HEALTH is $CHAR_HEALTH now"
			    fi
			    ((TURN++))
			fi
			;;
		    t | T )
			if (( $(bc <<< "$CHAR_TOBACCO <= 1") )); then # check for money
			    echo "You don't have enough Tobacco to rent a room in the Tavern"
			else
			    GX_Rest
			    CHAR_TOBACCO=$(bc <<< "$CHAR_TOBACCO - 1")
			    echo -n "You got some much needed rest .."
			    if (( CHAR_HEALTH < 150 )); then
				(( CHAR_HEALTH += 30 ))
				(( CHAR_HEALTH > 150 )) && CHAR_HEALTH=150
				echo " and your HEALTH is $CHAR_HEALTH now"
			    fi
			    ((TURN++))
			fi
			;;
		esac 
		read -n 1;; # DEBUG replace to sleep 
 	    p | P ) MiniGame_Dice ;;
	    * ) break ;; # Leave tavern
	esac
    done
} # Return to GoIntoTown()

Marketplace() { # Used in GoIntoTown()
    # The PRICE of a unit (food, ale) is always 1.
    while (true); do
	GX_Marketplace
	read -sn 1 -p "           (G)rocer          (M)erchant          (L)eave Marketplace" VAR 2>&1
	case "$VAR" in
	    g | G) Marketplace_Grocer;; # Trade FOOD for GOLD and TOBACCO
	    m | M) Marketplace_Merchant;; # Trade TOBACCO <-> GOLD ??? Or what?? #kstn
	    # Smbd who'll trade boars' tusks etc for GOLD/TOBACCO ???
	    *) break ;; # Leave marketplace
	esac
    done
    # IDEA? Add stealing from market??? 
    # Good idea, but we'd have to arrange a fight and new enemy type (shopkeep)..
    # Or he call the police (the guards?) and they throw player from town? (kstn) 
    # We're getting way ahead of ourselves:) Let's just make what we have work first:)
} # Return to GoIntoTown()

Marketplace_Merchant_PriceFixing() {
    case "$1" in
	"FxG" ) MERCHANT_FxG=$( echo "scale=2;$1$2$3" | bc ) ;;
	"GxF" ) MERCHANT_GxF=$( echo "scale=2;$1$2$3" | bc ) ;;
	"FxT" ) MERCHANT_FxT=$( echo "scale=2;$1$2$3" | bc ) ;;
	"TxF" ) MERCHANT_TxF=$( echo "scale=2;$1$2$3" | bc ) ;;
	"GxT" ) MERCHANT_GxT=$( echo "scale=2;$1$2$3" | bc ) ;;
	"TxG" ) MERCHANT_TxG=$( echo "scale=2;$1$2$3" | bc ) ;;
	"IxG" ) MERCHANT_IxG=$( echo "scale=2;$1$2$3" | bc ) ;;
	"GxI" ) MERCHANT_GxI=$( echo "scale=2;$1$2$3" | bc ) ;;
	"IxT" ) MERCHANT_IxT=$( echo "scale=2;$1$2$3" | bc ) ;;
	"TxI" ) MERCHANT_TxI=$( echo "scale=2;$1$2$3" | bc ) ;;
    esac
}

Marketplace_Merchant() {
    # If this is a "freshly entered" town, re-do prices
    if [ -z "$MERCHANT" ] || [ "$MERCHANT[0]" != "$CHAR_GPS" ] ; then
	# "Name" the current merchant as char GPS location
	MERCHANT="$CHAR_GPS"

	# STANDARD PRICES. Mostly set in WorldPriceFixing(). 
	# Note MERCHANT_FxG means: Merchant trades 1 Food for $MERCHANT_FXG amount of players Gold.
	MERCHANT_FxG=$PRICE_FxG && MERCHANT_GxF=$PRICE_GxF	
	MERCHANT_FxT=$PRICE_FxT && MERCHANT_TxF=$PRICE_TxF
	MERCHANT_GxT=$PRICE_GxT && MERCHANT_TxG=$PRICE_TxG

	local VAL_ITEMS=2 # Twice the value of Food. TODO This could be subject to change. Consider Almanac vs. a pelt of fur..?
	MERCHANT_IxG=$( echo "scale=2;$VAL_ITEMS/$VAL_GOLD" | bc ) # Warning! old-style echo used on purpose
	MERCHANT_GxI=$( echo "scale=2;$VAL_GOLD/$VAL_ITEMS" | bc ) # Otherwise bc errors out
	MERCHANT_IxT=$( echo "scale=2;$VAL_ITEMS/$VAL_TOBACCO" | bc )
	MERCHANT_TxI=$( echo "scale=2;$VAL_TOBACCO/$VAL_ITEMS" | bc )	

	# Add profit margin on items based on MERCHANT WANTS $SPECIAL_PRICE[0]
	RollDice 90 && local PROFIT=$(( DICE/100 )) && local SPECIAL_PRICE && local SP_COUNT=0

	# Determine what this merchant trades in. Has some influence on what the player gets for it or pays for it.
	RollDice 4
	case "$DICE" in                                                           # Merchant WANTS to buy and only reluctantly sells
	    1 ) SPECIAL_PRICE=( "FxG" "GxF" "FxT" "TxF" ) && SP_CMAX=3             ;; # Food
	    2 ) SPECIAL_PRICE=( "TxG" "GxT" "TxF" "FxT" "TxI" "IxT" ) && SP_CMAX=5 ;; # Tobacco
	    3 ) SPECIAL_PRICE=( "GxF" "FxG" "GxT" "TxG" "GxI" "IxG" ) && SP_CMAX=5 ;; # Gold
	    4 ) SPECIAL_PRICE=( "IxG" "GxI" "IxT" "TxI" ) && SP_CMAX=3             ;; # Items
	esac
	
	while (( SP_COUNT <= SP_CMAX )) ; do
	    # Merchant wants to keep e.g. food, so adds $PROFIT to nominal price
	    # However, Merchant also wants to buy up e.g. food from player, so buys at good price
	    Marketplace_Merchant_PriceFixing ${SPECIAL_PRICE[$SP_COUNT]} + $PROFIT
	    (( SP_COUNT++ ))
	done
    fi
    
    # Merchant Loop
    while (true) ; do
	GX_Marketplace_Merchant
	local M_Y=4
	local MERCHANT_MSG=("" "weather-beaten Traveller!" "galant Elf of the Forests!" "fierce master Dwarf!" "young master Hobbit!") # [0] is dummy
	tput  sc && MvAddStr $M_Y 4 "Oye there, ${MERCHANT_MSG[$CHAR_RACE]}"
	local MERCHANT_MSG=( "" "" "" "" "" "Me and my Caravan travel far and wide" "to provide the Finest Merchandise" "in the Realm, and at the best"
	    "possible prices! I buy everything" "and sell only the best, 'tis true!" "What are you looking for?" )  && (( M_Y++ )) # [0-4] are dummies
	while (( M_Y <= 10 )) ; do
	    MvAddStr $M_Y 4 "${MERCHANT_MSG[$M_Y]}"
	    (( M_Y++ ))
	done
	tput rc
	read -sn 1 -p "$(MakePrompt '(F)ood;(T)obacco;(G)old;(I)tems;(N)othing')" MERCHANTVAR 2>&1
	GX_Marketplace_Merchant
	tput sc
    	case "$MERCHANTVAR" in
	    F | f ) local MERCHANDISE="Food"
		MvAddStr 7 4 "$MERCHANT_FxG Gold or $MERCHANT_FxT Tobacco."           # FxG, FxT (sell for gold/tobacco)
		MvAddStr 10 4 "for $MERCHANT_GxF Gold or $MERCHANT_TxF Tobacco each!" # GxF, TxF (buy  for food/tobacco)
		;;
	    T | t ) local MERCHANDISE="Tobacco"
		MvAddStr 7 4 "$MERCHANT_TxG Gold or $MERCHANT_TxF Food."              # TxG, TxF
		MvAddStr 10 4 "for $MERCHANT_GxT Gold or $MERCHANT_FxT Food each!"    # GxT, FxT
		;;
	    G | g ) local MERCHANDISE="Gold"
		MvAddStr 7 4 "$MERCHANT_GxT Tobacco or $MERCHANT_GxF Food."           # GxT, GxF
		MvAddStr 10 4 "for $MERCHANT_TxG Tobacco or $MERCHANT_FxG Food each!" # TxG, FxG
		;;
	    I | i ) local MERCHANDISE="Item" ;;		
	    * ) break ;;
	esac
	if [ "$MERCHANDISE" = "Item" ] ; then
	    MvAddStr 4 4 "You are in for a treat!" # TODO random item stock (unless Almanac == 0)
	    MvAddStr 6 4 "I managed to acquire a special"
	    MvAddStr 7 4 "hand-made and leatherbound"
	    MvAddStr 8 4 "Almanac. It is only"
	    MvAddStr 9 4 "$MERCHANT_IxG Gold or $MERCHANT_IxF Tobacco!"
	    MvAddStr 11 4 "Go ahead! Touch it!"
	    read -sn 1 ### DEBUG
	else
	    MvAddStr 4 4 "But of course! Here are my prices:"
	    MvAddStr 6 4 "I sell 1 $MERCHANDISE to you for"
	    MvAddStr 9 4 "Or I can buy 1 $MERCHANDISE from you,"
	    MvAddStr 10 4 "Are you buying or selling?"
	    read -sn 1 -p "$(MakePrompt '(B)uying;(S)elling;(J)ust Looking')" MERCHANTVAR 2>&1
	    GX_Marketplace_Merchant
	    case "$MERCHANTVAR" in
		b | B ) local TODO ;; # Add buying logic (from grocer
		s | S ) local TODO ;; # Add selling logic (more or less equiv.)
	    esac    
	fi
	tput rc
    done
} # Return to Marketplace

Marketplace_Grocer() { # Used in GoIntoTown()
    # The PRICE of units are set in WorldPriceFixing()
    while (true); do
	GX_Marketplace_Grocer
	tput sc # save cursor position
	tput cup 10 4 # move to y=10, x=4 ( upper left corner is 0 0 )
	echo "1 FOOD costs $PRICE_FxG Gold"
	tput cup 11 4 # move to y=10, x=4 ( upper left corner is 0 0 )
	echo "or $PRICE_FxT Tobacco.\""
	tput rc # restore cursor position
	echo "Welcome to my shoppe, stranger! We have the right prices for you .." # Will be in GX_..
	echo -e "You currently have $CHAR_GOLD Gold, $CHAR_TOBACCO Tobacco and $CHAR_FOOD Food in your inventory\n"
	read -sn 1 -p "$(MakePrompt 'Trade for (G)old;Trade for (T)obacco;(L)eave')" MARKETVAR 2>&1
	case "$MARKETVAR" in
	    g | G )
		GX_Marketplace_Grocer
		read -p "How many food items do you want to buy? " QUANTITY 2>&1
		# TODO check for QUANTITY - if falls if QUANTITY != [0-9]+
		# TODO Perhaps this could help: stackoverflow.com/questions/806906/how-do-i-test-if-a-variable-is-a-number-in-bash
		local COST=$( bc <<< "$PRICE_FxG * $QUANTITY" )
		if (( $(bc <<< "$CHAR_GOLD > $COST") )); then
		    CHAR_GOLD=$(bc <<< "$CHAR_GOLD - $COST")
		    CHAR_FOOD=$(bc <<< "${CHAR_FOOD} + ${QUANTITY}")
		    echo "You bought $QUANTITY food for $COST Gold, and you have $CHAR_FOOD Food in your inventory"
		else
		    echo "You don't have enough Gold to buy $QUANTITY food yet. Try a little less!"
		fi
		read -n 1		
		;;
	    t | T )
		GX_Marketplace_Grocer
		read -p "How much food you want to buy? " QUANTITY 2>&1
		# TODO check for QUANTITY - if falls if QUANTITY != [0-9]+
		local COST=$( bc <<< "${PRICE_FxT} * $QUANTITY" )
		if (( $(bc <<< "$CHAR_TOBACCO > $COST") )); then
		    CHAR_TOBACCO=$(bc <<< "$CHAR_TOBACCO - $COST")
		    CHAR_FOOD=$(bc <<< "${CHAR_FOOD} + ${QUANTITY}")
		    echo "You traded $COST Tobacco for $QUANTITY food, and have $CHAR_FOOD Food in your inventory"
		else
		    echo "You don't have enough Tobacco to trade for $QUANTITY food yet. Try a little less!"
		fi
		read -n 1		
		;;
	    *) break;
	esac
    done
    unset PRICE_IN_GOLD PRICE_IN_TOBACCO
    # IDEA: Add stealing from market??? 
    # Good idea, but we'd have to arrange a fight and new enemy type (shopkeep)..
    # Or he call the police (the guards?) and they throw player from town? (kstn)
} # Return to GoIntoTown()

GoIntoTown() { # Used in NewSector()
    while (true); do
	GX_Place "$SCENARIO" # GX_Town 
        # Add separate GX for this? 
        # What about add separate GX for Town and use current GX_Town() here? #kstn
	echo -n "      (T)avern      (B)ulletin Board      (M)arketplace      (E)xit Town"	
	read -sn 1 ACTION
	case "$ACTION" in
	    t | T ) Tavern ;;
	    m | M ) Marketplace ;;
	    b | B ) GX_Bulletin "$BBSMSG" ;;
	    * ) break ;; # Leave town
	esac
    done
} # Return to NewSector()

CheckForStarvation() { # Used in NewSector() and should be used also in Rest()
    # TODO may be it shold be renamed to smth more understandable? #kstn
    # Food check # TODO add it to Rest() after finishing
    # TODO not check for food at the 1st turn ???
    # TODO Tavern also should reset STARVATION and restore starvation penalties if any
    if (( $(bc <<< "${CHAR_FOOD} > 0") )) ; then
	CHAR_FOOD=$( bc <<< "${CHAR_FOOD} - 0.25" )
	echo "You eat .25 food from your stock: $CHAR_FOOD remaining .." 
	if (( STARVATION > 0 )) ; then
	    if (( STARVATION >= 8 )) ; then # Restore lost ability after overcoming starvation
		case "$CHAR_RACE" in
		    1 | 3 ) (( STRENGTH++ )) && echo "+1 STRENGTH: You restore your body to healthy condition (Strength: $STRENGTH)" ;; 
		    2 | 4 ) (( ACCURACY++ )) && echo "+1 ACCURACY: You restore your body to healthy condition (Accuracy: $ACCURACY)" ;; 
		esac		    
	    fi
	    STARVATION=0
	fi
    else
	case $(( ++STARVATION )) in # ++STARVATION THEN check
	    1 ) echo "You're starving on the ${STARVATION}st day and feeling hungry .." ;;
	    2 ) echo "You're starving on the ${STARVATION}nd day and feeling famished .." ;;
	    3 ) echo "You're starving on the ${STARVATION}rd day and feeling weak .." ;;
	    * ) echo "You're starving on the ${STARVATION}th day, feeling weaker and weaker .." ;;
	esac

	(( CHAR_HEALTH -= 5 ))
	echo "-5 HEALTH: Your body is suffering from starvation .. (Health: $HEALTH)" # Light Starvation penalty - decrease 5HP/turn	    
	
	if (( STARVATION == 8 )); then # Extreme Starvation penalty
	    case "$CHAR_RACE" in
		1 | 3 ) (( STRENGTH-- )) && echo "-1 STRENGTH: You're slowly starving to death .. (Strength: $STRENGTH)" ;; 
		2 | 4 ) (( ACCURACY-- )) && echo "-1 ACCURACY: You're slowly starving to death .. (Accuracy: $ACCURACY)" ;;
	    esac
	fi
	((HEALTH <= 0)) && echo "You have starved to death" && sleep 2 && Death # 
    fi
    sleep 2 ### DEBUG
}
# THE GAME LOOP
NewSector() { # Used in Intro()
    while (true); do  # While (player-is-alive) :) 
	((TURN++)) # Nev turn, new date
	DateFromTurn # Get year, month, day, weekday
	# Find out where we are - Fixes LOCATION in CHAR_GPS "A1" to a place on the MapNav "X1,Y1"
	read -r MAP_X MAP_Y <<< $(awk '{ print substr($0, 1 ,1); print substr($0, 2); }' <<< "$CHAR_GPS")
	MAP_X=$(awk '{print index("ABCDEFGHIJKLMNOPQR", $0)}' <<< "$MAP_X") # converts {A..R} to {1..18} #kstn
	SCENARIO=$(awk '{ if ( NR == '$((MAP_Y+2))') { print $'$((MAP_X+2))'; }}' <<< "$MAP" ) # MAP_Y+2 MAP_X+2 - padding for borders
	CheckForItem $MAP_X $MAP_Y # Look for treasure @ current GPS location  - Checks current section for treasure
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
}   # Return to MainMenu() (if player is dead)

Announce() {
    # Simply outputs a 160 char text you can cut & paste to social media.
    
    # TODO: Once date is decoupled from system date (with CREATION and DATE), create new message. E.g.
    # $CHAR died $DATE having fought $BATTLES ($KILLS victoriously) etc...

    # Die if $HIGHSCORE is empty
    [[ ! -s "$HIGHSCORE" ]] && Die "Sorry, can't do that just yet!\nThe highscore list is unfortunately empty right now."

    echo "TOP 10 BACK IN A MINUTE HIGHSCORES"
    HighscoreRead
    echo -en "\nSelect the highscore (1-10) you'd like to display or CTRL+C to cancel: "
    read SCORE_TO_PRINT

    ((SCORE_TO_PRINT < 1)) && ((SCORE_TO_PRINT > 10 )) && Die "\nOut of range. Please select an entry between 1-10. Quitting.."

    case $(RollDice2 6) in
	1 ) ADJECTIVE="honorable" ;;
	2 ) ADJECTIVE="fearless" ;;
	3 ) ADJECTIVE="courageos" ;;
	4 ) ADJECTIVE="brave" ;;
	5 ) ADJECTIVE="legendary" ;;
	6 ) ADJECTIVE="heroic" ;;
    esac

    ANNOUNCEMENT_TMP=$(sed -n "${SCORE_TO_PRINT}"p "$HIGHSCORE")
    IFS=";" read -r highEXP highCHAR highRACE highBATTLES highKILLS highITEMS highDATE highMONTH highYEAR <<< "$ANNOUNCEMENT_TMP"

    case "$highRACE" in
	1 ) highRACE="Human" ;;
	2 ) highRACE="Elf" ;;
	3 ) highRACE="Dwarf" ;;
	4 ) highRACE="Hobbit" ;;
    esac

    (( highBATTLES == 1 )) && highBATTLES+=" battle" || highBATTLES+=" battles"
    (( highITEMS == 1 ))   && highITEMS+=" item"     || highITEMS+=" items"

    highCHAR=$(Capitalize "$highCHAR") # Capitalize
    
    if [[ "$highMONTH" ]] ; then # fix for "Witching Day", etc
	ANNOUNCEMENT="$highCHAR fought $highBATTLES, $highKILLS victoriously, won $highEXP EXP and $highITEMS. This $ADJECTIVE $highRACE was finally slain the $highDATE of $highMONTH in the $highYEAR Cycle."
    else
	ANNOUNCEMENT="$highCHAR fought $highBATTLES, $highKILLS victoriously, won $highEXP EXP and $highITEMS. This $ADJECTIVE $highRACE was finally slain at the $highDATE in the $highYEAR Cycle."
    fi
    ANNOUNCEMENT_LENGHT=$(awk '{print length($0)}' <<< "$ANNOUNCEMENT" ) 
    GX_HighScore

    echo "ADVENTURE SUMMARY to copy and paste to your social media of choice:"
    echo -e "\n$ANNOUNCEMENT\n" | fmt
    echo "$HR"

    ((ANNOUNCEMENT_LENGHT > 160)) && echo "Warning! String longer than 160 chars ($ANNOUNCEMENT_LENGHT)!"
    exit 0
}

ColorConfig() {
    echo -e "\nWe need to configure terminal colors for the map!
Please note that a colored symbol is easier to see on the world map.
Back in a minute was designed for white text on black background.
Does \033[1;33mthis text appear yellow\033[0m without any funny characters?"
    read -sn1 -p "Do you want color? [Y/N]: " COLOR_CONFIG 2>&1
    case "$COLOR_CONFIG" in
	n | N ) COLOR=0 ; echo -e "\nDisabling color! Edit $GAMEDIR/config to change this setting.";;
	* )     COLOR=1 ; echo -e "\nEnabling color!" ;;
    esac

    # BUG! Falls in OpenBSD. TODO replace to awk. #kstn
    sed -i"~" "/^COLOR:/s/^.*$/COLOR: $COLOR/g" "$GAMEDIR/config" # MacOS fix http://stackoverflow.com/questions/7573368/in-place-edits-with-sed-on-os-x
    sleep 2
}

CreateBiaminLauncher() {
    grep -q 'biamin' "$HOME/.bashrc" && Die "Found existing launcher in $HOME/.bashrc.. skipping!" 
    BIAMIN_RUNTIME=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ) # TODO $0 is a powerful beast, but will sometimes fail..
    echo "This will add $BIAMIN_RUNTIME/biamin to your .bashrc"
    read -n 1 -p "Install Biamin Launcher? [Y/N]: " LAUNCHER 2>&1
    case "$LAUNCHER" in
	y | Y ) echo -e "\n# Back in a Minute Game Launcher (just run 'biamin')\nalias biamin='$BIAMIN_RUNTIME/biamin.sh'" >> "$HOME/.bashrc";
	        echo -e "\nDone. Run 'source \$HOME/.bashrc' to test 'biamin' command." ;;
	* ) echo -e "\nDon't worry, not changing anything!";;
    esac
    exit 0
}        

#                           END FUNCTIONS                              #
#                                                                      #
#                                                                      #
########################################################################

