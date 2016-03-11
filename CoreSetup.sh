########################################################################
#                             BiaminSetup                              #
#                    Load charsheet or make new char                   #

#-----------------------------------------------------------------------
# $RACES
# All game races and their abilities table. Sum of all race abilities
# equal 12
#-----------------------------------------------------------------------
declare -r -a RACES=(
    "Race   Healing Strength Accuracy Flee Offset_Gold Offset_Tobacco" # Dummy - we haven't RACE == 0
    "human  3       3        3        3    12           8"
    "elf    4       3        4        1     8          12"
    "dwarf  2       5        3        2    14           6"
    "hobbit 4       1        4        3     6          14"
)
declare -r MAX_RACES=4 		                                       # Count of game races

#-----------------------------------------------------------------------
# $INITIAL_VALUE_*
# Initial Value of Currencies - declared as constants, in one place
# for easier changing afterwards
# Default 0.15: 0.05 is very stable economy, 0.5 is very unstable.
# IDEA If we add a (S)ettings page in (M)ain menu, this could be
# user-configurable.
#-----------------------------------------------------------------------
declare -r INITIAL_VALUE_GOLD=1      # Initial Value of Gold
declare -r INITIAL_VALUE_TOBACCO=1   # Initial Value of Tobacco
declare -r INITIAL_VALUE_CHANGE=0.15 # Initial Market fluctuation key

#-----------------------------------------------------------------------
# BiaminSetup_SetRaceAbilities()
# Load race abilities from $RACES
# Arguments: $CHAR_RACE (int)
#-----------------------------------------------------------------------
BiaminSetup_SetRaceAbilities() {
    read -r CHAR_RACE_STR HEALING STRENGTH ACCURACY FLEE OFFSET_GOLD OFFSET_TOBACCO <<< ${RACES[$1]}
}

#-----------------------------------------------------------------------
# BiaminSetup_SetItemsAbilities
# Load bonuses from magic items (items defined in GameItems.sh)
# Arguments: $CHAR_ITEMS (int)
#-----------------------------------------------------------------------
BiaminSetup_SetItemsAbilities() {
    HaveItem "$EMERALD_OF_NARCOLEPSY" && ((HEALING++))
    HaveItem "$FAST_MAGIC_BOOTS"      && ((FLEE++))
    HaveItem "$TWO_HANDED_BROADSWORD" && ((STRENGTH++))
    HaveItem "$STEADY_HAND_BREW"      && ((ACCURACY++))
}

#-----------------------------------------------------------------------
# BiaminSetup_UpdateOldSaves()
# Sequence for updating older charsheets to later additions (compatibility)
# Used: BiaminSetup_LoadCharsheet()
# Other variables are defined in BiaminSetup_MakeBaseChar()
#-----------------------------------------------------------------------
BiaminSetup_UpdateOldSaves() {
    # TODO use  OFFSET_{GOLD,TOBACCO}
    [[ "$CHAR_GOLD" ]]    || CHAR_GOLD=10
    [[ "$CHAR_TOBACCO" ]] || CHAR_TOBACCO=10
}

#-----------------------------------------------------------------------
# BiaminSetup_SanityCheck()
# Checks if $1 in GPS format ([A-R][1-15])
# Arguments: $CHAR_LOC(string)
# Used: BiaminSetup_LoadCharsheet()
#-----------------------------------------------------------------------
BiaminSetup_SanityCheck() {
    local CHAR_LOC_LEN CHAR_LOC_X CHAR_LOC_Y
    read CHAR_LOC_LEN CHAR_LOC_X CHAR_LOC_Y <<< $(awk '{print length($0), substr($0,0,1), substr($0,2)}' <<< "$1")
    echo -n "Sanity check.."
    (( CHAR_LOC_LEN < 1 )) && Die "\n Error! Too less characters in $CHAR_LOC\n Start location is 2-3 alphanumeric chars [A-R][1-15], e.g. C2 or P13"
    (( CHAR_LOC_LEN > 3 )) && Die "\n Error! Too many characters in $CHAR_LOC\n Start location is 2-3 alphanumeric chars [A-R][1-15], e.g. C2 or P13"
    [[ "$CHAR_LOC_X" == [A-R] ]] &&  echo -n ".." || Die "\n Error! Start location X-Axis $CHAR_LOC_X must be a CAPITAL alphanumeric A-R letter!"
    case "$CHAR_LOC_Y" in
	1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 ) echo ".. Done!" ;;
	* ) Die "\n Error! Start location Y-Axis $CHAR_LOC_Y is too big or too small!";;
    esac
    # End of SANITY check, everything okay!
    CHAR_GPS="$1"
    CHAR_HOME="$1"
}

