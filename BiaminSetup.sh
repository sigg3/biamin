########################################################################
#                             BiaminSetup                              #
#                    Load charsheet or make new char                   #

# Set abilities according to race (each equal to 12) + string var used frequently
RACES=(
    "Race   Healing Strength Accuracy Flee Offset_Gold Offset_Tobacco" # Dummy - we haven't RACE == 0
    "human  3       3        3        3     2          -3"
    "elf    4       3        4        1    -3           2" 
    "dwarf  2       5        3        2     2          -3"
    "hobbit 4       1        4        3    -3           2"
)

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
# Load bonuses from magic items (items defined in Items.sh)
# Arguments: $CHAR_ITEMS (int)
#-----------------------------------------------------------------------
BiaminSetup_SetItemsAbilities() {
    HaveItem "$EMERALD_OF_NARCOLEPSY" && ((HEALING++))
    HaveItem "$FAST_MAGIC_BOOTS"      && ((FLEE++))
    HaveItem "$TWO_HANDED_BROADSWORD" && ((STRENGTH++))
    HaveItem "$STEADY_HAND_BREW"      && ((ACCURACY++))
}

BiaminSetup_LoadCharsheet() {
	echo -en " Welcome back, $CHAR!\n Loading character sheet ..." # -n for 80x24, DO NOT REMOVE IT #kstn	
	# Sequence for updating older charsheets to later additions (compatibility)
	grep -Eq '^HOME:' "$CHARSHEET"        || echo "HOME: $START_LOCATION" >> $CHARSHEET
	grep -Eq '^GOLD:' "$CHARSHEET"        || echo "GOLD: 10" >> $CHARSHEET
	grep -Eq '^TOBACCO:' "$CHARSHEET"     || echo "TOBACCO: 10" >> $CHARSHEET
	grep -Eq '^FOOD:' "$CHARSHEET"        || echo "FOOD: 10" >> $CHARSHEET
	grep -Eq '^BBSMSG:' "$CHARSHEET"      || echo "BBSMSG: 0" >> $CHARSHEET
	grep -Eq '^STARVATION:' "$CHARSHEET"  || echo "STARVATION: 0" >> $CHARSHEET
	# TODO use  OFFSET_{GOLD,TOBACCO} 
	grep -Eq '^VAL_GOLD:' "$CHARSHEET"    || echo "VAL_GOLD: 1" >> $CHARSHEET
	grep -Eq '^VAL_TOBACCO:' "$CHARSHEET" || echo "VAL_TOBACCO: 1" >> $CHARSHEET
	grep -Eq '^VAL_CHANGE:' "$CHARSHEET"  || echo "VAL_CHANGE: 0.25" >> $CHARSHEET
	# Time 
	grep -Eq '^TURN:' "$CHARSHEET"        || echo "TURN: $(TurnFromDate)" >> $CHARSHEET
	# Almanac
	grep -Eq '^ALMANAC:' "$CHARSHEET"     || echo "ALMANAC: 0" >> $CHARSHEET
	# TODO I don't know why, but "read -r VAR1 VAR2 VAR3 <<< $(awk $FILE)" not works :(
	# But one local variable at any case is better that to open one file eight times
	local CHAR_TMP=$(awk '
                  { 
                   if (/^CHARACTER:/)  { RLENGTH = match($0,/: /);
                  	                 CHARACTER = substr($0, RLENGTH+2); }
                   if (/^RACE:/)       { RACE= $2 }
                   if (/^BATTLES:/)    { BATTLES = $2 }
                   if (/^EXPERIENCE:/) { EXPERIENCE = $2 }
                   if (/^LOCATION:/)   { LOCATION = $2 }
                   if (/^HEALTH:/)     { HEALTH = $2 }
                   if (/^ITEMS:/)      { ITEMS = $2 }
                   if (/^KILLS:/)      { KILLS = $2 }
                   if (/^HOME:/)       { HOME = $2 }
                   if (/^GOLD:/)       { GOLD = $2 }
                   if (/^TOBACCO:/)    { TOBACCO = $2 }
                   if (/^FOOD:/)       { FOOD = $2 }
                   if (/^BBSMSG:/)     { BBSMSG = $2 }
                   if (/^VAL_GOLD:/)   { VAL_GOLD = $2 }
                   if (/^VAL_TOBACCO:/){ VAL_TOBACCO = $2 }
                   if (/^VAL_CHANGE:/) { VAL_CHANGE = $2 }
                   if (/^STARVATION:/) { STARVATION = $2 }
                   if (/^TURN:/)        { TURN= $2 }
                   if (/^ALMANAC:/)     { ALMANAC = $2 }
                 }
                 END { 
                 print CHARACTER ";" RACE ";" BATTLES ";" EXPERIENCE ";" LOCATION ";" HEALTH ";" ITEMS ";" KILLS ";" HOME ";" GOLD ";" TOBACCO ";" FOOD ";" BBSMSG ";" VAL_GOLD ";" VAL_TOBACCO ";" VAL_CHANGE ";" STARVATION ";" TURN ";" ALMANAC ";"
                 }' $CHARSHEET )
	IFS=";" read -r CHAR CHAR_RACE CHAR_BATTLES CHAR_EXP CHAR_GPS CHAR_HEALTH CHAR_ITEMS CHAR_KILLS CHAR_HOME CHAR_GOLD CHAR_TOBACCO CHAR_FOOD BBSMSG VAL_GOLD VAL_TOBACCO VAL_CHANGE STARVATION TURN ALMANAC <<< "$CHAR_TMP"
	unset CHAR_TMP
	# If character is dead, don't fool around..
	(( CHAR_HEALTH <= 0 )) && Die "\nWhoops!\n $CHAR's health is $CHAR_HEALTH!\nThis game does not support necromancy, sorry!"
}

BiaminSetup_SanityCheck() {
    if [[ ! -z "$CHAR_LOC" ]]; then
	# Use user input as start location.. but first SANITY CHECK
	read CHAR_LOC_LEN CHAR_LOC_A CHAR_LOC_B <<< $(awk '{print length($0) " " substr($0,0,1) " " substr($0,2)}' <<< "$CHAR_LOC")
	(( CHAR_LOC_LEN < 1 )) && Die " Error! Too less characters in $CHAR_LOC\n Start location is 2-3 alphanumeric chars [A-R][1-15], e.g. C2 or P13"
	(( CHAR_LOC_LEN > 3 )) && Die " Error! Too many characters in $CHAR_LOC\n Start location is 2-3 alphanumeric chars [A-R][1-15], e.g. C2 or P13"
	echo -n "Sanity check.."
	case "$CHAR_LOC_A" in
	    A | B | C | D | E | F | G | H | I | J | K | L | M | N | O | P | Q | R ) echo -n ".." ;;
	    * ) Die "\n Error! Start location X-Axis $CHAR_LOC_A must be a CAPITAL alphanumeric A-R letter!" ;;
	esac
	case "$CHAR_LOC_B" in
	    1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 ) echo ".. Done!" ;;
	    * ) Die "\n Error! Start location Y-Axis $CHAR_LOC_B is too big or too small!";;
	esac
	# End of SANITY check, everything okay!
	CHAR_GPS="$CHAR_LOC"
	CHAR_HOME="$CHAR_LOC"
	unset CHAR_LOC CHAR_LOC_LEN CHAR_LOC_A CHAR_LOC_B
    fi # or CHAR_GPS and CHAR_HOME not changed from START_LOCATION
}

