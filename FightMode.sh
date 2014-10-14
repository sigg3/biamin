########################################################################
#                              Fight mode                              #
#                      (secondary loop for fights)                     #

#-----------------------------------------------------------------------
# CheckForFight()
# Calls FightMode if player is attacked at current scenario or returns 0
# Arguments : $SCENARIO (char)
#-----------------------------------------------------------------------
CheckForFight() {
    RollDice 100        # Find out if we're attacked 
    case "$1" in        # FightMode() if RollForEvent return 0
	H ) RollForEvent 1  "fight" && FightMode ;;
	x ) RollForEvent 50 "fight" && FightMode ;;
	. ) RollForEvent 20 "fight" && FightMode ;;
	T ) RollForEvent 15 "fight" && FightMode ;;
	@ ) RollForEvent 35 "fight" && FightMode ;;
	C ) RollForEvent 10 "fight" && FightMode ;;
	* ) CustomMapError ;;
    esac
}

#-----------------------------------------------------------------------
# FightMode_ResetFlags()
# Reset FightMode flags to default
# $FIGHTMODE: FightMode flag. Also used in CleanUp()'s penaly for exit 
#  during battle
#	0 - PLAYER is not fighting now
#	1 - PLAYER is fighting now
# $NEXT_TURN: Which turn is now
#	"en" - ENEMY
#	"pl" - PLAYER
# $LUCK: how many EXP player will get for this battle
#	0 - ENEMY was slain
#	1 - ENEMY managed to FLEE 
#	2 - PLAYER died but saved by guardian angel or 1000 EXP
#	3 - PLAYER managed to FLEE during fight!
# $PICKPOCKET: how many GOLD, TOBACCO and EXP for pickpocketing player 
#  will get for this battle
#	0 - no pickpocketing was (only loot if any)
#	1 - successful pickpocketing with loot ($EN_PICKPOCKET_EXP + loot)
#	2 - successful pickpocketing without loot (only $EN_PICKPOCKET_EXP)
#-----------------------------------------------------------------------
FightMode_ResetFlags() {
    FIGHTMODE=1	  
    NEXT_TURN="pl"
    LUCK=0        
    PICKPOCKET=0  
}

#-----------------------------------------------------------------------
# FightMode_AddBonuses()
# Set fight bonuses from magick items
# IDEA: If player was attacked during the rest (at night )he and enemies can get + or - for night and moon phase here ??? (3.0)
#-----------------------------------------------------------------------
FightMode_AddBonuses() {
    HaveItem "$QUICK_RABBIT_REACTION"   && ((ACCURACY++))
    HaveItem "$FLASK_OF_TERRIBLE_ODOUR" && ((EN_FLEE++))    
}
 
FightMode_RemoveBonuses() {
    HaveItem "$QUICK_RABBIT_REACTION" && ((ACCURACY++)) # Reset Quick Rabbit Reaction (ACCURACY) before fighting...
}

