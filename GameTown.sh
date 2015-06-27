########################################################################
#                        Town (secondary loop)                         #
#                                                                      #

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
	    [rR] ) echo -en "${CLEAR_LINE}$(MakePrompt "Rent for 1 (G)old;Rent for 1 (T)obacco;(A)ny key to Exit")"
		   case $(Read) in
		       [gG] ) declare -n CURRENCY=CHAR_GOLD; UNIT="Gold";;
		       [tT] ) declare -n CURRENCY=CHAR_TOBACCO; UNIT="Tobacco";;
		       *    ) continue ;;
		   esac
		   if (( $(bc <<< "${CURRENCY} < 1") )); then
		       echo -e "${CLEAR_LINE}$(MakePrompt "You don't have enough ${UNIT} to rent a room in the Tavern")"
		   else                                               # ex-TavernRest()
		       CURRENCY=$(bc <<< "${CURRENCY} - 1")
		       GX_Rest
		       if (( CHAR_HEALTH < 150 )); then
			   (( CHAR_HEALTH += 30 ))		      # Add Town_Health * 2
			   (( CHAR_HEALTH > 150 )) && CHAR_HEALTH=150 # And restrict if to 150
			   echo "You got some much needed rest and your HEALTH is $CHAR_HEALTH now"
		       else
			   echo "You got some much needed rest"
		       fi
		       ((STARVATION)) && ResetStarvation              # Reset STARVATION and restore starvation' penalty if any
		       NewTurn			                      # Increase $TURN and get new date
		   fi
		   unset -n CURRENCY
		   unset UNIT
		   Sleep 2
		   ;;
 	    [pP] ) MiniGame_Dice ;;
	    *    ) break ;;                                           # Leave tavern
	esac
    done
}


