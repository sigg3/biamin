
########################################################################
#                                                                      #
#                        2. RUNTIME BLOCK                              #
#                   All running code goes here!                        #

# Make place for game (BEFORE CLI opts! Mostly because of Higscore and MapCreateCustom()
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

ParseCLIarguments "$1" # Parse CLI arguments if any # TODO use getopts ?

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

################################# Main game part ###############################
MainMenu       # Run main menu (Define $CHAR)
BiaminSetup    # Load or make new char
Intro	       # Set world
NewSector      # And run main game loop
############################## Main game part ends #############################
exit 0         # This should never happen:
               # .. but why be 'tardy when you can be tidy?
