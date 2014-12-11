########################################################################
#                        Town (secondary loop)                         #
#                                                                      #

# Quick tip: use echo "_____________DEBUG whatever______________" >2 # DEBUG
# To output debug data to debugger (and not to stdout).
    

#-----------------------------------------------------------------------
# CheckForGold()
# Check if char have $PRICE Gold and divide it from $CHAR_GOLD or
#  return $FAILURE_VESSAGE
# Arguments: $PRICE(int), $FAILURE_VESSAGE(string)
# Used: Tavern()
#-----------------------------------------------------------------------
CheckForGold()   {
	if (( $(bc <<< "$CHAR_GOLD < $1") )); then
	echo -e "${CLEAR_LINE}${2}"               # Idea: If we're going to use these in grocer, merchant ++future functions then perhaps it should ONLY be logical (return 1 or 0).
	return 1                                  # I think it will make the code easier to read later on, see the difference between:
    else                                      # CheckForGold 3 "You don't have enough gold, silly dwarf"
	CHAR_GOLD=$(bc <<< "$CHAR_GOLD - $1")     # # vs
	return 0                                  # CheckForGold 3 && Continue_transaction || echo "You don't have enough gold, silly dwarf!"
    fi                                        #
}                                             # The first one looks as if the silly dwarf doesn't have enough gold from the get go..?
                                              # On the other hand, a "purchasing function" might be called for, so we don't duplicate so much work.

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
	(( CHAR_HEALTH += 30 ))			   # Add Town_Health * 2
	(( CHAR_HEALTH > 150 )) && CHAR_HEALTH=150 # And restrict if to 150
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
	MakePrompt "(R)ent a room and rest safely;(P)lay dice;(A)ny key to Exit"
	case $(Read) in
	    r | R) 
		echo -en "${CLEAR_LINE}      rent for 1 (G)old      rent for 1 (T)obacco      (A)ny key to Exit"
		case $(Read) in
		    g | G ) CheckForGold 1    "You don't have enough Gold to rent a room in the Tavern"    && TavernRest ;;
		    t | T ) CheckForTobacco 1 "You don't have enough Tobacco to rent a room in the Tavern" && TavernRest ;;
		esac 
		sleep 1 ;;
 	    p | P ) MiniGame_Dice ;;
	    * ) break ;; # Leave tavern
	esac
    done
} 



#-----------------------------------------------------------------------
# Marketplace()                                                  Town.sh
# Used: GoIntoTown()
#-----------------------------------------------------------------------
Marketplace() { 
    # The PRICE of a unit (food, ale) is always 1. #??? #kstn
    while (true); do
	GX_Marketplace
	MakePrompt '(G)rocer;(M)erchant;(L)eave Marketplace'
	case $(Read) in
	    g | G) Marketplace_Grocer;;   # Trade FOOD for GOLD and TOBACCO
	    m | M) Marketplace_Merchant;; # Trade TOBACCO <-> GOLD ??? Or what?? #kstn
	    # Smbd who'll trade boars' tusks etc for GOLD/TOBACCO ???
	    *) break ;; # Leave marketplace
	esac
    done
}

