########################################################################
#                          Dice game in tavern                         #
#                                                                      #


DiceGameCompetition() {
    case "$1" in # DGAME_COMP
	2 | 12 ) DGAME_COMP=3 ;;  # 1/36 = 03 %
	3 | 11 ) DGAME_COMP=6 ;;  # 2/36 = 06 % 
	4 | 10 ) DGAME_COMP=9 ;;  # 3/36 = 09 %
	5 | 9  ) DGAME_COMP=12 ;; # 4/36 = 12 %
	6 | 8  ) DGAME_COMP=14 ;; # 5/36 = 14 %
	7      ) DGAME_COMP=17 ;; # 1/6  = 17 % == 61 %
    esac
}

#-----------------------------------------------------------------------
# MiniGame_Dice()
# Small dice based minigame.
# Used: Tavern()
#-----------------------------------------------------------------------
MiniGame_Dice() { 
#	echo -en "${CLEAR_LINE}"
	# How many players currently at the table
	DGAME_PLAYERS=$((RANDOM%6)) # 0-5 players

	GX_DiceGame_Table
	case "$DGAME_PLAYERS" in # Ask whether player wants to join
	    0 ) read -sn1 -p "There's no one at the table. May be you should come back later?" 2>&1 && return 0 ;; # leave
	    1 ) read -sn1 -p "There's a gambler wanting to roll dice for $DGAME_STAKES Gold a piece. Want to [J]oin?" JOIN_DICE_GAME 2>&1 ;;
	    * ) read -sn1 -p "There are $DGAME_PLAYERS players rolling dice for $DGAME_STAKES Gold a piece. Want to [J]oin?" JOIN_DICE_GAME 2>&1 ;;	    
	esac
	case "$JOIN_DICE_GAME" in
	    j | J | y | Y ) ;; # Game on! Do nothing.
	    * ) echo -e "\nToo high stakes for you, $CHAR_RACE_STR?" ; sleep 2; return 0;; # Leave.
	esac

	# Determine stake size
	DGAME_STAKES=$( bc <<< "$(RollDice2 6) * $VAL_CHANGE" ) # min 0.25, max 1.5
	# Check if player can afford it
	if (( $(bc <<< "$CHAR_GOLD <= $DGAME_STAKES") )); then
	    read -sn1 -p "No one plays with a poor, Goldless $CHAR_RACE_STR! Come back when you've got it.." 2>&1
	    return 0 # leave
	fi

	GAME_ROUND=1
	CHAR_GOLD=$(bc <<< "$CHAR_GOLD - $DGAME_STAKES" )
	echo -e "\nYou put down $DGAME_STAKES Gold and pull out a chair .. [ -$DGAME_STAKES Gold ]" && sleep 3
	
	# Determine starting pot size
	DGAME_POT=$( bc <<< "$DGAME_STAKES * ( $DGAME_PLAYERS + 1 )" )
	
	# DICE GAME LOOP
	while ( true ) ; do
	    GX_DiceGame_Table
	    read -p "Round $GAME_ROUND. The pot's $DGAME_POT Gold. Bet (2-12), (I)nstructions or (L)eave Table: " DGAME_GUESS 2>&1
	    echo " " # Empty line for cosmetical purposes # TODO
	    
	    # Dice Game Instructions (mostly re: payout)
	    case "$DGAME_GUESS" in
		i | I ) GX_DiceGame_Instructions ; continue ;;     # Start loop from the beginning
		1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 ) # Stake!
		    if (( GAME_ROUND > 1 )) ; then                 # First round is already paid
		    	CHAR_GOLD=$(bc <<< "$CHAR_GOLD - $DGAME_STAKES" )
		    	echo "Putting down your stake in the pile.. [ -$DGAME_STAKES Gold ]" && sleep 3
		    fi ;;
		*)  echo "See you around, $CHAR_RACE_STR. Come back with more Gold!" # or leave table
		    break # leave immediately
	    esac

	    DiceGameCompetition $DGAME_GUESS # Determine if we're sharing the bet based on odds percentage.. # TODO. Do these calculations just once/round!
	    
	    # Run that through a loop of players num and % dice..
	    DGAME_PLAYERS_COUNTER=$DGAME_PLAYERS
	    DGAME_COMPETITION=0
	    while (( DGAME_PLAYERS_COUNTER > 0 )) ; do		
		(( $(RollDice2 100) <= DGAME_COMP )) && (( DGAME_COMPETITION++ )) # Sharing!
		(( DGAME_PLAYERS_COUNTER-- ))
	    done
	    
	    # Roll the dice (pray for good luck!)
	    echo -n "Rolling for $DGAME_GUESS ($DGAME_COMP% odds).. " && sleep 1
	    case "$DGAME_COMPETITION" in
		0 ) echo "No one else playing for $DGAME_GUESS!" ;;
		1 ) echo "Sharing bet with another player!" ;;	    
		* ) echo "Sharing bet with $DGAME_COMPETITION other players!"		    
	    esac
	    sleep 1
	    
	    DGAME_DICE_1=$(RollDice2 6) 
	    DGAME_DICE_2=$(RollDice2 6) 
	    DGAME_RESULT=$( bc <<< "$DGAME_DICE_1 + $DGAME_DICE_2" )
	    # IDEA: If we later add an item or charm for LUCK, add adjustments here.
	    
	    GX_DiceGame "$DGAME_DICE_1" "$DGAME_DICE_2" # Display roll result graphically
	    
	    # Calculate % of POT (initial DGAME_WINNINGS) to be paid out given DGAME_RESULT (odds)
	    case "$DGAME_RESULT" in
	    2 | 12 ) DGAME_WINNINGS=$DGAME_POT ;;		       # 100%  # TODO
	    3 | 11 ) DGAME_WINNINGS=$( bc <<< "$DGAME_POT * 0.85" ) ;; # 85%   # PLAY TEST THESE %s
	    4 | 10 ) DGAME_WINNINGS=$( bc <<< "$DGAME_POT * 0.70" ) ;; # 70%
	    5 | 9  ) DGAME_WINNINGS=$( bc <<< "$DGAME_POT * 0.55" ) ;; # 55%
	    6 | 8  ) DGAME_WINNINGS=$( bc <<< "$DGAME_POT * 0.40" ) ;; # 40%
	    7      ) DGAME_WINNINGS=$( bc <<< "$DGAME_POT * 0.25" ) ;; # 25%
	    esac
	    
	    if (( DGAME_GUESS == DGAME_RESULT )) ; then # You won
   		DGAME_POT=$( bc <<< "$DGAME_POT - $DGAME_WINNINGS" )  # Adjust winnings to odds
		DGAME_WINNINGS=$( bc <<< "$DGAME_WINNINGS / ( $DGAME_COMPETITION + 1 )" ) # no competition = winnings/1
		echo "You rolled $DGAME_RESULT and won $DGAME_WINNINGS Gold! [ +$DGAME_WINNINGS Gold ]"
		CHAR_GOLD=$( bc <<< "$CHAR_GOLD + $DGAME_WINNINGS" )
		sleep 3
	    else # You didn't win
		echo -n "You rolled $DGAME_RESULT and lost.. "
		
		# Check if other player(s) won the pot
		DGAME_COMPETITION=$( bc <<< "$DGAME_PLAYERS - $DGAME_COMPETITION" )
		DGAME_OTHER_WINNERS=0
		
		DiceGameCompetition $DGAME_RESULT # Chances of any player picking the resulting number
		
		while (( DGAME_COMPETITION >= 1 )) ; do
		    RollDice 100 # bugfix
		    (( DICE <= DGAME_COMP )) && (( DGAME_OTHER_WINNERS++ )) # +1 more winner
		    (( DGAME_COMPETITION-- ))
		done
		
		case "$DGAME_OTHER_WINNERS" in
		    0) echo "luckily there were no other winners either!" ;;
		    1) echo "another player got $DGAME_RESULT and won $DGAME_WINNINGS Gold.";;
		    *) echo "but $DGAME_OTHER_WINNERS other players rolled $DGAME_RESULT and $DGAME_WINNINGS Gold." ;;			
		esac
		(( DGAME_OTHER_WINNERS > 0 )) && DGAME_POT=$( bc <<< "$DGAME_POT - $DGAME_WINNINGS" ) # Adjust winnings to odds
	    fi
	    sleep 3
	    
	    # Update pot size
	    DGAME_STAKES_TOTAL=$( bc <<< "$DGAME_STAKES * ( $DGAME_PLAYERS + 1 ) " ) # Assumes player is with us next round too
	    DGAME_POT=$( bc <<< "$DGAME_POT + $DGAME_STAKES_TOTAL" )		     # If not, the other players won't complain:)

	    (( GAME_ROUND++ ))	# Increment round

	    if (( $(bc <<< "$CHAR_GOLD < $DGAME_STAKES") )) ; then # Check if we've still got gold for 1 stake...
		GX_DiceGame_Table
		echo "You're out of gold, $CHAR_RACE_STR. Come back when you have some more!"
		break # if not, leave immediately		
	    fi		
	done
	sleep 3 # After 'break' in while-loop
	SaveCurrentSheet
}

#                                                                      #
#                                                                      #
########################################################################