#-----------------------------------------------------------------------
# Marketplace()                                                  Town.sh
# Used: GoIntoTown()
#-----------------------------------------------------------------------
Marketplace() {
    if [ -z "$TOWN_GPS" ] || [ "$TOWN_GPS" != "$CHAR_GPS" ] ; then
	TOWN_GPS="$CHAR_GPS" # Baptize the town
	RollDice 10 # Determine whether we have a beggar or not
	(( DICE <= 4 )) && local BEGGAR=1 || local BEGGAR=0
	# IDEA This can be expanded to have other stuff than beggars (e.g. priests)
    fi
    while (true); do
	GX_Marketplace

	# TODO v. 3 (we need data for beggar's database first:)
	# if (( BEGGAR == 1 )) ; then
	#     MakePrompt '(G)rocer;(M)erchant;(B)eggar;(L)eave;(Q)uit'
	#     case $(Read) in
	# 	b | B) Marketplace_Beggar;;
	# 	g | G) Marketplace_Grocer;;
	# 	m | M) Marketplace_Merchant;;
	# 	q | Q ) CleanUp ;;
	# 	*) break ;; # Leave marketplace
	#     esac
	# elif (( BEGGAR == 0 )) ; then
	# fi

	# Make it easier Luke :) # kstn
	# case "$BEGGAR" in
	#     1) MakePrompt '(G)rocer;(M)erchant;(B)eggar;(L)eave;(Q)uit' ;;
	#     *) MakePrompt '(G)rocer;(M)erchant;(L)eave;(Q)uit'
	# esac
	#
	# Or perhaps even:
	# case "$(RollDice2 3)" in
	# 1 ) TOWN_FEATURE="Beggar"  ;;
	# 2 ) TOWN_FEATURE="Priest"  ;;
	# 3 ) TOWN_FEATURE="Gambler" ;;
	# esac
	#
	# MakePrompt '(G)rocer;(M)erchant;(${TOWN_FEATURE:0:1})${TOWN_FEATURE:1:6};(L)eave;(Q)uit'
	# # ~ sigg3 :)
	#
	# case $(Read) in
	#     b | B) ((BEGGAR == 1)) && Marketplace_Beggar;;
	#     g | G) Marketplace_Grocer;;
	#     m | M) Marketplace_Merchant;;
	#     q | Q ) CleanUp ;;
	#     *) break ;; # Leave marketplace
	# esac



	MakePrompt '(G)rocer;(M)erchant;(L)eave;(Q)uit'
	case $(Read) in
	    g | G) Marketplace_Grocer;;
	    m | M) Marketplace_Merchant;;
	    q | Q ) CleanUp ;;
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
				MvAddStr 7 4 "$PLAYER_BUYS_FxG Gold or $PLAYER_BUYS_FxT Tobacco."           # FxG, FxT (sell for gold/tobacco)
				MvAddStr 10 4 "for $PLAYER_SELL_GxF Gold or $PLAYER_SELL_TxF Tobacco each!" # GxF, TxF (buy  for food/tobacco)
				MERCHANDISE="Food"
				;;
	"Tobacco" | T | t )	MERCHANDISE="tobacco"
				MvAddStr 7 4 "$PLAYER_BUYS_TxG Gold or $PLAYER_BUYS_TxF Food."              # TxG, TxF
				MvAddStr 10 4 "for $PLAYER_SELL_GxT Gold or $PLAYER_SELL_FxT Food each!"    # GxT, FxT
				MERCHANDISE="Tobacco"
				;;
	"Gold" | G | g )	MERCHANDISE="gold"
				MvAddStr 7 4 "$PLAYER_BUYS_GxT Tobacco or $PLAYER_BUYS_GxF Food."           # GxT, GxF
				MvAddStr 10 4 "for $PLAYER_SELL_TxG Tobacco or $PLAYER_SELL_FxG Food each!" # TxG, FxG
				MERCHANDISE="Gold"
				;;
	"Item" | I | i )	MERCHANDISE="item"
				MvAddStr 7 4 "yours for $PLAYER_BUYS_IxG Gold!" # TODO will have to be re-done for items in v2.n+
				MERCHANDISE="Item"
				;;
	* ) MERCHANDISE="unknown"
	    ;;
    esac
    if [[ "$MERCHANDISE" = "Item" ]] ; then
	MvAddStr 4 4 "You are in for a treat! I managed to"
	MvAddStr 5 4 "acquire a very rare and valuable"
	MvAddStr 6 4 "${MERCHANT_ITEM^^}, it can be"         # TODO create a "centered" text based on length of MERCHANT_ITEM
	MvAddStr 9 4 "I also buy any items you sell"
	MvAddStr 10 4 "for $PLAYER_SELL_GxI Gold a piece."
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

	# TEMP WORKAROUND Set prices for items (1 item is worth 2x Food)
	PRICE_IxG=$( bc <<< "scale=2;$PRICE_FxG*2" ) # TODO v.2.n+
	PRICE_GxI=$( bc <<< "scale=2;$PRICE_GxF*2" ) # TODO Items are not priced in GameWorldChange but arbitrarily.

	# Create semi-random profit/discount margin in a function of VAL_CHANGE (econ. stability)
	RollDice 3
	local MERCHANT_MARGIN=$( bc <<< "scale=2;$DICE*$VAL_CHANGE" )

	# Add positive and negative margins to what the merchant wants to keep for himself
	RollDice 3

	local MERCHANT_PRICE_TEST=0
	while (( MERCHANT_PRICE_TEST != 12 )) ; do
		# Set default prices
		PLAYER_BUYS_FxG=$PRICE_FxG && PLAYER_SELL_FxG=$PRICE_FxG # Food  for gold
		PLAYER_BUYS_GxF=$PRICE_GxF && PLAYER_SELL_GxF=$PRICE_GxF # Gold  for food
		PLAYER_BUYS_FxT=$PRICE_FxT && PLAYER_SELL_FxT=$PRICE_FxT # Food  for tobacco
		PLAYER_BUYS_TxF=$PRICE_TxF && PLAYER_SELL_TxF=$PRICE_TxF # Tobac for food
		PLAYER_BUYS_GxT=$PRICE_GxT && PLAYER_SELL_GxT=$PRICE_GxT # Gold  for tobacco
		PLAYER_BUYS_TxG=$PRICE_TxG && PLAYER_SELL_TxG=$PRICE_TxG # Tobac for gold
		PLAYER_BUYS_GxI=$PRICE_GxI && PLAYER_SELL_GxI=$PRICE_GxI # Gold  for items
		PLAYER_BUYS_IxG=$PRICE_IxG && PLAYER_SELL_IxG=$PRICE_IxG # Items for gold

	# DEBUG DATA
	    echo "        DEBUG       Default buy and sell prices:" >2
	    echo "        DEBUG       PLAYER_BUYS_FxG: $PLAYER_BUYS_FxG" >2
	    echo "        DEBUG       PLAYER_SELL_FxG: $PLAYER_SELL_FxG" >2
	    echo "        DEBUG       PLAYER_BUYS_GxF: $PLAYER_BUYS_GxF" >2
	    echo "        DEBUG       PLAYER_SELL_GxF: $PLAYER_SELL_GxF" >2
	    echo "        DEBUG       PLAYER_BUYS_FxT: $PLAYER_BUYS_FxT" >2
	    echo "        DEBUG       PLAYER_SELL_FxT: $PLAYER_SELL_FxT" >2
	    echo "        DEBUG       PLAYER_BUYS_TxF: $PLAYER_BUYS_TxF" >2
	    echo "        DEBUG       PLAYER_SELL_TxF: $PLAYER_SELL_TxF" >2
	    echo "        DEBUG       PLAYER_BUYS_TxG: $PLAYER_BUYS_TxG" >2
	    echo "        DEBUG       PLAYER_SELL_TxG: $PLAYER_SELL_TxG" >2
	    echo "        DEBUG       PLAYER_BUYS_GxT: $PLAYER_BUYS_GxT" >2
	    echo "        DEBUG       PLAYER_SELL_GxT: $PLAYER_SELL_GxT" >2
	    echo "        DEBUG       PLAYER_BUYS_IxG: $PLAYER_BUYS_IxG" >2
	    echo "        DEBUG       PLAYER_SELL_IxG: $PLAYER_SELL_IxG" >2
	    echo "        DEBUG       PLAYER_BUYS_GxI: $PLAYER_BUYS_GxI" >2
	    echo "        DEBUG       PLAYER_SELL_GxI: $PLAYER_SELL_GxI" >2
	# // DEBUG

		case "$DICE" in
			1 ) # Merchant wants to keep food for himself
			PLAYER_BUYS_FxG=$( bc <<< "scale=2;$PRICE_FxG+$MERCHANT_MARGIN" )
			PLAYER_SELL_FxG=$( bc <<< "scale=2;$PRICE_FxG-$MERCHANT_MARGIN" )
			PLAYER_BUYS_GxF=$( bc <<< "scale=2;$PRICE_GxF+$MERCHANT_MARGIN" )
			PLAYER_SELL_GxF=$( bc <<< "scale=2;$PRICE_GxF-$MERCHANT_MARGIN" )
			PLAYER_BUYS_FxT=$( bc <<< "scale=2;$PRICE_FxT+$MERCHANT_MARGIN" )
			PLAYER_SELL_FxT=$( bc <<< "scale=2;$PRICE_FxT-$MERCHANT_MARGIN" )
			PLAYER_BUYS_TxF=$( bc <<< "scale=2;$PRICE_TxF+$MERCHANT_MARGIN" )
			PLAYER_SELL_TxF=$( bc <<< "scale=2;$PRICE_TxF-$MERCHANT_MARGIN" )
			;;
			2 ) # Merchant wants to keep tobacco for himself
			PLAYER_BUYS_TxG=$( bc <<< "scale=2;$PRICE_TxG+$MERCHANT_MARGIN" )
			PLAYER_SELL_TxG=$( bc <<< "scale=2;$PRICE_TxG-$MERCHANT_MARGIN" )
			PLAYER_BUYS_GxT=$( bc <<< "scale=2;$PRICE_GxT+$MERCHANT_MARGIN" )
			PLAYER_SELL_GxT=$( bc <<< "scale=2;$PRICE_GxT-$MERCHANT_MARGIN" )
			PLAYER_BUYS_TxF=$( bc <<< "scale=2;$PRICE_TxF+$MERCHANT_MARGIN" )
			PLAYER_SELL_TxF=$( bc <<< "scale=2;$PRICE_TxF-$MERCHANT_MARGIN" )
			PLAYER_BUYS_FxT=$( bc <<< "scale=2;$PRICE_FxT+$MERCHANT_MARGIN" )
			PLAYER_SELL_FxT=$( bc <<< "scale=2;$PRICE_FxT-$MERCHANT_MARGIN" )
			;;
			3 ) # Merchant wants to keep gold for himself
			PLAYER_BUYS_GxF=$( bc <<< "scale=2;$PRICE_GxF+$MERCHANT_MARGIN" )
			PLAYER_SELL_GxF=$( bc <<< "scale=2;$PRICE_GxF-$MERCHANT_MARGIN" )
			PLAYER_BUYS_FxG=$( bc <<< "scale=2;$PRICE_FxG+$MERCHANT_MARGIN" )
			PLAYER_SELL_FxG=$( bc <<< "scale=2;$PRICE_FxG-$MERCHANT_MARGIN" )
			PLAYER_BUYS_GxT=$( bc <<< "scale=2;$PRICE_GxT+$MERCHANT_MARGIN" )
			PLAYER_SELL_GxT=$( bc <<< "scale=2;$PRICE_GxT-$MERCHANT_MARGIN" )
			PLAYER_BUYS_TxG=$( bc <<< "scale=2;$PRICE_TxG+$MERCHANT_MARGIN" )
			PLAYER_SELL_TxG=$( bc <<< "scale=2;$PRICE_TxG-$MERCHANT_MARGIN" )
			PLAYER_BUYS_GxI=$( bc <<< "scale=2;$PRICE_GxI+$MERCHANT_MARGIN" ) # You can only buy/sell items with gold
			PLAYER_SELL_GxI=$( bc <<< "scale=2;$PRICE_GxI-$MERCHANT_MARGIN" )
			PLAYER_BUYS_IxG=$( bc <<< "scale=2;$PRICE_IxG+$MERCHANT_MARGIN" )
			PLAYER_SELL_IxG=$( bc <<< "scale=2;$PRICE_IxG-$MERCHANT_MARGIN" )
			;;
		esac

		# Verify prices are above 0, else redo them all
		(( $( bc <<< "if (${PLAYER_BUYS_GxF} <= 0) 0 else 1" ) == 1 )) && (( MERCHANT_PRICE_TEST++ ))
		(( $( bc <<< "if (${PLAYER_SELL_GxF} <= 0) 0 else 1" ) == 1 )) && (( MERCHANT_PRICE_TEST++ ))
		(( $( bc <<< "if (${PLAYER_BUYS_FxG} <= 0) 0 else 1" ) == 1 )) && (( MERCHANT_PRICE_TEST++ ))
		(( $( bc <<< "if (${PLAYER_SELL_FxG} <= 0) 0 else 1" ) == 1 )) && (( MERCHANT_PRICE_TEST++ ))
		(( $( bc <<< "if (${PLAYER_BUYS_GxT} <= 0) 0 else 1" ) == 1 )) && (( MERCHANT_PRICE_TEST++ ))
		(( $( bc <<< "if (${PLAYER_SELL_GxT} <= 0) 0 else 1" ) == 1 )) && (( MERCHANT_PRICE_TEST++ ))
		(( $( bc <<< "if (${PLAYER_BUYS_TxG} <= 0) 0 else 1" ) == 1 )) && (( MERCHANT_PRICE_TEST++ ))
		(( $( bc <<< "if (${PLAYER_SELL_TxG} <= 0) 0 else 1" ) == 1 )) && (( MERCHANT_PRICE_TEST++ ))
		(( $( bc <<< "if (${PLAYER_BUYS_GxI} <= 0) 0 else 1" ) == 1 )) && (( MERCHANT_PRICE_TEST++ ))
		(( $( bc <<< "if (${PLAYER_SELL_GxI} <= 0) 0 else 1" ) == 1 )) && (( MERCHANT_PRICE_TEST++ ))
		(( $( bc <<< "if (${PLAYER_BUYS_IxG} <= 0) 0 else 1" ) == 1 )) && (( MERCHANT_PRICE_TEST++ ))
		(( $( bc <<< "if (${PLAYER_SELL_IxG} <= 0) 0 else 1" ) == 1 )) && (( MERCHANT_PRICE_TEST++ ))

		echo "        DEBUG       MERCHANT_WANTS: $DICE (1 = Food, 2 = Tobacco, 3 = Gold) " >2
		(( MERCHANT_PRICE_TEST == 12 )) && echo "        DEBUG       PRICES OK" >2 # DEBUG
	done

	# DEBUG DATA
	    echo "        DEBUG       Summary AFTER price calculations: MERCHANT_WANTS=\"$DICE\" (1 = Food, 2 = Tobacco, 3 = Gold)" >2
	    echo "        DEBUG       PLAYER_BUYS_FxG: $PLAYER_BUYS_FxG" >2
	    echo "        DEBUG       PLAYER_SELL_FxG: $PLAYER_SELL_FxG" >2
	    echo "        DEBUG       PLAYER_BUYS_GxF: $PLAYER_BUYS_GxF" >2
	    echo "        DEBUG       PLAYER_SELL_GxF: $PLAYER_SELL_GxF" >2
	    echo "        DEBUG       PLAYER_BUYS_FxT: $PLAYER_BUYS_FxT" >2
	    echo "        DEBUG       PLAYER_SELL_FxT: $PLAYER_SELL_FxT" >2
	    echo "        DEBUG       PLAYER_BUYS_TxF: $PLAYER_BUYS_TxF" >2
	    echo "        DEBUG       PLAYER_SELL_TxF: $PLAYER_SELL_TxF" >2
	    echo "        DEBUG       PLAYER_BUYS_TxG: $PLAYER_BUYS_TxG" >2
	    echo "        DEBUG       PLAYER_SELL_TxG: $PLAYER_SELL_TxG" >2
	    echo "        DEBUG       PLAYER_BUYS_GxT: $PLAYER_BUYS_GxT" >2
	    echo "        DEBUG       PLAYER_SELL_GxT: $PLAYER_SELL_GxT" >2
	    echo "        DEBUG       PLAYER_BUYS_IxG: $PLAYER_BUYS_IxG" >2
	    echo "        DEBUG       PLAYER_SELL_IxG: $PLAYER_SELL_IxG" >2
	    echo "        DEBUG       PLAYER_BUYS_GxI: $PLAYER_BUYS_GxI" >2
	    echo "        DEBUG       PLAYER_SELL_GxI: $PLAYER_SELL_GxI" >2
	# // DEBUG


	# Merchant sells this item (but will buy e.g. fur, tusks etc.)
	RollDice 8
	case "$DICE" in
	    1 ) MERCHANT_ITEM="Health Potion (5 HP)"  ;; # TODO for release after 2.0 (TODO 3.0)
	    2 ) MERCHANT_ITEM="Health Potion (10 HP)" ;; # Construct numbered list in ARRAY instead..?
	    3 ) MERCHANT_ITEM="Health Potion (15 HP)" ;; # This way we can add more seamlessly..
	    4 ) MERCHANT_ITEM="Health Potion (20 HP)" ;;
	    5 | 6 | 7 | 8 ) MERCHANT_ITEM="Almanac"   ;;
	esac
    fi
    # Merchant Loop
    while (true) ; do
	GX_Marketplace_Merchant
	local M_Y=4                # Setup default greeting
	local MERCHANT_MSG=("" "weather-beaten Traveller!" "galant Elf of the Forests!" "fierce master Dwarf!" "young master Hobbit!") # [0] is dummy
	tput sc && MvAddStr $M_Y 4 "Oye there, ${MERCHANT_MSG[$CHAR_RACE]}"
	(( M_Y++ ))
	local MERCHANT_MSG=( "" "" "" "" "" "" "Me and my Caravan travel far and wide" "to provide the Finest Merchandise" "in the Realm, and at the best"
			     "possible prices! I buy everything" "and sell only the best, 'tis true!" "" "What are you looking for?" )  && (( M_Y++ )) # [0-5,11] are dummies
	while (( M_Y <= 12 )) ; do # Output default greeting
	    MvAddStr $M_Y 4 "${MERCHANT_MSG[$M_Y]}"
	    (( M_Y++ ))
	done
	tput rc
	read -sn 1 -p "$(MakePrompt '(F)ood;(T)obacco;(G)old;(I)tems;(L)eave')" MERCHANTVAR 2>&1
	case "$MERCHANTVAR" in
	    F | f | T | t | G | g | I | i ) Marketplace_Merchant_Bargaining	"$MERCHANTVAR" ;;
	    * ) break ;;
	esac

	tput sc
	MvAddStr 12 4 "Are you buying or selling?"
	tput rc
	read -sn 1 -p "$(MakePrompt '(B)uying;(S)elling;(J)ust Looking')" MERCHANTVAR 2>&1
	Marketplace_Merchant_Bargaining "$MERCHANDISE"
	local QUANTITY COST_GOLD COST_TOBACCO COST_FOOD COST_ITEM TRANSACTION_STATUS BARGAIN_TYPE
	case "$MERCHANTVAR" in
	    b | B ) BARGAIN_TYPE=1  ;; # Buying  MERCHANDISE ($MERCHANDISE) from Merchant
	    s | S ) BARGAIN_TYPE=2  ;; # Selling STOCK ($MERCHANDISE) to Merchant
	    * )     BARGAIN_TYPE=3  ;; # Invalid input
	esac

	if (( BARGAIN_TYPE != 3 )) && [[ MERCHANDISE != "unknown" ]] ; then
	    # Prompt for Quantity
	    local QUANTITYPROMPT
	    [[ "$MERCHANDISE" = "Item" ]] && QUANTITYPROMPT=" How many $MERCHANT_ITEM" && QUANTITYPROMPT+="s" || QUANTITYPROMPT=" How much $MERCHANDISE"
	    QUANTITYPROMPT+=" do you want to "
	    (( BARGAIN_TYPE == 1 )) && QUANTITYPROMPT+="buy? " || QUANTITYPROMPT+="sell? "
	    echo -en "$QUANTITYPROMPT" && read QUANTITY 2>&1

	    if (( $(bc <<< "$QUANTITY < 1") )) ; then
		Marketplace_Merchant_Bargaining "$MERCHANDISE"
		tput sc
		MvAddStr 12 4 "If you want to trade small,"
		MvAddStr 13 4 "I suggest you go see the"
		MvAddStr 14 4 "grocer instead. Good-bye!"
		tput rc
		PressAnyKey
		break # Exit if amount is < 1 (this is equal to "cancel")
	    elif (( $(bc <<< "$QUANTITY > 1" ) )) ; then # Construct merchant string
		case "$MERCHANDISE" in
		    "Item" ) local MERCHANT_ORDER_CONJUG_1="s " ;;
		    * )      local MERCHANT_ORDER_CONJUG_1=" "  ;;
		esac
		local MERCHANT_ORDER_CONJUG_2="cost "
	    else # Construct merchant string
		local MERCHANT_ORDER_CONJUG_1=" " && local MERCHANT_ORDER_CONJUG_2="costs "
	    fi

	    # Calculate COST (for PLAYER or MERCHANT depending on BARGAIN TYPE)
	    local MERCHANT_ORDER_1 && local MERCHANT_ORDER_2
	    (( BARGAIN_TYPE == 1 )) && MERCHANT_ORDER_1="$QUANTITY $MERCHANDISE$MERCHANT_ORDER_CONJUG_1$MERCHANT_ORDER_CONJUG_2"
	    (( BARGAIN_TYPE == 2 )) && MERCHANT_ORDER_1="For $QUANTITY $MERCHANDISE$MERCHANT_ORDER_CONJUG_1" && MERCHANT_ORDER_1+="I'll give you "

	    case "$MERCHANDISE" in
		"Food" )    (( BARGAIN_TYPE == 1 )) && COST_GOLD=$( bc <<< "$PLAYER_BUYS_FxG * $QUANTITY" )
					(( BARGAIN_TYPE == 2 )) && COST_GOLD=$( bc <<< "$PLAYER_SELL_FxG * $QUANTITY" )
					(( BARGAIN_TYPE == 1 )) && COST_TOBACCO=$( bc <<< "$PLAYER_BUYS_FxT * $QUANTITY" )
					(( BARGAIN_TYPE == 2 )) && COST_TOBACCO=$( bc <<< "$PLAYER_SELL_TxF * $QUANTITY" )
					MERCHANT_ORDER_2+="$COST_GOLD Gold or $COST_TOBACCO Tobacco."
					;;
		"Tobacco" ) (( BARGAIN_TYPE == 1 )) && COST_GOLD=$( bc <<< "$PLAYER_BUYS_TxG * $QUANTITY" )
					(( BARGAIN_TYPE == 2 )) && COST_GOLD=$( bc <<< "$PLAYER_SELL_TxG * $QUANTITY" )
					(( BARGAIN_TYPE == 1 )) && COST_FOOD=$( bc <<< "$PLAYER_BUYS_FxT * $QUANTITY" )
					(( BARGAIN_TYPE == 2 )) && COST_FOOD=$( bc <<< "$PLAYER_SELL_FxT * $QUANTITY" )
					MERCHANT_ORDER_2+="$COST_GOLD Gold or $COST_FOOD Food."
					;;
		"Gold" )    (( BARGAIN_TYPE == 1 )) && COST_FOOD=$( bc <<< "$PLAYER_BUYS_GxF * $QUANTITY" )
					(( BARGAIN_TYPE == 2 )) && COST_FOOD=$( bc <<< "$PLAYER_SELL_GxF * $QUANTITY" )
					(( BARGAIN_TYPE == 1 )) && COST_TOBACCO=$(bc <<< "$PLAYER_BUYS_GxT * $QUANTITY" )
					(( BARGAIN_TYPE == 2 )) && COST_TOBACCO=$(bc <<< "$PLAYER_SELL_GxT * $QUANTITY" )
					MERCHANT_ORDER_2+="$COST_FOOD Food or $COST_TOBACCO Tobacco."
					;;
		"Item" )    (( BARGAIN_TYPE == 1 )) && COST_GOLD=$( bc <<< "$PLAYER_BUYS_IxG * $QUANTITY" )
					(( BARGAIN_TYPE == 2 )) && COST_GOLD=$( bc <<< "$PLAYER_SELL_IxG * $QUANTITY" )
					MERCHANT_ORDER_1+="$COST_GOLD Gold."
					;;
	    esac

	    Marketplace_Merchant_Bargaining "$MERCHANDISE"
	    tput sc
	    MvAddStr 12 4 "$MERCHANT_ORDER_1"
	    MvAddStr 13 4 "$MERCHANT_ORDER_2"
	    tput rc

	    # Create bargaining prompt
	    case "$MERCHANDISE" in
		"Food" )    read -sn 1 -p "$(MakePrompt 'Trade for (G)old;Trade for (T)obacco;(N)ot Interested')" MERCHANTVAR 2>&1        ;;
		"Tobacco" ) read -sn 1 -p "$(MakePrompt 'Trade for (G)old;Trade for (F)ood;(N)ot Interested')" MERCHANTVAR 2>&1           ;;
		"Gold" )    read -sn 1 -p "$(MakePrompt 'Trade for (F)ood;Trade for (T)obacco;(N)ot Interested')" MERCHANTVAR 2>&1        ;;
		"Item" )    (( BARGAIN_TYPE == 1 )) && read -sn 1 -p "$(MakePrompt 'Trade for (G)old;(N)ot Interested')" MERCHANTVAR 2>&1
					(( BARGAIN_TYPE == 2 )) && MERCHANTVAR="N"                                                                    ;; # TODO Temp workaround (player has no items to sell in 2.0)
	    esac

	    # Determine that player has CURRENCY to cover COST or STOCK to cover SALE
	    case "$MERCHANTVAR" in
		T | t ) MERCHANTVAR="Tobacco" && (( $(bc <<< "$CHAR_TOBACCO > $COST_TOBACCO") )) && TRANSACTION_STATUS=0 || TRANSACTION_STATUS=1 ;; # Legend
		F | f ) MERCHANTVAR="Food"    && (( $(bc <<< "$CHAR_FOOD > $COST_FOOD") ))       && TRANSACTION_STATUS=0 || TRANSACTION_STATUS=1 ;; # 0 = CHAR has that amount
		G | g ) MERCHANTVAR="Gold"    && (( $(bc <<< "$CHAR_GOLD > $COST_GOLD") ))       && TRANSACTION_STATUS=0 || TRANSACTION_STATUS=1 ;; # 1 = CHAR does not have it
		I | i ) MERCHANTVAR="Item"    && TRANSACTION=1  ;; # Selling items not yet implemented                             ;; # 1 = ""
		N | n ) TRANSACTION_STATUS=3                                                                                      				 ;; # 4 = CHAR is not interested
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
				     ;; # TODO Items are added/used/removed below TODO change this with inventory implementation (3.0)
		    * )              TRANSACTION_STATUS=2
		                     ;; # invalid input of other type (e.g. hitting (T)obacco to buy Item. Nice try:)
		esac
	    fi

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
	    ## COPY/PASTE the above debug lines here whenever needed.
	    # // DEBUG


	    # Create transaction status output (MERCHANT_CONFIRMATION)
	    Marketplace_Merchant_Bargaining "$MERCHANDISE"
	    if (( TRANSACTION_STATUS == 0 )) ; then
		local PAYMENT=$( echo "$MERCHANTVAR" | sed -e "s/-$MERCHANDISE//g" )
	    else
		local PAYMENT="$MERCHANTVAR"
	    fi

	    local MERCHANT_CONFIRMATION
	    case "$TRANSACTION_STATUS" in
		1 ) MERCHANT_CONFIRMATION="You don't have enough $PAYMENT"          # Invalid transaction
		    local MERCHANT_CONFIRMATION_2="to buy "
		    case "$MERCHANDISE" in
			"Item" ) MERCHANT_CONFIRMATION_2+="this $MERCHANT_ITEM."    ;;
			* )      MERCHANT_CONFIRMATION_2+="$QUANTITY $MERCHANDISE." ;;
		    esac
		    ;;
		2 ) MERCHANT_CONFIRMATION="Sorry, I can't accept that trade .."   ;; # Invalid input
		3 ) MERCHANT_CONFIRMATION="Welcome back anytime, friend!"         ;; # Not interested
		0 ) # Valid transactions
		    (( BARGAIN_TYPE == 1 )) && MERCHANT_CONFIRMATION=" You bought" || MERCHANT_CONFIRMATION=" You sold"
		    MERCHANT_CONFIRMATION+=" $QUANTITY $MERCHANDISE for"
		    case "$PAYMENT" in
			"Tobacco" ) MERCHANT_CONFIRMATION+=" $COST_TOBACCO Tobacco [ "
				    (( BARGAIN_TYPE == 1 )) && MERCHANT_CONFIRMATION+="-$COST_TOBACCO" || MERCHANT_CONFIRMATION+="+$COST_TOBACCO" ;;
			"Food" )    MERCHANT_CONFIRMATION+=" $COST_FOOD Food [ "
				    (( BARGAIN_TYPE == 1 )) && MERCHANT_CONFIRMATION+="-$COST_FOOD"    || MERCHANT_CONFIRMATION+="+$COST_FOOD" ;;
			"Gold" )    MERCHANT_CONFIRMATION+=" $COST_GOLD Gold [ "
				    (( BARGAIN_TYPE == 1 )) && MERCHANT_CONFIRMATION+="-$COST_GOLD"    || MERCHANT_CONFIRMATION+="+$COST_GOLD" ;;
			# Item ) # TODO v. 3 (selling pelts n stuff)
		    esac
		    MERCHANT_CONFIRMATION+=" ${PAYMENT^^} , "
		    (( BARGAIN_TYPE == 1 )) && MERCHANT_CONFIRMATION+="+$QUANTITY "
		    (( BARGAIN_TYPE == 2 )) && MERCHANT_CONFIRMATION+="-$QUANTITY "
		    case "$MERCHANDISE" in
			"Food" | "Tobacco" | "Gold" ) MERCHANT_CONFIRMATION+="${MERCHANDISE^^} ]" ;;
			* )                           MERCHANT_CONFIRMATION+="ITEM ]"             ;;
		    esac
		    ;;
	    esac

	    # Output MERCHANT_CONFIRMATION ("goodbye")
	    if (( TRANSACTION_STATUS == 0 )) ; then
		tput sc
		MvAddStr 12 4 "Thanks for the trade!"
		tput rc
		echo -n "$MERCHANT_CONFIRMATION  " && read -sn 1 -t 8
	    else
		tput sc
		MvAddStr 12 4 "$MERCHANT_CONFIRMATION"
		(( TRANSACTION_STATUS == 1 )) && MvAddStr 13 4 "$MERCHANT_CONFIRMATION_2"
		tput rc
	    fi

	    # Post purchase actions for items
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

	    # Unset constructed strings otherwise they may be repeated.. (TODO: use 'local QUANTITYPROMPT=""' as initiation perhaps..)
	    [ -n "$QUANTITYPROMPT" ]          && unset QUANTITYPROMPT
	    [ -n "$MERCHANT_ORDER_CONJUG_1" ] && unset MERCHANT_ORDER_CONJUG_1
	    [ -n "$MERCHANT_ORDER_CONJUG_2" ] && unset MERCHANT_ORDER_CONJUG_2
	    [ -n "$MERCHANT_ORDER_1" ]        && unset MERCHANT_ORDER_1
	    [ -n "$MERCHANT_ORDER_2" ]        && unset MERCHANT_ORDER_2
	    [ -n "$MERCHANT_CONFIRMATION" ]   && unset MERCHANT_CONFIRMATION
	    [ -n "$MERCHANT_CONFIRMATION_2" ] && unset MERCHANT_CONFIRMATION_2

	    (( TRANSACTION_STATUS != 0 )) && PressAnyKey # Return to zero
	    (( TRANSACTION_STATUS == 3 )) && break       # Leave loop if we're not interested

	fi
    done
} # Return to Marketplace



