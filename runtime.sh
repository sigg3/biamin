########################################################################
#                                                                      #
#                        2. RUNTIME BLOCK                              #
#                   All running code goes here!                        #

# Make place for game (BEFORE CLI opts! Mostly because of Higscore
if [[ ! -d "$GAMEDIR" ]] ; then # Check whether gamedir exists...
    echo -e "Game directory default is $GAMEDIR/\nYou can change this in $CONFIG. Creating directory ..."
    mkdir -p "$GAMEDIR/" || Die "ERROR! You do not have write permissions for $GAMEDIR ..."
fi

if [[ ! -f "$CONFIG" ]] ; then # Check whether $CONFIG exists...
    echo "Creating ${CONFIG} ..."
    echo -e "GAMEDIR: ${GAMEDIR}\nCOLOR: NA" > "$CONFIG"
fi

[[ -f "$HIGHSCORE" ]] || touch "$HIGHSCORE"; # Check whether $HIGHSCORE exists...
grep -q 'd41d8cd98f00b204e9800998ecf8427e' "$HIGHSCORE" && echo "" > "$HIGHSCORE" # Backwards compatibility: replaces old-style empty HS...

if [[ ! "$PAGER" ]] ; then # Define PAGER (for ShowLicense() )
    for PAGER in less more ; do PAGER=$(which "$PAGER" 2>/dev/null); [[ "$PAGER" ]] && break; done
fi

# Load global calendar variables (used in DateFromTurn() and Almanac())
YEAR_LENGHT=365 # Gregorian calendar without leap years
YEAR_MONTHES=12 # How many monthes are in year?

MONTH_STR=(
    # Month name #Month lenght #Month total lenght  #Month trivia
    "Biamin Festival"    0  0   "Rarely happens, if ever :(" # Arrays numeration starts from 0, so we need dummy ${MONTH_LENGTH[0]}
    "After-Frost"        31 31  "1st Month of the Year\n This is the coldest and darkest month of the year. Stay in, stay warm."       
    "Marrsuckur"         28 59  "2nd Month of the Year\n \"Marrow-sucker\" is a lean month. Some nobles have a custom of fasting."     
    "Plough-Tide"        31 90  "3rd Month of the Year\n Farmers return to their ploughs. Hobbit villages celebrate Springtide."       
    "Anorlukis"          30 120 "4th Month of the Year\n The winter darkness is overwon by Anor's arrows. Holy month for Elves."       
    "Summer-Tide"        31 151 "5th Month of the Year\n Middle of year. While the heat is welcoming, watch out for orcs and goblins!" 
    "Summer-Turn"        30 181 "6th Month of the Year\n A celebration of the Turn of Anor, in which one gives thanks for any good."   
    "Merentimes"         31 212 "7th Month of the Year\n From 'Meren' (happiness). This warm month is oft celebrated by travellers."   
    "Harvest Month"      31 243 "8th Month of the Year\n Autumn is the busiest time of year. And evil grows in the wilderness."        
    "Ringorin"           30 273 "9th Month of the Year\n From 'Ringorn' (circle, life, produce). Holy month for farmers."              
    "Brew-Tasting Tide"  31 304 "10th Month of the Year\n Traditional tasting of ales begin this month. Don't venture about alone."    
    "Winter Month"       30 334 "11th Month of the Year\n By now the stocks are full of produce. Livestock & people shelter in."       
    "Midwinter Offering" 31 365 "12th Month of the Year\n The Offering is a significant and holy event for priests and people alike."  
)

MonthString()      { echo ${MONTH_STR[((  $1 * 4      ))]} ;}
MonthLength()      { echo ${MONTH_STR[(( ($1 * 4) + 1 ))]} ;}
MonthTotalLength() { echo ${MONTH_STR[(( ($1 * 4) + 2 ))]} ;}
MonthTrivia()      { echo ${MONTH_STR[(( ($1 * 4) + 3 ))]} ;}