#-----------------------------------------------------------------------
# Marketplace_Merchant_Bargaining()                              Town.sh
# Used: Marketplace_Merchant()
# Arguments: either "$MERCHANTVAR" or "$MERCHANDISE"
#-----------------------------------------------------------------------
Marketplace_Merchant_Bargaining() {
	GX_Marketplace_Merchant
	tput sc
    case "$1" in
	    "Food" | F | f ) 	MERCHANDISE="food"
							MvAddStr 7 4 "$MERCHANT_FxG Gold or $MERCHANT_FxT Tobacco."           # FxG, FxT (sell for gold/tobacco)
							MvAddStr 10 4 "for $MERCHANT_GxF Gold or $MERCHANT_TxF Tobacco each!" # GxF, TxF (buy  for food/tobacco)
							MERCHANDISE="Food"
							;;
	    "Tobacco" | T | t )	MERCHANDISE="tobacco"
							MvAddStr 7 4 "$MERCHANT_TxG Gold or $MERCHANT_TxF Food."              # TxG, TxF
							MvAddStr 10 4 "for $MERCHANT_GxT Gold or $MERCHANT_FxT Food each!"    # GxT, FxT
							MERCHANDISE="Tobacco"
							;;
	    "Gold" | G | g )	MERCHANDISE="gold"
							MvAddStr 7 4 "$MERCHANT_GxT Tobacco or $MERCHANT_GxF Food."           # GxT, GxF
							MvAddStr 10 4 "for $MERCHANT_TxG Tobacco or $MERCHANT_FxG Food each!" # TxG, FxG
							MERCHANDISE="Gold"
							;;
	    "Item" | I | i )	MERCHANDISE="item"
							MvAddStr 7 4 "yours for $MERCHANT_IxG Gold!"
							MERCHANDISE="Item"
							;;
		* ) MERCHANDISE="unknown"
							;;
	esac
	if [[ "$MERCHANDISE" = "Item" ]] ; then
	    MvAddStr 4 4 "You are in for a treat! I managed to"
	    MvAddStr 5 4 "acquire a very rare and valuable"
	    MvAddStr 6 4 "$MERCHANT_ITEM, which can be"
	    MvAddStr 9 4 "I also buy any items you sell"
	    MvAddStr 10 4 "for $MERCHANT_GxI Gold a piece."
	elif [[ "$MERCHANDISE" = "unknown" ]] ; then
		MvAddStr 4 4 "You surely jest!"
		MvAddStr 6 4 "I have never heard about $1,"
		MvAddStr 7 4 "not once in all of my travels!"
		MvAddStr 9 4 "I cannot trade in unknowns.."
	else
	    MvAddStr 4 4 "But of course! Here are my prices:"
	    MvAddStr 6 4 "I sell 1 $MERCHANDISE to you for"
	    MvAddStr 9 4 "Or I can buy 1 $MERCHANDISE from you,"
	fi
	tput rc
}