#-----------------------------------------------------------------------
# Marketplace_Statusline()
# Used: Marketplace_Grocer() Marketplace_Merchant()
#-----------------------------------------------------------------------
Marketplace_Statusline() {
    MakePrompt "You currently have ${CHAR_GOLD} Gold, ${CHAR_TOBACCO} Tobacco and ${CHAR_FOOD} Food in your inventory"
    echo -e "\n" # Give us some space here, people
}

#-----------------------------------------------------------------------
# Marketplace_Grocer()
# Used: GoIntoTown()
#-----------------------------------------------------------------------
Marketplace_Grocer() {
    local GROCER_FxG=$( bc <<< "scale=2;$PRICE_FxG+($VAL_CHANGE/2)" )   # Determine GROCER's price (profit margin = 0.5 $VAL_CHANGE)
    local GROCER_FxT=$( bc <<< "scale=2;$PRICE_FxT+($VAL_CHANGE/2)" )   # Default PRICE of units are set in WorldPriceFixing()
    while (true); do
	GX_Marketplace_Grocer "$GROCER_FxG" "$GROCER_FxT"
	MakePrompt 'Trade for (G)old;Trade for (T)obacco;(L)eave'
	case $(Read) in
	    [gG] ) local UNIT="Gold";                                   # Trade for Gold
		   declare -n PRICE=GROCER_FxG CURRENCY=CHAR_GOLD ;;    # Set indirect references
	    [tT] ) local UNIT="Tobacco";                                # Trade for tobacco
		   declare -n PRICE=GROCER_FxT CURRENCY=CHAR_TOBACCO ;; # Set indirect references
	    *    ) break ;;
	esac
	ReadLine "${CLEAR_LINE} How many Food items do you want to buy? "
	local QUANTITY="$REPLY"
	[[ "$REPLY" ]] || continue                                      # check for user input
	if ! IsInt "$QUANTITY"; then
	    echo " I can't sell you ${QUANTITY} Food.."
	    PressAnyKey
	    continue
	fi
	local COST=$( bc <<< "${PRICE} * ${QUANTITY}" )
	if (( $(bc <<< "${CURRENCY} >= ${COST}") )); then
	    CURRENCY=$(bc <<< "${CURRENCY} - ${COST}")
	    CHAR_FOOD=$(bc <<< "${CHAR_FOOD} + ${QUANTITY}")
	    echo " You bought $QUANTITY food for ${COST} ${UNIT}, and you have ${CHAR_FOOD} Food in your inventory"
	else
	    echo " You don't have enough ${UNIT} to buy ${QUANTITY} Food. Try a little less!"
	fi
	PressAnyKey
	unset -n PRICE CURRENCY # !!! Indirect references should not be removed, but 'unset -n' !!!
    done
} # Return to GoIntoTown()