WEEK_LENGTH=7 # How many days are in week?
WEEKDAY_STR=(
    # Weekday    # Short trivia                       # Long trivia
    "Ringday (Holiday)" "Day of Festivities and Rest" "Men and Halflings celebrate Ringday as the end and beginning of the week."   
    "Moonday"   "Mor's Day (Day of the Moon)"         "Elves and Dwarves once celebrated Moon Day as the holiest. Some still do."   
    "Brenday"   "Brenia's Day (God of Courage)"       "Visit the Temple on Brenia's Day to honor those who perished in warfare."    
    "Midweek"   "Middle of the Week (Day of Balance)" "In some places, Midweek Eve is celebrated with village dances and ale."      
    "Braigday"  "Braig's Day (God of Wilderness)"     "Historically, a day of hunting. Nobility still hunt every Braig's Day."      
    "Melethday" "Melethril's Day (God of Love)"       "Commonly considered Lovers' Day, it is also a day of mischief and trickery." 
    "Washday"   "Final Workday of the Week"           "Folk name for Lanthir's Day, the God of Water, Springs and Waterfalls."      
)

WeekdayString()      { echo ${WEEKDAY_STR[((  $1 * 3      ))]} ;}
WeekdayTriviaShort() { echo ${WEEKDAY_STR[(( ($1 * 3) + 1 ))]} ;}
WeekdayTriviaLong()  { echo ${WEEKDAY_STR[(( ($1 * 3) + 2 ))]} ;}

