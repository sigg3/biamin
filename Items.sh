########################################################################
#                           Game items                                 #
#                                                                      #

# Define items variables (mostly for readability)
GIFT_OF_SIGHT=0
EMERALD_OF_NARCOLEPSY=1
GUARDIAN_ANGEL=2
FAST_MAGIC_BOOTS=3
QUICK_RABBIT_REACTION=4
FLASK_OF_TERRIBLE_ODOUR=5
TWO_HANDED_BROADSWORD=6
STEADY_HAND_BREW=7

MAX_ITEMS=8 # Define maximum count of items

#-----------------------------------------------------------------------
# HaveItem()
# Check if player have this item
# Arguments: $ITEM(int)
#-----------------------------------------------------------------------
HaveItem() { 
    (( $CHAR_ITEMS > $1 )) && return 0 || return 1; 
}

#-----------------------------------------------------------------------
# CheckHotzones()
# Check if this GPS is in the items array ($HOTZONES[])
# Arguments: MAP_X(int) MAP_Y(int)
#-----------------------------------------------------------------------
CheckHotzones() {
    [[ $(grep -E "(^| )$1-$2( |$)" <<< "${HOTZONE[@]}") ]] && return 0 || return 1
}

#-----------------------------------------------------------------------
# HotzonesDistribute()
# Scatters special items across the map
# Arguments: $CHAR_ITEMS(int)
# Used in Intro() and ItemWasFound()
#-----------------------------------------------------------------------
HotzonesDistribute() { # 
    (( $1 >= MAX_ITEMS )) && return 0 
    local MAP_X MAP_Y
    read -r MAP_X MAP_Y <<< $(awk '{ print substr($0, 1 ,1); print substr($0, 2); }' <<< "$CHAR_GPS")
    MAP_X=$(awk '{print index("ABCDEFGHIJKLMNOPQR", $0)}' <<< "$MAP_X") # converts {A..R} to {1..18}
    local ITEMS_2_SCATTER=$(( MAX_ITEMS - $1 ))
    declare -a HOTZONE=() # Reset HOTZONE and declare as array (can speed up operations)
    while ((ITEMS_2_SCATTER > 0)) ; do
	local ITEM_Y=$(RollDice2 15) ITEM_X=$(RollDice2 18)                          # Randomize ITEM_Y and ITEM_X 
	(( ITEM_X == MAP_X )) && (( ITEM_Y == MAP_Y )) && continue                   # reroll if HOTZONE == CHAR_GPS
	CheckHotzones $ITEM_X $ITEM_Y && continue # reroll if "$ITEM_X-$ITEM_Y" is already in ${HOTZONE[@]}
	((ITEMS_2_SCATTER--)) # decrease ITEMS_2_SCATTER because array starts from ${HOTZONE[0]} #kstn
	HOTZONE["$ITEMS_2_SCATTER"]="$ITEM_X-$ITEM_Y" # init ${HOTZONE[ITEMS_2_SCATTER]},
    done
}

#-----------------------------------------------------------------------
# CheckForItem()
# Calls ItemWasFound() if this GPS is in the items array ($HOTZONES[])
# Arguments: MAP_X(int) MAP_Y(int)
#-----------------------------------------------------------------------
CheckForItem() {
    CheckHotzones $1 $2 && ItemWasFound
}

## GAME FUNCTIONS: ITEMS IN LOOP
ItemWasFound() { # Used in NewSector()
    GX_Item "$CHAR_ITEMS"	# Defined in GX_Item.sh
    case "$CHAR_ITEMS" in
	"$EMERALD_OF_NARCOLEPSY" ) ((HEALING++))  ;;
	"$FAST_MAGIC_BOOTS"      ) ((FLEE++))     ;;
	"$TWO_HANDED_BROADSWORD" ) ((STRENGTH++)) ;;
	"$STEADY_HAND_BREW"      ) ((ACCURACY++)) ;;
    esac
    local COUNTDOWN=180
    while (( COUNTDOWN > 0 )); do
	echo -en "${CLEAR_LINE}                      Press any letter to continue  ($COUNTDOWN)"
	read -sn 1 -t 1 && break || ((COUNTDOWN--))
    done
    ((++CHAR_ITEMS)) # Increase CHAR_ITEMS
    HotzonesDistribute "$CHAR_ITEMS" # Re-distribute items to increase randomness if char haven't all 8 items. Now it is not bugfix but feature
    SaveCurrentSheet # Save CHARSHEET items
    NODICE=1         # No fighting if item is found..
}   # Return to NewSector()

#                                                                      #
#                                                                      #
########################################################################