FightMode_DefineEnemy() {
    RollDice 100 # Determine generic enemy type from chthulu, orc, varg, mage, goblin, bandit, boar, dragon, bear, imp (10)
    case "$SCENARIO" in
	H ) ((DICE <= 10)) && ENEMY="chthulu" || ((DICE <= 80)) && ENEMY="dragon" || ENEMY="imp"    ;;
	T ) ((DICE <= 35)) && ENEMY="mage"    || ((DICE <= 90)) && ENEMY="bandit" || ENEMY="dragon" ;;
	C ) ((DICE <= 5 )) && ENEMY="chthulu" || ((DICE <= 45)) && ENEMY="mage"   || ENEMY="dragon" ;;
	x ) ((DICE <= 20)) && ENEMY="orc"     || ((DICE <= 40)) && ENEMY="varg"   || ((DICE <= 50)) && ENEMY="goblin" || ((DICE <= 55)) && ENEMY="boar" || ((DICE <= 80)) && ENEMY="dragon" || ENEMY="bear" ;;
	. ) ((DICE <= 5 )) && ENEMY="orc"     || ((DICE <= 30)) && ENEMY="goblin" || ((DICE <= 60)) && ENEMY="bandit" || ((DICE <= 75)) && ENEMY="boar" || ENEMY="imp"  ;; # Bear in road was weird..
	@ ) ((DICE <= 10)) && ENEMY="orc"     || ((DICE <= 30)) && ENEMY="goblin" || ((DICE <= 60)) && ENEMY="bandit" || ((DICE <= 75)) && ENEMY="boar" || ((DICE <= 80)) && ENEMY="bear"   || ENEMY="imp"  ;;
    esac

    # ENEMY ATTRIBUTES
    # EN_FLEE_THRESHOLD - At what Health will enemy flee? :)
    # PL_FLEE_EXP       - Exp player get if he manage to flee from enemy
    # EN_FLEE_EXP       - Exp player get if enemy manage to flee from him
    # EN_DEFEATED_EXP   - Exp player get if he manage to kill the enemy
    

    ########################################################################
    # BACKUP
    # case "$ENEMY" in
    # 	# orig: str=2, acc=4
    # 	bandit )  EN_STRENGTH=1 ; EN_ACCURACY=4 ; EN_FLEE=7 ; EN_HEALTH=30  ; EN_FLEE_THRESHOLD=18 ; PL_FLEE_EXP=5   ; EN_FLEE_EXP=10  ; EN_DEFEATED_EXP=20   ;; 
    # 	# orig: str=3, acc=3
    # 	goblin )  EN_STRENGTH=3 ; EN_ACCURACY=3 ; EN_FLEE=5 ; EN_HEALTH=30  ; EN_FLEE_THRESHOLD=15 ; PL_FLEE_EXP=10  ; EN_FLEE_EXP=15  ; EN_DEFEATED_EXP=30   ;; 
    # 	boar )    EN_STRENGTH=4 ; EN_ACCURACY=2 ; EN_FLEE=3 ; EN_HEALTH=60  ; EN_FLEE_THRESHOLD=35 ; PL_FLEE_EXP=5   ; EN_FLEE_EXP=20  ; EN_DEFEATED_EXP=40   ;;
    # 	orc )     EN_STRENGTH=4 ; EN_ACCURACY=4 ; EN_FLEE=4 ; EN_HEALTH=80  ; EN_FLEE_THRESHOLD=40 ; PL_FLEE_EXP=15  ; EN_FLEE_EXP=25  ; EN_DEFEATED_EXP=50   ;; 
    # 	varg )    EN_STRENGTH=4 ; EN_ACCURACY=3 ; EN_FLEE=3 ; EN_HEALTH=80  ; EN_FLEE_THRESHOLD=60 ; PL_FLEE_EXP=25  ; EN_FLEE_EXP=50  ; EN_DEFEATED_EXP=100  ;;
    # 	mage )    EN_STRENGTH=5 ; EN_ACCURACY=3 ; EN_FLEE=4 ; EN_HEALTH=90  ; EN_FLEE_THRESHOLD=45 ; PL_FLEE_EXP=35  ; EN_FLEE_EXP=75  ; EN_DEFEATED_EXP=150  ;;
    # 	dragon )  EN_STRENGTH=4 ; EN_ACCURACY=4 ; EN_FLEE=2 ; EN_HEALTH=120 ; EN_FLEE_THRESHOLD=50 ; PL_FLEE_EXP=45  ; EN_FLEE_EXP=90  ; EN_DEFEATED_EXP=180  ;;
    # 	chthulu ) EN_STRENGTH=6 ; EN_ACCURACY=5 ; EN_FLEE=1 ; EN_HEALTH=500 ; EN_FLEE_THRESHOLD=35 ; PL_FLEE_EXP=200 ; EN_FLEE_EXP=500 ; EN_DEFEATED_EXP=1000 ;;
    # 	bear )    EN_STRENGTH=6 ; EN_ACCURACY=1 ; EN_FLEE=4 ; EN_HEALTH=160 ; EN_FLEE_THRESHOLD=25 ; PL_FLEE_EXP=10  ; EN_FLEE_EXP=25  ; EN_DEFEATED_EXP=60   ;; # TODO: test and confirm these
    # 	imp )     EN_STRENGTH=2 ; EN_ACCURACY=1 ; EN_FLEE=3 ; EN_HEALTH=20  ; EN_FLEE_THRESHOLD=10 ; PL_FLEE_EXP=2   ; EN_FLEE_EXP=5   ; EN_DEFEATED_EXP=10   ;; # TODO: test and confirm these
    # esac
    #
    ########################################################################


    ########################################################################
    # TEST NEW EXP SYSTEM
    case "$ENEMY" in
	# orig: str=2, acc=4
	bandit )  EN_STRENGTH=1 ; EN_ACCURACY=4 ; EN_FLEE=7 ; EN_HEALTH=30  ; EN_FLEE_THRESHOLD=18 ; EN_DEFEATED_EXP=20   ;; 
	# orig: str=3, acc=3
	goblin )  EN_STRENGTH=3 ; EN_ACCURACY=3 ; EN_FLEE=5 ; EN_HEALTH=30  ; EN_FLEE_THRESHOLD=15 ; EN_DEFEATED_EXP=30   ;; 
	boar )    EN_STRENGTH=4 ; EN_ACCURACY=2 ; EN_FLEE=3 ; EN_HEALTH=60  ; EN_FLEE_THRESHOLD=35 ; EN_DEFEATED_EXP=40   ;;
	orc )     EN_STRENGTH=4 ; EN_ACCURACY=4 ; EN_FLEE=4 ; EN_HEALTH=80  ; EN_FLEE_THRESHOLD=40 ; EN_DEFEATED_EXP=50   ;; 
	varg )    EN_STRENGTH=4 ; EN_ACCURACY=3 ; EN_FLEE=3 ; EN_HEALTH=80  ; EN_FLEE_THRESHOLD=60 ; EN_DEFEATED_EXP=100  ;;
	mage )    EN_STRENGTH=5 ; EN_ACCURACY=3 ; EN_FLEE=4 ; EN_HEALTH=90  ; EN_FLEE_THRESHOLD=45 ; EN_DEFEATED_EXP=150  ;;
	dragon )  EN_STRENGTH=4 ; EN_ACCURACY=4 ; EN_FLEE=2 ; EN_HEALTH=120 ; EN_FLEE_THRESHOLD=50 ; EN_DEFEATED_EXP=180  ;;
	chthulu ) EN_STRENGTH=6 ; EN_ACCURACY=5 ; EN_FLEE=1 ; EN_HEALTH=500 ; EN_FLEE_THRESHOLD=35 ; EN_DEFEATED_EXP=1000 ;;
	bear )    EN_STRENGTH=6 ; EN_ACCURACY=1 ; EN_FLEE=4 ; EN_HEALTH=160 ; EN_FLEE_THRESHOLD=25 ; EN_DEFEATED_EXP=60   ;; # TODO: test and confirm these
	imp )     EN_STRENGTH=2 ; EN_ACCURACY=1 ; EN_FLEE=3 ; EN_HEALTH=20  ; EN_FLEE_THRESHOLD=10 ; EN_DEFEATED_EXP=10   ;; # TODO: test and confirm these
    esac
    # Temporary - after it'll be count in function ChecForExp()
    PL_FLEE_EXP=$((EN_DEFEATED_EXP / 4))       # - Exp player get if he manage to flee from enemy
    EN_FLEE_EXP=$((EN_DEFEATED_EXP / 2))       # - Exp player get if enemy manage to flee from him
    #
    ########################################################################


    ENEMY_NAME=$(Capitalize "$ENEMY") # Capitalize "enemy" to "Enemy" for FightTable()
    
    # Loot : Chances to get loot from enemy in %
    case "$ENEMY" in
	bandit )  EN_GOLD=20 ; EN_TOBACCO=10 ; EN_FOOD=0    ; EN_PICKPOCKET_EXP=15  ;; # 2.0 Gold, 1.0 tobacco  >  Min: 0.2 Gold, 0.1 Tobacco
	goblin )  EN_GOLD=10 ; EN_TOBACCO=20 ; EN_FOOD=0    ; EN_PICKPOCKET_EXP=20  ;; # 1.0 Gold, 2.0 Tobacco  >  Min: 0.1 Gold, 0.2 Tobacco
	boar )    EN_GOLD=0  ; EN_TOBACCO=0  ; EN_FOOD=100  ; EN_PICKPOCKET_EXP=0   ;;
	orc )     EN_GOLD=15 ; EN_TOBACCO=25 ; EN_FOOD=0    ; EN_PICKPOCKET_EXP=35  ;; # 1.5 Gold, 2.5 Tobacco  >  Min: 1.5 Gold, 2.5 Tobacco
	varg )    EN_GOLD=0  ; EN_TOBACCO=0  ; EN_FOOD=70   ; EN_PICKPOCKET_EXP=0   ;;
	mage )    EN_GOLD=50 ; EN_TOBACCO=60 ; EN_FOOD=0    ; EN_PICKPOCKET_EXP=100 ;; # 5.0 gold, 6.0 tobacco  >  Min: 0.5 Gold, 0.6 Tobacco
	dragon )  EN_GOLD=30 ; EN_TOBACCO=0  ; EN_FOOD=30   ; EN_PICKPOCKET_EXP=100 ;; 
	chthulu ) EN_GOLD=0  ; EN_TOBACCO=0  ; EN_FOOD=90   ; EN_PICKPOCKET_EXP=400 ;;
	bear )    EN_GOLD=0  ; EN_TOBACCO=0  ; EN_FOOD=100  ; EN_PICKPOCKET_EXP=0   ;;
	imp )     EN_GOLD=5  ; EN_TOBACCO=0  ; EN_FOOD=0    ; EN_PICKPOCKET_EXP=10  ;;
    esac

    # Loot: Determine loot type and size 
    (( $(RollDice2 100) <= EN_GOLD    )) && EN_GOLD=$( bc <<< "scale=2; $(RollDice2 10) * ($EN_GOLD / 100)" )      || EN_GOLD=0
    (( $(RollDice2 100) <= EN_TOBACCO )) && EN_TOBACCO=$( bc <<< "scale=2; $(RollDice2 10) * (EN_TOBACCO / 100)" ) || EN_TOBACCO=0
    if (( $(RollDice2 100) <= EN_FOOD )) ; then # Loot: Food table for animal creatures
	case "$ENEMY" in
	    boar )    EN_FOOD=$( bc <<< "scale=2; $(RollDice2 10) * 0.5"  ) ;; # max 20 days, min 2 days   (has the most eatable foodstuff)
	    varg )    EN_FOOD=$( bc <<< "scale=2; $(RollDice2 10) * 0.13" ) ;; # max  5 days, min 0.5 day  (tough, sinewy meat and less eatable)
	    chthulu ) EN_FOOD=$(RollDice2 10)                               ;; # max 40 days, min 4 days   (is huge..)
	    dragon )  EN_FOOD=$( bc <<< "scale=2; $(RollDice2 10) * 0.25" ) ;; # max 10 days, min 1 day    (doesn't taste good, but works)
	    bear )    EN_FOOD=$( bc <<< "scale=2; $(RollDice2 10) * 0.4"  ) ;; # max    days, min   day    (is considered gourmet by some)
	esac
    fi # IDEA: Boars might have tusks, dragon teeth and varg pelts (skin) you can sell at the market. (3.0)
}