#-----------------------------------------------------------------------
# Marketplace_Beggar()                                           Town.sh
# Used: GoIntoTown()
# TODO v. 3
#-----------------------------------------------------------------------
Marketplace_Beggar() {
    GX_Marketplace_Beggar
    tput sc
    local B_Y=4                # Setup default greeting
    local BEGGAR_MSG=("" "Traveller from afar" "Forest Child" "Mountain Warrior" "Master Hobbit") # [0] is dummy
    if [ -z "$BEGGAR" ] || [ "$BEGGAR" != "$CHAR_GPS" ] ; then 	# "Name" this beggar as GPS location
	BEGGAR="$CHAR_GPS"
	MvAddStr $B_Y 4 "Kind ${BEGGAR_MSG[$CHAR_RACE]} .."
	# Add mercy plea dependent on race (for $DEITY) vs. history/religion.
	# (( M_Y++ ))                            #   length indication of a string     #
	# local MERCHANT_MSG=( "" "" "" "" "" "" "Please, " "to provide the Finest Merchandise" "in the Realm, and at the best"
	# 		     "possible prices! I buy everything" "and sell only the best, 'tis true!" "" "What are you looking for?" )  && (( M_Y++ )) # [0-5,11] are dummies
	# while (( M_Y <= 12 )) ; do # Output default greeting
	#     MvAddStr $M_Y 4 "${MERCHANT_MSG[$M_Y]}"
	#     (( M_Y++ ))
	# done
    else
	MvAddStr $B_Y 4 "Hello again, ${BEGGAR_MSG[$CHAR_RACE]} .."
    fi
    tput rc
    PressAnyKey
}
#
# The BEGGAR will accept donations (1-2 x VAL_CHANGE), and will respond
# to the CHAR with a) simple thank you or b) advice, knowledge, info
# "If you're shopping, check the prices of both grocer and merchant first!"
# This is a way of "advertising" the right solution(s) to the player..

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
#                                                                      #
########################################################################