BiaminSetup_LoadCharsheet() {
    echo -en " Welcome back, $CHAR!\n Loading character sheet ..." # -n for 80x24, DO NOT REMOVE IT #kstn
    local VAR VAL
    while IFS=": " read VAR VAL; do
        case "$VAR" in
            "VERSION"     ) ;; # TODO???
            "CHARACTER"   ) CHAR="${VAL}" ;;
            "RACE"        ) CHAR_RACE="${VAL}" ;;
            "BATTLES"     ) CHAR_BATTLES="${VAL}" ;;
            "EXPERIENCE"  ) CHAR_EXP="${VAL}" ;;
            "LOCATION"    ) CHAR_GPS="${VAL}" ;;
            "HEALTH"      ) CHAR_HEALTH="${VAL}" ;;
            "ITEMS"       ) CHAR_ITEMS="${VAL}" ;;
            "KILLS"       ) CHAR_KILLS="${VAL}" ;;
            "HOME"        ) CHAR_HOME="${VAL}" ;;
            "GOLD"        ) CHAR_GOLD="${VAL}" ;;
            "TOBACCO"     ) CHAR_TOBACCO="${VAL}" ;;
            "FOOD"        ) CHAR_FOOD="${VAL}" ;;
            "BBSMSG"      ) BBSMSG="${VAL}" ;;
            "VAL_GOLD"    ) VAL_GOLD="${VAL}" ;;
            "VAL_TOBACCO" ) VAL_TOBACCO="${VAL}" ;;
            "VAL_CHANGE"  ) VAL_CHANGE="${VAL}" ;;
            "STARVATION"  ) STARVATION="${VAL}" ;;
            "TURN"        ) TURN="${VAL}" ;;
            "INV_ALMANAC" ) INV_ALMANAC="${VAL}" ;;
        esac
    done < "$CHARSHEET"
    # If character is dead, don't fool around..
    if (( CHAR_HEALTH <= 0 )); then
        Die "\nWhoops!\n $CHAR's health is $CHAR_HEALTH!\nThis game does not support necromancy, sorry!"
    fi
    BiaminSetup_UpdateOldSaves
}

#-----------------------------------------------------------------------
# BiaminSetup_MakeBaseChar()
# Set default initial values for CHAR characterisitics
#
# Main idea is to exclude BiaminSetup_UpdateOldSaves() but make basic
# char with default settings (gold, values, food, etc) and then
# BiaminSetup_LoadCharsheet() or BiaminSetup_MakeNewChar()
#-----------------------------------------------------------------------
BiaminSetup_MakeBaseChar() {
    # CHARACTER: $CHAR
    # RACE: $CHAR_RACE
    CHAR_BATTLES=0
    CHAR_EXP=0
    CHAR_GPS="$START_LOCATION"
    CHAR_HEALTH=100
    CHAR_ITEMS=0
    CHAR_KILLS=0
    CHAR_HOME="$START_LOCATION"
    # GOLD: $CHAR_GOLD
    # TOBACCO: $CHAR_TOBACCO
    CHAR_FOOD=$( bc <<< "$(RollDice2 11) + 4" ) # Determine initial food stock (D16 + 4) - player has 5 food minimum
    BBSMSG=0
    VAL_GOLD="$INITIAL_VALUE_GOLD" 	 # Initial Value of Currencies
    VAL_TOBACCO="$INITIAL_VALUE_TOBACCO" # Initial Value of Currencies
    VAL_CHANGE="$INITIAL_VALUE_CHANGE"   # Market fluctuation key
    STARVATION=0
    TURN=$(TurnFromDate)	# Count turn from current date
    INV_ALMANAC=0 		# Locked by-default
}

BiaminSetup_MakeNewChar() {
    echo " $CHAR is a new character!"
    GX_Races
    echo -n " Select character race (1-4): "
    CHAR_RACE=$(Read)
    [[ "$CHAR_RACE" != [1-$MAX_RACES] ]] && CHAR_RACE=1 # fix user's input
    BiaminSetup_SetRaceAbilities "$CHAR_RACE"
    echo "You chose to be a $(Toupper $CHAR_RACE_STR)"

    # IDEA v.3 Select Gender (M/F) ?
    # Most importantly for spoken strings, but may also have other effects.

    # Determine material wealth
    CHAR_GOLD=$(RollDice2 $OFFSET_GOLD)
    CHAR_TOBACCO=$(RollDice2 $OFFSET_TOBACCO)

    # If there IS a CUSTOM.map file, ask where the player would like to start
    # TODO move it to LoadCustomMap()
    if [[ "$CUSTOM_MAP" ]] ; then
	START_LOCATION=$(awk '{ if (/^START LOCATION:/) { print $2; exit; } print "'$START_LOCATION'"; }' <<< "$CUSTOM_MAP" )
	ReadLine " HOME location for custom maps (ENTER for default $START_LOCATION): "
	CHAR_LOC="$REPLY"
	[[ ! -z "$CHAR_LOC" ]] && BiaminSetup_SanityCheck "$CHAR_LOC" 	# Use user input as start location.. but first SANITY CHECK
    fi
    echo " Creating fresh character sheet for $CHAR ..."
    SaveCurrentSheet
}

#-----------------------------------------------------------------------
# BiaminSetup()
# Gets char name and load charsheet or make new char
# Used: CoreRuntime.sh
# TODO: Argumens: $CHAR(string)
#-----------------------------------------------------------------------
BiaminSetup() {
    BiaminSetup_MakeBaseChar	                                                        # Make default char
    CHARSHEET="$GAMEDIR/$(echo "$CHAR" | tr '[:upper:]' '[:lower:]' | tr -d " ").sheet" # Set CHARSHEET variable to gamedir/char.sheet (lowercase)
    if [[ -f "$CHARSHEET" ]] ; then
	BiaminSetup_LoadCharsheet
	BiaminSetup_SetRaceAbilities  "$CHAR_RACE"
	BiaminSetup_SetItemsAbilities "$CHAR_ITEMS"                                     # We need set item's abilities only for loaded chars
	if ((DISABLE_CHEATS == 1 && CHAR_HEALTH >= MAX_HEALTH)); then                   # If Cheating is disabled (in CONFIGURATION)
	    CHAR_HEALTH=${MAX_HEALTH}                                                   # restrict health to $MAX_HEALTH
	fi
    else
	BiaminSetup_MakeNewChar
    fi
    Sleep 2
}

#                                                                      #
#                                                                      #
########################################################################