FightMode_DefineInitiative() {
    GX_Monster_$ENEMY
    sleep 1 # Pause to admire monster :) # TODO playtest, not sure if this is helping..
    if (( EN_ACCURACY > ACCURACY )) || (( PLAYER_RESTING == 1 )) ; then
	NEXT_TURN="en"
	# IDEA: different promts for different enemies ???
	(( PLAYER_RESTING == 1 )) && echo "Suddenly you was attacked by the $ENEMY " || echo "The $ENEMY has initiative"
    else
	NEXT_TURN="pl"
	echo -e "$CHAR has the initiative!\n"
	read -sn 1 -p "          Press (F) to Flee (P) to Pickpocket or (A)ny key to fight" FLEE_OPT 2>&1
	GX_Monster_$ENEMY 
	# Firstly check for pickpocketing
	if [[ "$FLEE_OPT" == "p" || "$FLEE_OPT" == "P" ]]; then 
	    if (( $(RollDice2 6) > ACCURACY )) && (( $(RollDice2 6) < EN_ACCURACY )) ; then # 1st and 2nd check for pickpocket		    
		echo "You were unable to pickpocket from the ${ENEMY}!" # Pickpocket falls
		NEXT_TURN="en"
	    else 
		echo -en "\nYou successfully stole the ${ENEMY}'s pouch, " # "steal success" take loot
		case $(bc <<< "($EN_GOLD + $EN_TOBACCO) > 0") in # bc return 1 if true, 0 if false
	    	    0 ) echo -e "but it feels rather light..\n" ; PICKPOCKET=2 ;; # Player will get no loot but EXP for pickpocket
	    	    1 ) echo -e "and it feels heavy!\n";          PICKPOCKET=1 ;; # Player will get loot and EXP for pickpocket
		esac
		# Fight or flee 2nd round (player doesn't lose initiative if he'll fight after pickpocketing)
		read -sn 1 -p "                  Press (F) to Flee or (A)ny key to fight" FLEE_OPT 2>&1
	    fi
	fi
	# And secondly for flee
	if [[ "$FLEE_OPT" == "f" || "$FLEE_OPT" == "F" ]]; then	       
	    echo -e "\nTrying to slip away unseen.. (Flee: $FLEE)"
	    if (( $(RollDice2 6) <= FLEE )) ; then
		echo "You rolled $DICE and managed to run away!"
		LUCK=3
		unset FIGHTMODE
	    else
		echo "You rolled $DICE and lost your initiative.." 
		NEXT_TURN="en"
	    fi 
	fi
    fi
    sleep 2
}