########################################################################
#                          Tavern Dice game                            #
#                                                                      #

#-----------------------------------------------------------------------
# GX_DiceGame() (GPL)
# Display dices GX for MiniGame_Dice()
# Arguments: $DGAME_DICE_1(int), $DGAME_DICE_2(int).
# Used: MiniGame_Dice()
#-----------------------------------------------------------------------
GX_DiceGame() {
    local GDICE_SYM="@" # @ looks nice:)
    clear
    awk ' BEGIN { FS = "" ; OFS = ""; }
{   # First dice
    if ('$1' == 1) { if (NR == 5) { $26 = "'$GDICE_SYM'"} }
    if ('$1' == 2) { if (NR == 3) { $30 = "'$GDICE_SYM'"; }
 	             if (NR == 7) { $22 = "'$GDICE_SYM'"; } }
    if ('$1' == 3) { if (NR == 3) { $30 = "'$GDICE_SYM'"; }
            	     if (NR == 5) { $26 = "'$GDICE_SYM'"; }
	             if (NR == 7) { $22 = "'$GDICE_SYM'"; } }
    if ('$1' == 4) { if (NR == 3) { $22 = "'$GDICE_SYM'"; $30= "'$GDICE_SYM'"; }
	             if (NR == 7) { $22 = "'$GDICE_SYM'"; $30= "'$GDICE_SYM'"; } }
    if ('$1' == 5) { if (NR == 3) { $22 = "'$GDICE_SYM'"; $30= "'$GDICE_SYM'"; }
	             if (NR == 5) { $26 = "'$GDICE_SYM'"; }
	             if (NR == 7) { $22 = "'$GDICE_SYM'"; $30= "'$GDICE_SYM'"; } }
    if ('$1' == 6) { if (NR == 3) { $22 = "'$GDICE_SYM'"; $30= "'$GDICE_SYM'"; }
	             if (NR == 5) { $22 = "'$GDICE_SYM'"; $30= "'$GDICE_SYM'"; }
	             if (NR == 7) { $22 = "'$GDICE_SYM'"; $30= "'$GDICE_SYM'"; } }
    # Second dice
    if ('$2' == 1) { if (NR == 5) { $53 = "'$GDICE_SYM'"} }
    if ('$2' == 2) { if (NR == 3) { $57 = "'$GDICE_SYM'"; }
	             if (NR == 7) { $49 = "'$GDICE_SYM'"; } }
    if ('$2' == 3) { if (NR == 3) { $57 = "'$GDICE_SYM'"; }
	             if (NR == 5) { $53 = "'$GDICE_SYM'"; }
		     if (NR == 7) { $49 = "'$GDICE_SYM'"; } }
    if ('$2' == 4) { if (NR == 3) { $49 = "'$GDICE_SYM'"; $57= "'$GDICE_SYM'"; }
	             if (NR == 7) { $49 = "'$GDICE_SYM'"; $57= "'$GDICE_SYM'"; } }
    if ('$2' == 5) { if (NR == 3) { $49 = "'$GDICE_SYM'"; $57= "'$GDICE_SYM'"; }
	             if (NR == 5) { $53 = "'$GDICE_SYM'"; }
		     if (NR == 7) { $49 = "'$GDICE_SYM'"; $57= "'$GDICE_SYM'"; } }
    if ('$2' == 6) { if (NR == 3) { $49 = "'$GDICE_SYM'"; $57= "'$GDICE_SYM'"; }
 	             if (NR == 5) { $49 = "'$GDICE_SYM'"; $57= "'$GDICE_SYM'"; }
		     if (NR == 7) { $49 = "'$GDICE_SYM'"; $57= "'$GDICE_SYM'"; } }
    # Display numbers too for great justice (or readability)
    if (NR == 10)  { $26 = '$1'; $53 = '$2'; }
    print; } ' <<"EOF"
                  _______________            _______________
                 [               ].         [               ].
                 |               |:         |               |:
                 |               |:         |               |:
                 |               |:         |               |:
                 |               |:         |               |:
                 |               |:         |               |:
                 [_______________];         [_______________];
                  `~------------~`           `~------------~`

EOF
    echo "$HR"
}

