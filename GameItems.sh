########################################################################
#                           Game items                                 #
#                                                                      #

#-----------------------------------------------------------------------
# Items global constants.
# Used: ItemWasFound(), GX_Item(), FightMode_AddBonuses(),
#  FightMode_RemoveBonuses(), BiaminSetup_SetItemsAbilities()
#-----------------------------------------------------------------------
declare -r GIFT_OF_SIGHT=0
declare -r EMERALD_OF_NARCOLEPSY=1
declare -r GUARDIAN_ANGEL=2
declare -r FAST_MAGIC_BOOTS=3
declare -r QUICK_RABBIT_REACTION=4
declare -r FLASK_OF_TERRIBLE_ODOUR=5
declare -r TWO_HANDED_BROADSWORD=6
declare -r STEADY_HAND_BREW=7

declare -r MAX_ITEMS=8 # Maximum count of items

#-----------------------------------------------------------------------
# HaveItem()
# Check if player have this item
# Arguments: $ITEM(int)
#-----------------------------------------------------------------------
HaveItem() { ((CHAR_ITEMS > $1)) && return 0 || return 1; }

#-----------------------------------------------------------------------
# CheckHotzones()
# Check if this GPS is in the items array (${HOTZONE[@]})
# Arguments: $GPS(string [A-R][1-15])
# Used: HotzonesDistribute(), CheckForItem()
#-----------------------------------------------------------------------
CheckHotzones() {
    [[ $(grep -E "(^| )$1( |$)" <<< "${HOTZONE[@]}") ]] && return 0 || return 1
}

#-----------------------------------------------------------------------
# HotzonesDistribute()
# Scatters special items across the map
# Arguments: $CHAR_ITEMS(int)
# Used: ItemWasFound(), Intro()
#-----------------------------------------------------------------------
HotzonesDistribute() {
    local ITEMS_2_SCATTER=$((MAX_ITEMS - $1))                     # Scatter only absent items
    HOTZONE=()                                                    # Reset HOTZONE
    while ((ITEMS_2_SCATTER > 0)) ; do			          # If player already have all items, ITEMS_2_SCATTER'll be 0
	local ITEM_GPS=$(XYtoGPS $(RollDice2 18) $(RollDice2 15)) # Create random item GPS
	[[ "$ITEM_GPS" == "$CHAR_GPS" ]] && continue              # Reroll if HOTZONE == CHAR_GPS
	CheckHotzones "$ITEM_GPS" && continue                     # Reroll if "$ITEM" is already in ${HOTZONE[@]}
	((ITEMS_2_SCATTER--))                                     # Decrease ITEMS_2_SCATTER (because array starts from ${HOTZONE[0]} #kstn)
	HOTZONE["$ITEMS_2_SCATTER"]="$ITEM_GPS"                   # Init ${HOTZONE[ITEMS_2_SCATTER]},
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
# Arguments: $CHAR_GPS([A-R][1-15])
# Used: NewSector()
#-----------------------------------------------------------------------
CheckForItem() { ((CHAR_ITEMS < MAX_ITEMS)) && CheckHotzones $1 && ItemWasFound ; } # TODO!!! CHECK IT!!! #kstn

#                                                                      #
#                                                                      #
########################################################################