#-----------------------------------------------------------------------
# FightTable()
# Display enemy's GX, player and enemy abilities
#-----------------------------------------------------------------------
FightTable() {  # Used in FightMode()
    GX_Monster_"$ENEMY"
    printf "%-12.12s\t\tHEALTH: %s\tStrength: %s\tAccuracy: %s\n" "$SHORTNAME" "$CHAR_HEALTH" "$STRENGTH" "$ACCURACY"
    printf "%-12.12s\t\tHEALTH: %s\tStrength: %s\tAccuracy: %s\n\n" "$ENEMY_NAME" "$EN_HEALTH" "$EN_STRENGTH" "$EN_ACCURACY"
}


FightMode_CharTurn() {
    read -sn 1 -p "It's your turn, press any key to (R)oll or (F) to Flee" "FIGHT_PROMPT" 2>&1
    RollDice 6
    FightTable
    echo -n "ROLL D6: $DICE "
    case "$FIGHT_PROMPT" in
	f | F ) # Player tries to flee!
	    RollDice 6 	# ????? Do we need it ??? #kstn
	    EchoFightFormula 6 le F
	    unset FIGHT_PROMPT
	    if (( DICE <= FLEE )); then
		(( DICE == FLEE )) && echo -n "$DICE =" || echo -n "$DICE <"
		echo -n " $FLEE ) You try to flee the battle .."
		sleep 2
		FightTable
		RollDice 6
		EchoFightFormula 6 le eA
		if (( DICE <= EN_ACCURACY )); then
		    (( DICE == FLEE )) && echo -n "$DICE =" || echo -n "$DICE <"
		    echo -n " $EN_ACCURACY ) The $ENEMY blocks your escape route!"
		else # Player managed to flee
		    echo -n "$DICE > $EN_ACCURACY ) You managed to flee!"
		    unset FIGHTMODE
		    LUCK=3
		    return 0
		fi
	    else
		echo -n "$DICE > $FLEE ) Your escape was unsuccessful!"
	    fi
	    ;;
	*)  # Player fights
	    unset FIGHT_PROMPT
	    if (( DICE <= ACCURACY )); then
		echo -e "\tAccuracy [D6 $DICE < $ACCURACY] Your weapon hits the target!"
		read -sn 1 -p "Press the R key to (R)oll for damage" "FIGHT_PROMPT" 2>&1
		DAMAGE=$(( $(RollDice2 6) * STRENGTH ))
		echo -en "\nROLL D6: $DICE"
		echo -en "\tYour blow dishes out $DAMAGE damage points!"
		((EN_HEALTH -= DAMAGE))
	    else
		echo -e "\tAccuracy [D6 $DICE > $ACCURACY] You missed!"
	    fi		    
    esac
}