#-----------------------------------------------------------------------
# $DICE_GAME_CHANCES - Chances (%) of any player picking the resulting
# number
# Fixed, so declared as readonly array
# Player can't dice 0 or 1 so ${DICE_GAME_CHANCES[0]} and
# ${DICE_GAME_CHANCES[1]} are dummy
# Used: MiniGame_Dice()
#-----------------------------------------------------------------------
#               dice1+dice2    = 0 1 2 3 4 5  6  7  8  9  10 11 12
declare -r -a DICE_GAME_CHANCES=(0 1 3 6 9 12 14 17 14 12 9  6  3)

#-----------------------------------------------------------------------
# $DICE_GAME_WINNINGS - % of POT (initial DGAME_WINNINGS) to be paid
# out given DGAME_RESULT (odds)
# Fixed, so declared as readonly array
# Player can't dice 0 or 1 so ${DICE_GAME_WINNINGS[0]} and
# ${DICE_GAME_WINNINGS[1]} are dummy
# Used: MiniGame_Dice()
#-----------------------------------------------------------------------
#                dice1+dice2    = 0 1 2   3  4  5  6  7  8  9  10 11 12
declare -r -a DICE_GAME_WINNINGS=(0 1 100 85 70 55 40 25 40 55 70 85 100)

#-----------------------------------------------------------------------
# MiniGame_Dice()
# Small dice based minigame.
# Used: Tavern()
#-----------------------------------------------------------------------
MiniGame_Dice() {
    DGAME_PLAYERS=$(( $(RollDice2 6) - 1 )) # How many players currently at the table (0-5 players)
    if [[ "$GAMETABLE" != "$CHAR_GPS" ]] ; then
	GAMETABLE="$CHAR_GPS" # "Name" this table as GPS location (savescumming prevention)
	DGAME_STAKES=$( bc <<< "scale=2;$(RollDice2 10) * $VAL_CHANGE" ) # Stake size in 1-10 * VAL_CHANGE
    fi
    GX_DiceGame_Table "$DGAME_PLAYERS"			                     # Display game table depending of count players
    case "$DGAME_PLAYERS" in                                         # Ask whether player wants to join
	0 ) PressAnyKey "There's no one at the table. May be you should come back later?";
	    return 0 ;;   # Leave
	1 ) echo -n "There's a gambler wanting to roll dice for $DGAME_STAKES Gold a piece. Want to [J]oin?" ;;
	* ) echo -n "There are $DGAME_PLAYERS players rolling dice for $DGAME_STAKES Gold a piece. Want to [J]oin?" ;;
    esac
    case $(Read) in
	[^yYjJ] ) echo -en "${CLEAR_LINE}" ;
		  PressAnyKey "Too high stakes for you, $CHAR_RACE_STR?" ;
		  return 0 ;; # Leave
    esac # Game on!

    if (( $(bc <<< "scale=2;$CHAR_GOLD <= $DGAME_STAKES") )); then   # Check if player can afford it
	echo -en "${CLEAR_LINE}"
	PressAnyKey "No one plays with a poor, Goldless $CHAR_RACE_STR! Come back when you've got it.."
	return 0  # Leave
    fi

    GAME_ROUND=1
    CHAR_GOLD=$(bc <<< "scale=2;$CHAR_GOLD - $DGAME_STAKES" )
    Echo "\nYou put down $DGAME_STAKES Gold and pull out a chair .." "[ -$DGAME_STAKES Gold ]"
    Sleep 3

    DGAME_POT=$( bc <<< "scale=2;$DGAME_STAKES * ( $DGAME_PLAYERS + 1 )" ) # Determine starting pot size

    # DICE GAME LOOP
    while ( true ) ; do
	GX_DiceGame_Table
	ReadLine "Round $GAME_ROUND. The pot's $DGAME_POT Gold. Bet (2-12), (I)nstructions or (L)eave Table: "
	DGAME_GUESS="$REPLY"
	#echo " " # Empty line for cosmetical purposes # TODO

	# Dice Game Instructions (mostly re: payout)
	case "$DGAME_GUESS" in
	    i | I ) GX_DiceGame_Instructions ; continue ;;     # Start loop from the beginning
	    1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 ) # Stake!
		if (( GAME_ROUND > 1 )) ; then                 # First round is already paid
		    CHAR_GOLD=$(bc <<< "scale=2;$CHAR_GOLD - $DGAME_STAKES" )
		    echo "Putting down your stake in the pile.. [ -$DGAME_STAKES Gold ]"
		    Sleep 3
		fi ;;
	    *)  echo "See you around, $CHAR_RACE_STR. Come back with more Gold!" # or leave table
		break # leave immediately
	esac

	DGAME_COMP=${DICE_GAME_CHANCES[$DGAME_GUESS]} # Determine if we're sharing the bet based on odds percentage..

	# Run that through a loop of players num and % dice..
	DGAME_COMPETITION=0
	for ((i=0; i < DGAME_PLAYERS; i++)); do
	    (( $(RollDice2 100) <= DGAME_COMP )) && (( DGAME_COMPETITION++ )) # Sharing!
	done

	# Roll the dice (pray for good luck!)
	echo -n "Rolling for $DGAME_GUESS ($DGAME_COMP% odds).. "
	Sleep 1
	case "$DGAME_COMPETITION" in
	    0 ) echo "No one else playing for $DGAME_GUESS!" ;;
	    1 ) echo "Sharing bet with another player!" ;;
	    * ) echo "Sharing bet with $DGAME_COMPETITION other players!"
	esac
	Sleep 1

	DGAME_DICE_1=$(RollDice2 6)
	DGAME_DICE_2=$(RollDice2 6)
	DGAME_RESULT=$( bc <<< "$DGAME_DICE_1 + $DGAME_DICE_2" )
	# IDEA: If we later add an item or charm for LUCK, add adjustments here.

	GX_DiceGame "$DGAME_DICE_1" "$DGAME_DICE_2" # Display roll result graphically

	# Calculate % of POT (initial DGAME_WINNINGS) to be paid out given DGAME_RESULT (odds)
	DGAME_WINNINGS=$( bc <<< "scale=2;$DGAME_POT * ${DICE_GAME_WINNINGS[$DGAME_RESULT]}" )
	DGAME_WINNINGS=$( bc <<< "scale=2;$DGAME_WINNINGS/100" ) # Remember it's a % of the pot

	if (( DGAME_GUESS == DGAME_RESULT )) ; then # You won
   	    DGAME_POT=$( bc <<< "scale=2;$DGAME_POT - $DGAME_WINNINGS" )  # Adjust winnings to odds
	    DGAME_WINNINGS=$( bc <<< "scale=2;$DGAME_WINNINGS / ( $DGAME_COMPETITION + 1 )" ) # no competition = winnings/1
	    echo "You rolled $DGAME_RESULT and won $DGAME_WINNINGS Gold! [ +$DGAME_WINNINGS Gold ]"
	    CHAR_GOLD=$( bc <<< "scale=2;$CHAR_GOLD + $DGAME_WINNINGS" )
	else # You didn't win
	    echo -n "You rolled $DGAME_RESULT and lost.. "

	    # Check if other player(s) won the pot
	    DGAME_COMPETITION=$( bc <<< "$DGAME_PLAYERS - $DGAME_COMPETITION" )
	    DGAME_OTHER_WINNERS=0

	    DGAME_COMP=${DICE_GAME_CHANCES[$DGAME_RESULT]} # Chances of any player picking the resulting number

	    for ((DGAME_COMPETITION; DGAME_COMPETITION > 0; DGAME_COMPETITION-- )); do
		RollDice 100 # bugfix
		(( DICE <= DGAME_COMP )) && (( DGAME_OTHER_WINNERS++ )) # +1 more winner
	    done

	    case "$DGAME_OTHER_WINNERS" in
		0) echo "luckily there were no other winners either!" ;;
		1) echo "another player got $DGAME_RESULT and won $DGAME_WINNINGS Gold.";;
		*) echo "but $DGAME_OTHER_WINNERS other players rolled $DGAME_RESULT and $DGAME_WINNINGS Gold." ;;
	    esac
	    (( DGAME_OTHER_WINNERS > 0 )) && DGAME_POT=$( bc <<< "scale=2;$DGAME_POT - $DGAME_WINNINGS" ) # Adjust winnings to odds
	fi
	Sleep 3

	# Update pot size
	DGAME_STAKES_TOTAL=$( bc <<< "scale=2;$DGAME_STAKES * ( $DGAME_PLAYERS + 1 ) " ) # Assumes player is with us next round too
	DGAME_POT=$( bc <<< "scale=2;$DGAME_POT + $DGAME_STAKES_TOTAL" )		         # If not, the other players won't complain:)

	(( GAME_ROUND++ ))	# Increment round

	if (( $(bc <<< "$CHAR_GOLD < $DGAME_STAKES") )) ; then # Check if we've still got gold for 1 stake...
	    GX_DiceGame_Table
	    echo "You're out of gold, $CHAR_RACE_STR. Come back when you have some more!"
	    break # if not, leave immediately
	fi
    done
    Sleep 3 # After 'break' in while-loop
    SaveCurrentSheet
}

#                                                                      #
#                                                                      #
########################################################################