#-----------------------------------------------------------------------
# Marketplace_Merchant()                                         Town.sh
# Used: GoIntoTown()
#-----------------------------------------------------------------------
Marketplace_Merchant() {
    # If this is a "freshly entered" town, re-do prices
    if [ -z "$MERCHANT" ] || [ "$MERCHANT" != "$CHAR_GPS" ] ; then
	# "Name" the current merchant as char GPS location
	MERCHANT="$CHAR_GPS"

	# Set BUY & SELL prices at defaults (Food, Tobacco, Gold)
    MERCHANT_FxG=$PRICE_FxG && MERCHANT_FxT=$PRICE_FxT && MERCHANT_GxT=$PRICE_GxT && MERCHANT_GxF=$PRICE_GxF && MERCHANT_TxG=$PRICE_TxG && MERCHANT_TxF=$PRICE_TxF
    
    # Set prices for items (1 item is worth 2x Food)
    PRICE_IxG=$( bc <<< "scale=2;$MERCHANT_FxG*2" ) && MERCHANT_IxG=$PRICE_IxG
    PRICE_GxI=$( bc <<< "scale=2;$MERCHANT_GxF*2" ) && MERCHANT_GxI=$PRICE_GxI
    
	# Create semi-random profit/discount margin
	RollDice 3
	local MERCHANT_MARGIN=$( bc <<< "scale=2;$DICE*$VAL_CHANGE" )

	# Add positive and negative margins to what the merchant wants to keep for himself
	RollDice 3
	case "$DICE" in                                                              # Merchant WANTS to buy and only reluctantly sells:
	    1 ) MERCHANT_FxG=$( bc <<< "scale=2;$MERCHANT_FxG+$MERCHANT_MARGIN" )    # Food (player's cost in gold purchasing food)
			MERCHANT_GxF=$( bc <<< "scale=2;$MERCHANT_GxF-$MERCHANT_MARGIN" )    # Food (player's discount in food purchasing gold) 
			MERCHANT_FxT=$( bc <<< "scale=2;$MERCHANT_FxT+$MERCHANT_MARGIN" )
			MERCHANT_TxF=$( bc <<< "scale=2;$MERCHANT_TxF-$MERCHANT_MARGIN" ) ;;
		2 ) MERCHANT_TxG=$( bc <<< "scale=2;$MERCHANT_TxG+$MERCHANT_MARGIN" )    # Tobacco (player's cost in gold purchasing tobacco)
			MERCHANT_GxT=$( bc <<< "scale=2;$MERCHANT_GxT-$MERCHANT_MARGIN" )    # Tobacco (player's discount in tobacco purchasing gold) 
			MERCHANT_TxF=$( bc <<< "scale=2;$MERCHANT_TxF+$MERCHANT_MARGIN" )
			MERCHANT_FxT=$( bc <<< "scale=2;$MERCHANT_FxT-$MERCHANT_MARGIN" ) ;;
		3 ) MERCHANT_GxF=$( bc <<< "scale=2;$MERCHANT_GxF+$MERCHANT_MARGIN" )    # Gold (player's cost in food purchasing gold)
			MERCHANT_FxG=$( bc <<< "scale=2;$MERCHANT_FxG-$MERCHANT_MARGIN" )    # Gold (player's discount in gold purchasing food)
			MERCHANT_GxT=$( bc <<< "scale=2;$MERCHANT_GxT+$MERCHANT_MARGIN" )
			MERCHANT_TxG=$( bc <<< "scale=2;$MERCHANT_TxG-$MERCHANT_MARGIN" )
			MERCHANT_GxI=$( bc <<< "scale=2;$MERCHANT_GxI+$MERCHANT_MARGIN" )    # You can only buy/sell items with gold
			MERCHANT_IxG=$( bc <<< "scale=2;$MERCHANT_IxG-$MERCHANT_MARGIN" ) ;;
	esac
	
	# Set any value equal or below 0 to defaults
	# Ugly yet POSIX compliant code from mywiki.wooledge.org/BashFAQ/022
	case $(bc <<< "scale=2;$MERCHANT_FxG - 0.00" ) in
	0 | -*) MERCHANT_FxG=$PRICE_FxG ;;
	esac
	case $(bc <<< "scale=2;$MERCHANT_GxF - 0.00" ) in
	0 | -*) MERCHANT_GxF=$PRICE_GxF ;;
	esac
	case $(bc <<< "scale=2;$MERCHANT_FxT - 0.00" ) in
	0 | -*) MERCHANT_FxT=$PRICE_FxT ;;
	esac
	case $(bc <<< "scale=2;$MERCHANT_TxF - 0.00" ) in
	0 | -*) MERCHANT_TxF=$PRICE_TxF  ;;
	esac
	case $(bc <<< "scale=2;$MERCHANT_GxT - 0.00" ) in
	0 | -*) MERCHANT_GxT=$PRICE_GxT ;;
	esac
	case $(bc <<< "scale=2;$MERCHANT_TxG - 0.00" ) in
	0 | -*) MERCHANT_TxG=$PRICE_TxG  ;;
	esac
	case $(bc <<< "scale=2;$MERCHANT_GxI - 0.00" ) in
	0 | -*) MERCHANT_GxI=$PRICE_GxI ;;
	esac
	case $(bc <<< "scale=2;$MERCHANT_IxG - 0.00" ) in
	0 | -*) MERCHANT_IxG=$PRICE_IxG ;;
	esac

	# Merchant sells this item (but will buy e.g. fur, tusks etc.)
	RollDice 5
	case "$DICE" in
		1 ) MERCHANT_ITEM="Health Potion (5 HP)"  ;; # TODO
		2 ) MERCHANT_ITEM="Health Potion (10 HP)" ;; # Construct numbered list in ARRAY instead..?
		3 ) MERCHANT_ITEM="Health Potion (15 HP)" ;; # This way we can add more seamlessly..
		4 ) MERCHANT_ITEM="Health Potion (20 HP)" ;;
		5 ) MERCHANT_ITEM="Almanac"               ;;
	esac
	(( ALMANAC == 0 )) && MERCHANT_ITEM="Almanac"	
	fi
    # Merchant Loop
    while (true) ; do
	GX_Marketplace_Merchant
	local M_Y=4                # Setup default greeting
	local MERCHANT_MSG=("" "weather-beaten Traveller!" "galant Elf of the Forests!" "fierce master Dwarf!" "young master Hobbit!") # [0] is dummy
	tput sc && MvAddStr $M_Y 4 "Oye there, ${MERCHANT_MSG[$CHAR_RACE]}"
	local MERCHANT_MSG=( "" "" "" "" "" "Me and my Caravan travel far and wide" "to provide the Finest Merchandise" "in the Realm, and at the best"
	    "possible prices! I buy everything" "and sell only the best, 'tis true!" "What are you looking for?" )  && (( M_Y++ )) # [0-4] are dummies
	while (( M_Y <= 10 )) ; do # Output default greeting
	    MvAddStr $M_Y 4 "${MERCHANT_MSG[$M_Y]}"
	    (( M_Y++ ))
	done
	tput rc
	read -sn 1 -p "$(MakePrompt '(F)ood;(T)obacco;(G)old;(I)tems;(N)othing')" MERCHANTVAR 2>&1
	case "$MERCHANTVAR" in
	F | f | T | t | G | g | I | i ) Marketplace_Merchant_Bargaining	"$MERCHANTVAR" ;;
    * ) break ;;
	esac

	# DEBUG DATA
	echo "        DEBUG       In the beginning.." >2
	echo "        DEBUG       MERCHANTVAR: $MERCHANTVAR" >2
	echo "        DEBUG       MERCHANDISE: $MERCHANDISE" >2
	# // DEBUG DATA
	
	tput sc
	MvAddStr 12 4 "Are you buying or selling?"
	tput rc
	read -sn 1 -p "$(MakePrompt '(B)uying;(S)elling;(J)ust Looking')" MERCHANTVAR 2>&1
	Marketplace_Merchant_Bargaining "$MERCHANDISE"
	local QUANTITY && local COST_GOLD && local COST_TOBACCO && local COST_FOOD && local COST_ITEM && local TRANSACTION_STATUS && local BARGAIN_TYPE
	case "$MERCHANTVAR" in
	b | B ) BARGAIN_TYPE=1  ;; # Buying  MERCHANDISE ($MERCHANDISE) from Merchant using MERCHANT_GxF (G
	s | S ) BARGAIN_TYPE=2  ;; # Selling STOCK ($MERCHANDISE) to Merchant
	* )     BARGAIN_TYPE=3  ;; # Invalid input
	esac
	
	# DEBUG DATA
	echo "        DEBUG       Filter bargain type" >2
	echo "        DEBUG       BARGAIN_TYPE: $BARGAIN_TYPE" >2
	# // DEBUG DATA
	
	if (( BARGAIN_TYPE != 3 )) && [[ MERCHANDISE != "unknown" ]] ; then	
		# Prompt for Quantity
		local QUANTITYPROMPT
		[[ "$MERCHANDISE" = "Item" ]] && QUANTITYPROMPT=" How many $MERCHANT_ITEMs" || QUANTITYPROMPT=" How much $MERCHANDISE"
		QUANTITYPROMPT+=" do you want to "
		(( BARGAIN_TYPE == 1 )) && QUANTITYPROMPT+="buy? " || QUANTITYPROMPT+="sell? "
		echo -en "$QUANTITYPROMPT" && read QUANTITY 2>&1
		
		# Exit if amount is 0 (this is equal to "cancel")
		(( QUANTITY == 0 )) && break
	
			# DEBUG DATA
			echo "        DEBUG       Prompt for quantity" >2
			echo "        DEBUG       QUANTITY: $QUANTITY" >2
			# // DEBUG DATA
	
		
		# Calculate COST (for PLAYER or MERCHANT depending on BARGAIN TYPE)
		(( BARGAIN_TYPE == 1 )) && echo -n " $QUANTITY $MERCHANDISE costs " # TODO verify/Check whether this should be -n or -en "\n" (after read -p)
		(( BARGAIN_TYPE == 2 )) && echo -n " I'll give you" # TODO verify/Check whether this should be -n or -en "\n" (after read -p)

		case "$MERCHANDISE" in
		"Food" )    (( BARGAIN_TYPE == 1 )) && COST_GOLD=$( bc <<< "$MERCHANT_FxG * $QUANTITY" )
					(( BARGAIN_TYPE == 2 )) && COST_GOLD=$( bc <<< "$MERCHANT_GxF * $QUANTITY" )
					(( BARGAIN_TYPE == 1 )) && COST_TOBACCO=$( bc <<< "$MERCHANT_FxT * $QUANTITY" )
					(( BARGAIN_TYPE == 2 )) && COST_TOBACCO=$( bc <<< "$MERCHANT_TxF * $QUANTITY" )
					echo -n "$COST_GOLD Gold or $COST_TOBACCO Tobacco"
					;;
		"Tobacco" ) (( BARGAIN_TYPE == 1 )) && COST_GOLD=$( bc <<< "$MERCHANT_TxG * $QUANTITY" )
					(( BARGAIN_TYPE == 2 )) && COST_GOLD=$( bc <<< "$MERCHANT_GxT * $QUANTITY" ) 
					(( BARGAIN_TYPE == 1 )) && COST_FOOD=$( bc <<< "$MERCHANT_TxF * $QUANTITY" )
					(( BARGAIN_TYPE == 2 )) && COST_FOOD=$( bc <<< "$MERCHANT_FxT * $QUANTITY" )
					echo -n "$COST_GOLD Gold or $COST_FOOD Food" 
					;;
		"Gold" )    (( BARGAIN_TYPE == 1 )) && COST_FOOD=$( bc <<< "$MERCHANT_GxF * $QUANTITY" )
					(( BARGAIN_TYPE == 2 )) && COST_FOOD=$( bc <<< "$MERCHANT_FxG * $QUANTITY" )
					(( BARGAIN_TYPE == 1 )) && COST_TOBACCO=$(bc <<< "$MERCHANT_TxG * $QUANTITY" )
					(( BARGAIN_TYPE == 2 )) && COST_TOBACCO=$(bc <<< "$MERCHANT_GxT * $QUANTITY" )
					echo -n "$COST_FOOD Food or $COST_TOBACCO Tobacco"
					;;
		"Item" )    (( BARGAIN_TYPE == 1 )) && COST_GOLD=$( bc <<< "$MERCHANT_IxG * $QUANTITY" )
					(( BARGAIN_TYPE == 2 )) && COST_GOLD=$( bc <<< "$MERCHANT_GxI * $QUANTITY" )
					echo -n "$COST_GOLD Gold" 
					;;
		esac
		(( BARGAIN_TYPE == 1 )) && echo "." || echo " for $QUANTITY $MERCHANDISE."
		
		# Create bargaining prompt
		case "$MERCHANDISE" in
		"Food" )    read -sn 1 -p "$(MakePrompt 'Trade for (G)old;Trade for (T)obacco;(N)ot Interested')" MERCHANTVAR 2>&1        ;;
		"Tobacco" ) read -sn 1 -p "$(MakePrompt 'Trade for (G)old;Trade for (F)ood;(N)ot Interested')" MERCHANTVAR 2>&1           ;;
		"Gold" )    read -sn 1 -p "$(MakePrompt 'Trade for (F)ood;Trade for (T)obacco;(N)ot Interested')" MERCHANTVAR 2>&1        ;;
		"Item" )    (( BARGAIN_TYPE == 1 )) && read -sn 1 -p "$(MakePrompt 'Trade for (G)old;(N)ot Interested')" MERCHANTVAR 2>&1
					(( BARGAIN_TYPE == 2 )) && MERCHANTVAR="N"                                                                    ;; # TODO Temp workaround (have no items to sell)
		esac
		
		# DEBUG DATA
		echo "        DEBUG       Create bargaining prompt" >2
		echo "        DEBUG       MERCHANTVAR: $MERCHANTVAR" >2
		# // DEBUG DATA
		
		
		# Determine that player has CURRENCY to cover COST or STOCK to cover SALE
		case "$MERCHANTVAR" in
		T | t ) MERCHANTVAR="Tobacco" && (( $(bc <<< "$CHAR_TOBACCO > $COST_TOBACCO") )) && TRANSACTION_STATUS=0 || TRANSACTION_STATUS=1 ;; # Legend
		F | f ) MERCHANTVAR="Food"    && (( $(bc <<< "$CHAR_FOOD > $COST_FOOD") ))       && TRANSACTION_STATUS=0 || TRANSACTION_STATUS=1 ;; # 0 = CHAR has that amount
		G | g ) MERCHANTVAR="Gold"    && (( $(bc <<< "$CHAR_GOLD > $COST_GOLD") ))       && TRANSACTION_STATUS=0 || TRANSACTION_STATUS=1 ;; # 1 = CHAR does not have it
		I | i ) MERCHANTVAR="Item"    && TRANSACTION=1  ;; # Selling items not yet implemented                             ;; # 1 = ""
		N | n ) TRANSACTION_STATUS=4                                                                                      				 ;; # 4 = CHAR is not interested
		* )     TRANSACTION_STATUS=2                                                                                       				 ;; # 2 = invalid input
		esac
	
		# DEBUG DATA
		echo "        DEBUG       Summary BEFORE transaction" >2
		echo "        DEBUG       MERCHANDISE: $MERCHANDISE" >2
		echo "        DEBUG       QUANTITY:    $QUANTITY" >2
		echo "        DEBUG       MERCHANTVAR: $MERCHANTVAR" >2
		echo "        DEBUG       COST_GOLD:   $COST_GOLD" >2
		echo "        DEBUG       COST_TOBACCO $COST_TOBACCO" >2
		echo "        DEBUG       COST_FOOD:   $COST_FOOD" >2
		echo "        DEBUG       COST_ITEM:   $COST_ITEM" >2
		echo "        DEBUG       TRANSACTION: $TRANSACTION_STATUS" >2
		echo "        DEBUG       CHAR_TOBAC:  $CHAR_TOBACCO" >2
		echo "        DEBUG       CHAR_GOLD:   $CHAR_GOLD" >2
		echo "        DEBUG       CHAR_FOOD:   $CHAR_FOOD" >2
		# // DEBUG
	
	
		# Do the transaction if it is valid
		# Info: The COST can be the player's (for BARGAIN_TYPE 1 ) or the merchant's (for BARGAIN_TYPE 2).
		if (( TRANSACTION_STATUS == 0 )) ; then
		MERCHANTVAR+="-$MERCHANDISE"
		case "$MERCHANTVAR" in  # Conduct transaction for filtered (valid) transactions in THING-PAYMENT
		"Tobacco-Food" ) (( BARGAIN_TYPE == 1 )) && CHAR_TOBACCO=$(bc <<< "$CHAR_TOBACCO - $COST_TOBACCO" ) && CHAR_FOOD=$(bc <<< "${CHAR_FOOD} + ${QUANTITY}")
						 (( BARGAIN_TYPE == 2 )) && CHAR_TOBACCO=$(bc <<< "$CHAR_TOBACCO + $COST_TOBACCO" ) && CHAR_FOOD=$(bc <<< "${CHAR_FOOD} - ${QUANTITY}")
						 ;;
		"Tobacco-Gold" ) (( BARGAIN_TYPE == 1 )) && CHAR_TOBACCO=$(bc <<< "$CHAR_TOBACCO - $COST_TOBACCO" ) && CHAR_GOLD=$(bc <<< "${CHAR_GOLD} + ${QUANTITY}")
						 (( BARGAIN_TYPE == 2 )) && CHAR_TOBACCO=$(bc <<< "$CHAR_TOBACCO + $COST_TOBACCO" ) && CHAR_GOLD=$(bc <<< "${CHAR_GOLD} - ${QUANTITY}")
						 ;;
		"Food-Gold" )    (( BARGAIN_TYPE == 1 )) && CHAR_FOOD=$(bc <<< "$CHAR_FOOD - $COST_FOOD" ) && CHAR_GOLD=$(bc <<< "${CHAR_GOLD} + ${QUANTITY}")
						 (( BARGAIN_TYPE == 2 )) && CHAR_FOOD=$(bc <<< "$CHAR_FOOD + $COST_FOOD" ) && CHAR_GOLD=$(bc <<< "${CHAR_GOLD} - ${QUANTITY}")
						 ;;
		"Food-Tobacco" ) (( BARGAIN_TYPE == 1 )) && CHAR_FOOD=$(bc <<< "$CHAR_FOOD - $COST_FOOD" ) && CHAR_TOBACCO=$(bc <<< "${CHAR_TOBACCO} + ${QUANTITY}")
						 (( BARGAIN_TYPE == 2 )) && CHAR_FOOD=$(bc <<< "$CHAR_FOOD + $COST_FOOD" ) && CHAR_TOBACCO=$(bc <<< "${CHAR_TOBACCO} - ${QUANTITY}")
						 ;;
		"Gold-Food" )    (( BARGAIN_TYPE == 1 )) && CHAR_GOLD=$(bc <<< "$CHAR_GOLD - $COST_GOLD" ) && CHAR_FOOD=$(bc <<< "${CHAR_FOOD} + ${QUANTITY}")
						 (( BARGAIN_TYPE == 2 )) && CHAR_GOLD=$(bc <<< "$CHAR_GOLD + $COST_GOLD" ) && CHAR_FOOD=$(bc <<< "${CHAR_FOOD} - ${QUANTITY}")
						 ;;
		"Gold-Tobacco" ) (( BARGAIN_TYPE == 1 )) && CHAR_GOLD=$(bc <<< "$CHAR_GOLD - $COST_GOLD" ) && CHAR_TOBACCO=$(bc <<< "${CHAR_TOBACCO} + ${QUANTITY}")
						 (( BARGAIN_TYPE == 2 )) && CHAR_GOLD=$(bc <<< "$CHAR_GOLD + $COST_GOLD" ) && CHAR_TOBACCO=$(bc <<< "${CHAR_TOBACCO} - ${QUANTITY}")
						 ;;
		"Gold-Item" )    (( BARGAIN_TYPE == 1 )) && CHAR_GOLD=$(bc <<< "$CHAR_GOLD - $COST_GOLD" )
						 (( BARGAIN_TYPE == 2 )) && CHAR_GOLD=$(bc <<< "$CHAR_GOLD + $COST_GOLD" )
						 ;; # Items are added/used/removed below
		* )              TRANSACTION_STATUS=3
		                 ;; # invalid input of other type (e.g. hitting (T)obacco to buy Item. Nice try:)
		esac
		fi
	
		# DEBUG DATA
		echo "        DEBUG       Summary AFTER transaction" >2
		echo "        DEBUG       MERCHANDISE: $MERCHANDISE" >2
		echo "        DEBUG       QUANTITY:    $QUANTITY" >2
		echo "        DEBUG       MERCHANTVAR: $MERCHANTVAR" >2
		echo "        DEBUG       COST_GOLD:   $COST_GOLD" >2
		echo "        DEBUG       COST_TOBACCO $COST_TOBACCO" >2
		echo "        DEBUG       COST_FOOD:   $COST_FOOD" >2
		echo "        DEBUG       COST_ITEM:   $COST_ITEM" >2
		echo "        DEBUG       TRANSACTION: $TRANSACTION_STATUS" >2
		echo "        DEBUG       CHAR_TOBAC:  $CHAR_TOBACCO" >2
		echo "        DEBUG       CHAR_GOLD:   $CHAR_GOLD" >2
		echo "        DEBUG       CHAR_FOOD:   $CHAR_FOOD" >2
		# // DEBUG
	
	
		# Create transaction status output (MERCHANT_CONFIRMATION)
		Marketplace_Merchant_Bargaining "$MERCHANDISE"
		local MERCHANT_CONFIRMATION
		local IFS="-" && set "$MERCHANTVAR"
		case "$TRANSACTION_STATUS" in
		1 )     MERCHANT_CONFIRMATION="Not enough $1 to buy $QUANTITY"              ;; # Invalid transaction
		2 | 3 ) MERCHANT_CONFIRMATION="Sorry, I don't accept that trade .."         ;; # Invalid input
		4 )     MERCHANT_CONFIRMATION="Welcome back anytime, friend!"               ;; # Not interested
		0 ) 	# Valid transactions
				(( BARGAIN_TYPE == 1 )) && MERCHANT_CONFIRMATION="You bought" || MERCHANT_CONFIRMATION="You sold"
				MERCHANT_CONFIRMATION+=" $QUANTITY $MERCHANDISE for "
				case "$1" in
				"Tobacco" ) MERCHANT_CONFIRMATION+="$COST_TOBACCO Tobacco "
							(( BARGAIN_TYPE == 1 )) && MERCHANT_CONFIRMATION+="[ -$COST_TOBACCO TOBACCO ]"
							(( BARGAIN_TYPE == 2 )) && MERCHANT_CONFIRMATION+="[ +$COST_TOBACCO TOBACCO ]"
							;;
				"Food" )    MERCHANT_CONFIRMATION+="$COST_FOOD Food "
							(( BARGAIN_TYPE == 1 )) && MERCHANT_CONFIRMATION+="[ -$COST_FOOD FOOD ]"
							(( BARGAIN_TYPE == 2 )) && MERCHANT_CONFIRMATION+="[ +$COST_FOOD FOOD ]"
							;;
				"Gold" )    MERCHANT_CONFIRMATION+="$COST_GOLD Gold "
							(( BARGAIN_TYPE == 1 )) && MERCHANT_CONFIRMATION+="[ -$COST_GOLD GOLD ]"
							(( BARGAIN_TYPE == 2 )) && MERCHANT_CONFIRMATION+="[ +$COST_GOLD GOLD ]"
							;;
				esac
				;;
		esac
		
		# Output MERCHANT_CONFIRMATION ("goodbye")
		tput sc
		MvAddStr 14 4 "$MERCHANT_CONFIRMATION"
		tput rc

		if [[ $BARGAIN_TYPE = 1 ]] && [[ $TRANSACTION_STATUS = 0 ]] && [[ "$MERCHANDISE" = "Item" ]] ; then # Post purchase immediate usage of items (TODO we can change this later)
		Marketplace_Merchant_Bargaining "$MERCHANDISE"                                       # TODO This should change when we have inventory system setup..
			if [[ "$MERCHANT_ITEM" = "Almanac" ]] ; then
				echo " You put the Almanac in your inventory. Access inventory from (C)haracter sheet."
				INV_ALMANAC=1
			else
				case "$MERCHANT_ITEM" in
				"Health Potion (5 HP)"  ) local POTIONMODIFIER=5  ;;
				"Health Potion (10 HP)" ) local POTIONMODIFIER=10 ;;
				"Health Potion (15 HP)" ) local POTIONMODIFIER=15 ;;
				"Health Potion (20 HP)" ) local POTIONMODIFIER=20 ;;
				esac
				(( CHAR_HEALTH += POTIONMODIFIER ))
				echo " You drink the $MERCHANT_ITEM, restoring $POTIONMODIFIER health points [ + $POTIONMODIFIER HEALTH ]"
			fi
		fi # TODO add elif here for removal of items (BARGAIN_TYPE=2) from inventory later
		PressAnyKey
	fi
    done
} # Return to Marketplace