# BiaminSetup_MakeBaseChar() {
#     CHAR_BATTLES=0
#     CHAR_EXP=0
#     CHAR_HEALTH=100
#     CHAR_ITEMS=0
#     CHAR_KILLS=0
#     BBSMSG=0
#     STARVATION=0;
#     TURN=$(TurnFromDate) # Player starts from translated _real date_. Afterwards, turns increment.
#     ALMANAC=0
#     #
#     CHAR_GOLD=-1
#     CHAR_TOBACCO=-1
#     # Determine initial food stock (D16 + 4) - player has 5 food minimum
#     CHAR_FOOD=$( bc <<< "$(RollDice2 16) + 4" )
#     # Set initial Value of Currencies
#     VAL_GOLD=1
#     VAL_TOBACCO=1
#     VAL_CHANGE=0.25    
#     # Add location info
#     CHAR_GPS="$START_LOCATION"
#     CHAR_HOME="$START_LOCATION"
# }

BiaminSetup_MakeNewChar() {
	echo " $CHAR is a new character!"
	CHAR_BATTLES=0
	CHAR_EXP=0
	CHAR_HEALTH=100
	CHAR_ITEMS=0
	CHAR_KILLS=0
	BBSMSG=0
	STARVATION=0;
	TURN=$(TurnFromDate) # Player starts from translated _real date_. Afterwards, turns increment.
	ALMANAC=0
	GX_Races
	read -sn 1 -p " Select character race (1-4): " CHAR_RACE 2>&1

	# IDEA - why not difference all 4 races by various tobacco/gold offsets ? #kstn
	#            gold            tobacco                                      # Good idea, implement it
	#             \/                /\                                        # as long as u detail the math
	# dwarves |  most         | the smallest                                  # below :) - Sigge
	# man     |  more         | smaller
	# elves   |  smaller      | more
	# hobbits |  the smallest | most
	#             
	case "$CHAR_RACE" in
	    2 ) echo "You chose to be an ELF"                 && OFFSET_GOLD=-3 && OFFSET_TOBACCO=2 ;;
	    3 ) echo "You chose to be a DWARF"                && OFFSET_GOLD=2 && OFFSET_TOBACCO=-3 ;;
	    4 ) echo "You chose to be a HOBBIT"               && OFFSET_GOLD=-3 && OFFSET_TOBACCO=2 ;;
	    * ) CHAR_RACE=1 && echo "You chose to be a HUMAN" && OFFSET_GOLD=2 && OFFSET_TOBACCO=-3 ;;
	esac

	# WEALTH formula = D20 + (D6 * CLASS OFFSET)
	CHAR_GOLD=$(    bc <<< "$(RollDice2 20) + ($OFFSET_GOLD    * $(RollDice2 6))" )
	CHAR_TOBACCO=$( bc <<< "$(RollDice2 20) + ($OFFSET_TOBACCO * $(RollDice2 6))" )
	(( CHAR_TOBACCO < 0 )) && CHAR_TOBACCO=0 # healthy bastard
	(( CHAR_GOLD < 0 ))    && CHAR_GOLD=0    # poor bastard

	# Determine initial food stock (D16 + 4) - player has 5 food minimum
	CHAR_FOOD=$( bc <<< "$(RollDice2 16) + 4" )
	# Set initial Value of Currencies
	VAL_GOLD=1
	VAL_TOBACCO=1
	VAL_CHANGE=0.25
	
	# Add location info
	CHAR_GPS="$START_LOCATION"
	CHAR_HOME="$START_LOCATION"
	# If there IS a CUSTOM.map file, ask where the player would like to start
	# TODO move it to LoadCustomMap()
	if [[ "$CUSTOM_MAP" ]] ; then
	    START_LOCATION=$(awk '{ if (/^START LOCATION:/) { print $2; exit; } print "'$START_LOCATION'"; }' <<< "$CUSTOM_MAP" )
	    read -p " HOME location for custom maps (ENTER for default $START_LOCATION): " "CHAR_LOC" 2>&1
	    BiaminSetup_SanityCheck
	fi
	echo " Creating fresh character sheet for $CHAR ..."
	SaveCurrentSheet
}


#-----------------------------------------------------------------------
# BiaminSetup()
# Gets char name and load charsheet or make new char
# Used: runtime.sh
# TODO: Argumens: $CHAR(string)
#-----------------------------------------------------------------------
BiaminSetup() { 
    # Set CHARSHEET variable to gamedir/char.sheet (lowercase)
    CHARSHEET="$GAMEDIR/$(echo "$CHAR" | tr '[:upper:]' '[:lower:]' | tr -d " ").sheet"
    if [[ -f "$CHARSHEET" ]]; then
	BiaminSetup_LoadCharsheet
    else
	BiaminSetup_MakeNewChar
    fi
    sleep 2
    BiaminSetup_SetRaceAbilities  "$CHAR_RACE"
    BiaminSetup_SetItemsAbilities "$CHAR_ITEMS"
    # If Cheating is disabled (in CONFIGURATION) restrict health to 150
    (( DISABLE_CHEATS == 1 )) && (( CHAR_HEALTH >= 150 )) && CHAR_HEALTH=150
}
#                                                                      #
#                                                                      #
########################################################################