FightMode_EnemyTurn() {
    if (( EN_HEALTH < EN_FLEE_THRESHOLD )) && (( EN_HEALTH < CHAR_HEALTH )); then # Enemy tries to flee
	echo -e "Rolling for enemy flee: D20 < $EN_FLEE"
	sleep 2
	if (( $(RollDice2 20) < EN_FLEE )); then
	    echo -e "ROLL D20: ${DICE}\tThe $ENEMY uses an opportunity to flee!"
	    LUCK=1
	    unset FIGHTMODE
	    sleep 2
	    return 0 # bugfix: Fled enemy continue fighting..
	fi		
	FightTable # If enemy didn't manage to run
    fi  # Enemy does not lose turn for trying for flee
    echo "It's the ${ENEMY}'s turn"
    sleep 2
    if (( $(RollDice2 6) <= EN_ACCURACY )); then
	echo "Accuracy [D6 $DICE < $EN_ACCURACY] The $ENEMY strikes you!"
	RollDice 6
	DAMAGE=$(( DICE * EN_STRENGTH )) # Bugfix (damage was not calculated but == DICE)
	echo "-$DAMAGE HEALTH: The $ENEMY's blow hits you with $DAMAGE points!"
	((CHAR_HEALTH -= DAMAGE))
	SaveCurrentSheet
    else
	echo "Accuracy [D6 $DICE > $EN_ACCURACY] The $ENEMY misses!"
    fi
}

