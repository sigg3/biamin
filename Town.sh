########################################################################
#                        Town (secondary loop)                         #
#                                                                      #

#-----------------------------------------------------------------------
# CheckForGold()
# Check if char have $PRICE Gold and divide it from $CHAR_GOLD or
#  return $FAILURE_VESSAGE
# Arguments: $PRICE(int), $FAILURE_VESSAGE(string)
# Used: Tavern()
#-----------------------------------------------------------------------
CheckForGold()   {
    if (( $(bc <<< "$CHAR_GOLD < $1") )); then
	echo -e "${CLEAR_LINE}${2}"
	return 1
    else
	CHAR_GOLD=$(bc <<< "$CHAR_GOLD - $1")
	return 0
    fi
}

#-----------------------------------------------------------------------
# CheckForTobacco()
# Check if char have $PRICE Tobacco and divide it from $CHAR_TOBACCO or
#  return $FAILURE_VESSAGE
# Arguments: $PRICE(int), $FAILURE_VESSAGE(string)
# Used: Tavern()
#-----------------------------------------------------------------------
CheckForTobacco() {
    if (( $(bc <<< "$CHAR_TOBACCO < $1") )); then
	echo -e "${CLEAR_LINE}${2}"
	return 1
    else
	CHAR_TOBACCO=$(bc <<< "$CHAR_TOBACCO - $1")
	return 0
    fi
}

#-----------------------------------------------------------------------
# Tavern_Rest()
# Successful rest in Tavern (Tavern gained +30 HEALTH - Town*2 )
# Used: Tavern()
#-----------------------------------------------------------------------
TavernRest() {
    GX_Rest
    echo -n "You got some much needed rest .."
    if (( CHAR_HEALTH < 150 )); then
	(( CHAR_HEALTH += 30 ))
	(( CHAR_HEALTH > 150 )) && CHAR_HEALTH=150
	echo " and your HEALTH is $CHAR_HEALTH now"
    fi
    ((TURN++))
}

#-----------------------------------------------------------------------
# Tavern()
# Sub-loop for Tavern
# Used: GoIntoTown()
#-----------------------------------------------------------------------
Tavern() { 
    while (true); do
	GX_Tavern 
	read -sn1 -p "     (R)ent a room and rest safely     (P)lay dice     (A)ny key to Exit" VAR 2>&1
	case "$VAR" in
	    r | R) 
		echo -en "${CLEAR_LINE}      rent for 1 (G)old      rent for 1 (T)obacco      (A)ny key to Exit"
		read -s -n 1 CUR 2>&1
		case "$CUR" in
		    g | G ) CheckForGold 1    "You don't have enough Gold to rent a room in the Tavern"    && TavernRest ;;
		    t | T ) CheckForTobacco 1 "You don't have enough Tobacco to rent a room in the Tavern" && TavernRest ;;
		esac 
		sleep 1
		;;
 	    p | P ) MiniGame_Dice ;;
	    * ) break ;; # Leave tavern
	esac
    done
} 

#-----------------------------------------------------------------------
# Marketplace() 
# Used: GoIntoTown()
# TODO:
#  ? Add stealing from market??? 
#    Good idea, but we'd have to arrange a fight and new enemy type (shopkeep)..
#    Or he call the police (the guards?) and they throw player from town? (kstn) 
#    We're getting way ahead of ourselves:) Let's just make what we have work first:)
#-----------------------------------------------------------------------
Marketplace() { 
    # The PRICE of a unit (food, ale) is always 1. #??? #kstn
    while (true); do
	GX_Marketplace
	read -sn 1 -p "           (G)rocer          (M)erchant          (L)eave Marketplace" VAR 2>&1
	case "$VAR" in
	    g | G) Marketplace_Grocer;;   # Trade FOOD for GOLD and TOBACCO
	    m | M) Marketplace_Merchant;; # Trade TOBACCO <-> GOLD ??? Or what?? #kstn
	    # Smbd who'll trade boars' tusks etc for GOLD/TOBACCO ???
	    *) break ;; # Leave marketplace
	esac
    done
} 

#-----------------------------------------------------------------------
# GoIntoTown()
# Secondary loop for Town
# Used: NewSector()
# TODO:
# ? Add separate GX for this? 
# ? What about add separate GX for Town and use current GX_Town() here? #kstn
#-----------------------------------------------------------------------
GoIntoTown() { 
    while (true); do
	GX_Place "$SCENARIO" # GX_Town 
	read -sn 1 -p "      (T)avern      (B)ulletin Board      (M)arketplace      (E)xit Town" ACTION
	case "$ACTION" in
	    t | T ) Tavern ;;
	    m | M ) Marketplace ;;
	    b | B ) GX_Bulletin "$BBSMSG" ;;
	    * ) break ;; # Leave town
	esac
    done
} # Return to NewSector()


#                                                                      #
########################################################################

