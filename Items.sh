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
HaveItem() { (( $CHAR_ITEMS > $1 )) && return 0 || return 1; }

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
# Used: ItemWasFound(), Intro()
#-----------------------------------------------------------------------
HotzonesDistribute() { # 
    (( $1 >= MAX_ITEMS )) && return 0                                   # Do not redisribute hotzones if player have all magick items
    local MAP_X MAP_Y		                                        # TODO: not sure do we need it? #kstn
    read -r MAP_X MAP_Y <<< $(GPStoXY "$CHAR_GPS")                      # Get current X(int), Y(int) from GPS([A-R][1-15])
    local ITEMS_2_SCATTER=$(( MAX_ITEMS - $1 ))                         # Scatter only absent items 
    HOTZONE=()                                                          # Reset HOTZONE
    while ((ITEMS_2_SCATTER > 0)) ; do
	local ITEM_Y=$(RollDice2 15) ITEM_X=$(RollDice2 18)             # Randomize ITEM_Y and ITEM_X 
	(( ITEM_X == MAP_X )) && (( ITEM_Y == MAP_Y )) && continue      # reroll if HOTZONE == CHAR_GPS
	CheckHotzones $ITEM_X $ITEM_Y && continue                       # reroll if "$ITEM_X-$ITEM_Y" is already in ${HOTZONE[@]}
	((ITEMS_2_SCATTER--))                                           # decrease ITEMS_2_SCATTER because array starts from ${HOTZONE[0]} #kstn
	HOTZONE["$ITEMS_2_SCATTER"]="$ITEM_X-$ITEM_Y"                   # init ${HOTZONE[ITEMS_2_SCATTER]},
    done
}

#-----------------------------------------------------------------------
# ItemWasFound()
# Display found item GX, add ability (if any), increase $CHAR_ITEMS
# and redistribute hotzones
#-----------------------------------------------------------------------
ItemWasFound() {
    GX_Item "$CHAR_ITEMS"	     # Defined in GX_Item.sh
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
    ((++CHAR_ITEMS))                 # Increase CHAR_ITEMS
    HotzonesDistribute "$CHAR_ITEMS" # Re-distribute items to increase randomness. Now it is not bugfix but feature
    SaveCurrentSheet                 # Save CHARSHEET items
    NODICE=1                         # No fighting if item is found..
}

#-----------------------------------------------------------------------
# CheckForItem()
# Calls ItemWasFound() if this GPS is in the items array ($HOTZONES[])
# Arguments: MAP_X(int) MAP_Y(int)
# Used: NewSector()
#-----------------------------------------------------------------------
CheckForItem() { (( $1 < MAX_ITEMS )) && CheckHotzones $1 $2 && ItemWasFound ; }

#                                                                      #
#                                                                      #
########################################################################