FightMode_CheckForDeath() {
    if ((CHAR_HEALTH <= 0)); then # If player is dead
	echo "Your health points are $CHAR_HEALTH" && sleep 2
	echo "You WERE KILLED by the $ENEMY, and now you are dead..." && sleep 2
	if ((CHAR_EXP >= 1000)) && ((CHAR_HEALTH > -15)); then
	    ((CHAR_HEALTH += 20))
	    echo "However, your $CHAR_EXP Experience Points relates that you have"
	    echo "learned many wondrous and magical things in your travels..!"
	    echo "+20 HEALTH: Health restored by 20 points (HEALTH: $CHAR_HEALTH)"
	elif HaveItem "$GUARDIAN_ANGEL" && ((CHAR_HEALTH > -5)); then
	    ((CHAR_HEALTH += 5))
	    echo "Suddenly you awake again, SAVED by your Guardian Angel!"
	    echo "+5 HEALTH: Health restored by 5 points (HEALTH: $CHAR_HEALTH)"
	else # DEATH!
	    echo "Gain 1000 Experience Points to achieve magic healing!"
	    sleep 4		
	    Death # Moved to separate function because we will also need it in check-for-starvation
	fi
	LUCK=2
	sleep 8
    fi
}

#-----------------------------------------------------------------------
# FightMode_CheckForExp()
# Define how many EXP player will get for this battle
# Arguments: $LUCK(int)
#-----------------------------------------------------------------------
FightMode_CheckForExp() {
    case "$1" in
	1)  # ENEMY managed to FLEE
	    echo -e "\nYou defeated the $ENEMY and gained $EN_FLEE_EXP Experience Points!" 
	    ((CHAR_EXP += EN_FLEE_EXP)) ;;
	2)  # died but saved by guardian angel or 1000 EXP
	    echo -e "\nWhen you come to, the $ENEMY has left the area ..." ;;
	3)  # PLAYER managed to FLEE during fight!
	    echo -e "\nYou got away while the $ENEMY wasn't looking, gaining $PL_FLEE_EXP Experience Points!"
	    ((CHAR_EXP += PL_FLEE_EXP)) ;;
	*)  # ENEMY was slain!
	    echo -e "\nYou defeated the $ENEMY and gained $EN_DEFEATED_EXP Experience Points!\n" 
	    ((CHAR_EXP += EN_DEFEATED_EXP))
	    ((CHAR_KILLS++))
    esac
    ((CHAR_BATTLES++))		# At any case increase CHAR_BATTLES
}