# Parse CLI arguments if any # TODO use getopts ?
case "$1" in
    -a | --announce )     Announce ;;
    -i | --install ) CreateBiaminLauncher ;;
    -h | --help )
	echo "Run BACK IN A MINUTE with '-p', '--play' or 'p' argument to play!"
	echo "For usage: run biamin --usage"
	echo "Current dir for game files: $GAMEDIR/"
	echo "Change at runtime or on line 10 in the CONFIGURATION of the script."
	exit 0;;
    --map )
	read -n1 -p "Create custom map template? [Y/N]: " CUSTOM_MAP_PROMPT 2>&1
	case "$CUSTOM_MAP_PROMPT" in
		y | Y) echo -e "\nCreating custom map template.." ; MapCreateCustom ;;
		*)     echo -e "\nNot doing anything! Quitting.."
	esac
	exit 0 ;;
    -p | --play | p ) echo "Launching Back in a Minute.." ;;
    -v | --version )
	echo "BACK IN A MINUTE VERSION $VERSION Copyright (C) 2014 Sigg3.net"
	echo "Game SHELL CODE released under GNU GPL version 3 (GPLv3)."
	echo "This is free software: you are free to change and redistribute it."
	echo "There is NO WARRANTY, to the extent permitted by law."
	echo "For details see: <http://www.gnu.org/licenses/gpl-3.0>"
	echo "Game ARTWORK released under Creative Commons CC BY-NC-SA 4.0."
	echo "You are free to copy, distribute, transmit and adapt the work."
	echo "For details see: <http://creativecommons.org/licenses/by-nc-sa/4.0/>"
	echo "Game created by Sigg3. Submit bugs & feedback at <$WEBURL>"
	exit 0 ;;
    --update ) # Update function
	# Removes stranded repo files before proceeding..
	STRANDED_REPO_FILES=$(find "$GAMEDIR"/repo.* | wc -l)
	(( STRANDED_REPO_FILES > 0 )) && rm -f "$GAMEDIR/repo.*"
	REPO_SRC="https://gitorious.org/back-in-a-minute/code/raw/biamin.sh"
	GX_BiaminTitle;
	echo "Retrieving $REPO_SRC .." | sed 's/https:\/\///g'
	REPO=$( mktemp $GAMEDIR/repo.XXXXXX ) 
	if [[ $(which wget 2>/dev/null) ]]; then # Try wget, automatic redirect
	    wget -q -O "$REPO" "$REPO_SRC" || Die "DOWNLOAD ERROR! No internet with wget"
	elif [[ $(which curl 2>/dev/null) ]]; then # Try curl, -L - for redirect
	    curl -s -L -o "$REPO" "$REPO_SRC" || Die  "DOWNLOAD ERROR! No internet with curl"
	else
	    Die "DOWNLOAD ERROR! No curl or wget available"
	fi

	REPOVERSION=$( sed -n -r '/^VERSION=/s/^VERSION="([^"]*)".*$/\1/p' "$REPO" )
	echo "Your current Back in a Minute game is version $VERSION"

	# Compare versions $1 and $2. Versions should be [0-9]+.[0-9]+.[0-9]+. ...
	# Return 0 if $1 == $2, 1 if $1 > than $2, 2 if $2 < than $1
	if [[ "$VERSION" == "$REPOVERSION" ]] ; then
	    RETVAL=0  
	else
	    IFS="\." read -a VER1 <<< "$VERSION"
	    IFS="\." read -a VER2 <<< "$REPOVERSION"
	    for ((i=0; ; i++)); do # until break
		[[ ! "${VER1[$i]}" ]] && { RETVAL=2; break; }
		[[ ! "${VER2[$i]}" ]] && { RETVAL=1; break; }
		(( ${VER1[$i]} > ${VER2[$i]} )) && { RETVAL=1; break; }
		(( ${VER1[$i]} < ${VER2[$i]} )) && { RETVAL=2; break; }
	    done
	    unset VER1 VER2
	fi
	case "$RETVAL" in
	    0)  echo "This is the latest version ($VERSION) of Back in a Minute!" ; rm -f "$REPO";;
	    1)  echo "Your version ($VERSION) is newer than $REPOVERSION" ; rm -f "$REPO";;
	    2)  echo "Newer version $REPOVERSION is available!"
		echo "Updating will NOT destroy character sheets, highscore or current config."
 		read -sn1 -p "Update to Biamin version $REPOVERSION? [Y/N] " CONFIRMUPDATE 2>&1
		case "$CONFIRMUPDATE" in
		    y | Y ) echo -e "\nUpdating Back in a Minute from $VERSION to $REPOVERSION .."
			# TODO make it less ugly
			BIAMIN_RUNTIME=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ) # TODO $0 is a powerful beast, but will sometimes fail.
			BIAMIN_RUNTIME+="/"
			BIAMIN_RUNTIME+=$( basename "${BASH_SOURCE[0]}")
			mv "$BIAMIN_RUNTIME" "${BIAMIN_RUNTIME}.bak" # backup current file
			mv "$REPO" "$BIAMIN_RUNTIME"
			chmod +x "$BIAMIN_RUNTIME" || Die "PERMISSION ERROR! Couldnt make biamin executable"
			echo "Run 'sh $BIAMIN_RUNTIME --install' to add launcher!" 
			echo "Current file moved to ${BIAMIN_RUNTIME}.bak"
			;;
		    * ) echo -e "\nNot updating! Removing temporary file .."; rm -f "$REPO" ;;
		esac
		;;
	esac
	echo "Done. Thanks for playing :)"
	exit 0;;
    --usage | * )
	echo "Usage: biamin or ./biamin.sh"
	echo "  (NO ARGUMENTS)      display this usage text and exit"
	echo "  -p --play or p      PLAY the game \"Back in a minute\""
	echo "  -a --announce       DISPLAY an adventure summary for social media and exit"
	echo "  -i --install        ADD biamin.sh to your .bashrc file"
	echo "     --map            CREATE custom map template with instructions and exit"
	echo "     --help           display help text and exit"
	echo "     --update         check for updates"
	echo "     --usage          display this usage text and exit"
	echo "  -v --version        display version and licensing info and exit"
	exit 0;;
esac

# OK lets play!
echo "Putting on the traveller's boots.."

# Load variables from $GAMEDIR/config. NB variables should not be empty !
read -r GAMEDIR COLOR <<< $(awk '{ if (/^GAMEDIR:/)  { GAMEDIR= $2 }
                                   if (/^COLOR:/)    { COLOR = $2  } }
                            END { print GAMEDIR " " COLOR ;}' "$GAMEDIR/config" )
# Color configuration
case "$COLOR" in
    1 ) echo "Enabling color for maps!" ;;
    0 )	echo "Enabling old black-and-white version!" ;;
    * ) ColorConfig ;;
esac

if (( COLOR == 1 )); then # Define colors
    YELLOW='\033[1;33m' # Used in MapNav() and GX_Map()
    RESET='\033[0m'
fi # TODO define here another seqences from MapNav()

# Define escape sequences #TODO replace to tput or similar
CLEAR_LINE="\e[1K\e[80D" # \e[1K - erase to the start of line \e[80D - move cursor 80 columns backward
trap CleanUp SIGHUP SIGINT SIGTERM # Direct termination signals to CleanUp
MainMenu       # Run main menu
exit 0         # This should never happen:
               # .. but why be 'tardy when you can be tidy?