#-----------------------------------------------------------------------
# Marketplace_Grocer()
# Used: GoIntoTown()
# IDEA:
# ? Add stealing from market??? 
#   Good idea, but we'd have to arrange a fight and new enemy type (shopkeep)..
#   Or he call the police (the guards?) and they throw player from town? (kstn)
#-----------------------------------------------------------------------
Marketplace_Grocer() { 
    # The PRICE of units are set in WorldPriceFixing()
    while (true); do
	GX_Marketplace_Grocer
	tput sc                                      # save cursor position
	MvAddStr 10 4 "1 FOOD costs $PRICE_FxG Gold" # move to y=10, x=4 ( upper left corner is 0 0 )
	MvAddStr 11 4  "or $PRICE_FxT Tobacco.\""    # move to y=11, x=4 ( upper left corner is 0 0 )
	tput rc                                      # restore cursor position
	echo " Welcome to my shoppe, stranger! We have the right prices for you .." # Will be in GX_..
	echo " You currently have $CHAR_GOLD Gold, $CHAR_TOBACCO Tobacco and $CHAR_FOOD Food in your inventory"
	MakePrompt 'Trade for (G)old;Trade for (T)obacco;(L)eave'
	case $(Read) in
	    g | G )
		GX_Marketplace_Grocer
		read -p " How many food items do you want to buy? " QUANTITY 2>&1
		# TODO check for QUANTITY - if falls if QUANTITY != [0-9]+
		# TODO Perhaps this could help: stackoverflow.com/questions/806906/how-do-i-test-if-a-variable-is-a-number-in-bash
		local COST=$( bc <<< "$PRICE_FxG * $QUANTITY" )
		if (( $(bc <<< "$CHAR_GOLD > $COST") )); then
		    CHAR_GOLD=$(bc <<< "$CHAR_GOLD - $COST")
		    CHAR_FOOD=$(bc <<< "${CHAR_FOOD} + ${QUANTITY}")
		    echo " You bought $QUANTITY food for $COST Gold, and you have $CHAR_FOOD Food in your inventory"
		else
		    echo " You don't have enough Gold to buy $QUANTITY food yet. Try a little less!"
		fi
		read -n 1		
		;;
	    t | T )
		GX_Marketplace_Grocer
		read -p " How much food you want to buy? " QUANTITY 2>&1
		# TODO check for QUANTITY - if falls if QUANTITY != [0-9]+
		local COST=$( bc <<< "${PRICE_FxT} * $QUANTITY" )
		if (( $(bc <<< "$CHAR_TOBACCO > $COST") )); then
		    CHAR_TOBACCO=$(bc <<< "$CHAR_TOBACCO - $COST")
		    CHAR_FOOD=$(bc <<< "${CHAR_FOOD} + ${QUANTITY}")
		    echo " You traded $COST Tobacco for $QUANTITY food, and have $CHAR_FOOD Food in your inventory"
		else
		    echo " You don't have enough Tobacco to trade for $QUANTITY food yet. Try a little less!"
		fi
		read -n 1		
		;;
	    *) break;
	esac
    done
    unset PRICE_IN_GOLD PRICE_IN_TOBACCO
} # Return to GoIntoTown()

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
	GX_Place "T" # GX_Town 
	MakePrompt '(T)avern;(B)ulletin Board;(M)arketplace;(E)xit Town'
	case $(Read) in
	    t | T ) Tavern ;;
	    m | M ) Marketplace ;;
	    b | B ) GX_Bulletin "$BBSMSG" ;;
	    * ) break ;; # Leave town
	esac
    done
}

#                                                                      #
########################################################################