#-----------------------------------------------------------------------
# FightMode_CheckForPickpocket()
# Check how many GOLD, TOBACCO and EXP for pickpocketing player wil get
# for this battle
# Arguments: $PICKPOCKET(int)
#-----------------------------------------------------------------------
FightMode_CheckForPickpocket() {
    case "$1" in 
	0 ) # no pickpocketing was
	    if ((LUCK == 0)); then # Only if $ENEMY was slain
		echo -n "Searching the dead ${ENEMY}'s corpse, you find "
		if (( $(bc <<< "($EN_GOLD + $EN_TOBACCO) == 0") )) ; then
		    echo "mostly just lint .."
		else
		    (( $(bc <<< "$EN_GOLD > 0") )) && CHAR_GOLD=$( bc <<< "$CHAR_GOLD + $EN_GOLD" ) || EN_GOLD="no"
		    (( $(bc <<< "$EN_TOBACCO > 0") )) && CHAR_TOBACCO=$( bc <<< "$CHAR_TOBACCO + $EN_TOBACCO" ) || EN_TOBACCO="no"
		    echo "$EN_GOLD gold and $EN_TOBACCO tobacco"			
		fi
	    fi ;;
	1 ) # loot and EXP
	    echo -n "In the pouch lifted from the ${ENEMY}, you find $EN_GOLD gold and $EN_TOBACCO tobacco" ;
	    CHAR_GOLD=$( bc <<< "$CHAR_GOLD + $EN_GOLD" ) ;
	    CHAR_TOBACCO=$( bc <<< "$CHAR_TOBACCO + $EN_TOBACCO" ) ;
	    case "$ENEMY" in
		orc ) echo "$CHAR gained $EN_PICKPOCKET_EXP Experience Points for successfully pickpocketing an $ENEMY!" ;;
		*   ) echo "$CHAR gained $EN_PICKPOCKET_EXP Experience Points for successfully pickpocketing a $ENEMY!" ;;
	    esac
	    ((CHAR_EXP += EN_PICKPOCKET_EXP)) ;;
	2)  # no loot but EXP
	    echo -n "In the pouch lifted from the ${ENEMY}, you find nothing but ..." ;
	    echo -n "gained $EN_PICKPOCKET_EXP Experience Points for successfully pickpocketing" ;
	    ((CHAR_EXP += EN_PICKPOCKET_EXP)) ;;
    esac
}

#-----------------------------------------------------------------------
# FightMode_CheckForLoot()
# Check which loot player will take from this enemy 
# TODO: check for boar's tusks etc (3.0)
#-----------------------------------------------------------------------
FightMode_CheckForLoot() {
    if ((LUCK == 0)); then # Only if $ENEMY was slain
	(( $(bc <<< "$EN_FOOD > 0") )) && echo "You scavenge $EN_FOOD food from the ${ENEMY}'s body" && CHAR_FOOD=$(bc <<< "$CHAR_FOOD + $EN_FOOD")
    fi
}

#-----------------------------------------------------------------------
# FightMode()
# Main fight loop.
#-----------------------------------------------------------------------
FightMode() {	# Used in NewSector() and Rest()
    FightMode_ResetFlags	# Reset all FightMode flags to default
    FightMode_DefineEnemy       # Define enemy for this battle
    FightMode_AddBonuses        # Adjustments for items
    FightMode_DefineInitiative  # DETERMINE INITIATIVE (will usually be enemy)
    FightMode_RemoveBonuses     # Remove bonuses
    ########################################################################
    while ((FIGHTMODE)); do                                                     # If player didn't manage to run
	FightTable	                                                        # Display enemy GX, player and enemy abilities
	[[ "$NEXT_TURN" == "pl" ]] && FightMode_CharTurn || FightMode_EnemyTurn # Define which turn is
	((CHAR_HEALTH <= 0)) || ((EN_HEALTH <= 0)) && unset FIGHTMODE           # Exit loop if player or enemy is dead
	[[ "$NEXT_TURN" == "pl" ]] && NEXT_TURN="en" || NEXT_TURN="pl"          # Change initiative
	sleep 2
    done
    ########################################################################
    FightMode_CheckForDeath	               # Check if player is alive
    GX_Monster_$ENEMY		               # Display enemy GX last time
    FightMode_CheckForExp "$LUCK"	       # 
    FightMode_CheckForPickpocket "$PICKPOCKET" # 
    FightMode_CheckForLoot	               # 
    SaveCurrentSheet
    sleep 6
    DisplayCharsheet
}   # Return to NewSector() or to Rest()

#                                                                      #
#                                                                      #
########################################################################

