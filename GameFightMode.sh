########################################################################
#                              Fight mode                              #
#                      (secondary loop for fights)                     #

#-----------------------------------------------------------------------
# CheckForFight()
# Calls FightMode if player is attacked at current scenario.
# Returns	0 - check succsees, no attack
#		1 - check fails, fight mode
# Arguments : $SCENARIO (char)
# Used : NewSector(), Rest()
#-----------------------------------------------------------------------
CheckForFight() {
    RollDice 100        # Find out if we're attacked
    if [[ ! "$PLAYER_RESTING" ]] ; then # usual fight
	case "$1" in        # FightMode() if RollForEvent return 0
	    H ) RollForEvent 1  "fight" && FightMode && return 1 ;;
	    x ) RollForEvent 50 "fight" && FightMode && return 1 ;;
	    . ) RollForEvent 20 "fight" && FightMode && return 1 ;;
	    T ) RollForEvent 15 "fight" && FightMode && return 1 ;;
	    @ ) RollForEvent 35 "fight" && FightMode && return 1 ;;
	    C ) RollForEvent 10 "fight" && FightMode && return 1 ;;
	    * ) CustomMapError ;;
	esac
    else 			# player was attacked at rest
	case "$1" in
	    H ) ;;			#  do nothing
	    x ) RollForEvent 60 "fight" && FightMode && return 1 ;;
	    . ) RollForEvent 30 "fight" && FightMode && return 1 ;;
	    T ) RollForEvent 15 "fight" && FightMode && return 1 ;;
	    @ ) RollForEvent 35 "fight" && FightMode && return 1 ;;
	    C ) RollForEvent 5  "fight" && FightMode && return 1 ;;
	    * ) CustomMapError ;;
	esac
    fi
    return 0 			# check falls
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
# Set fight bonuses from magick items (BEFORE 'DefineInitiative()'!)
# IDEA: If player was attacked during the rest (at night) he and enemies
#  can get + or - for night and moon phase here ??? (3.0)
#-----------------------------------------------------------------------
FightMode_AddBonuses() {
    HaveItem "$QUICK_RABBIT_REACTION"   && ((ACCURACY++))
    HaveItem "$FLASK_OF_TERRIBLE_ODOUR" && ((EN_FLEE++))
}

#-----------------------------------------------------------------------
# FightMode_RemoveBonuses()
# Set fight bonuses from magick items (AFTER 'DefineInitiative()' but
#  BEFORE fight loop!)
#-----------------------------------------------------------------------
FightMode_RemoveBonuses() {
    HaveItem "$QUICK_RABBIT_REACTION" && ((ACCURACY--))
}

#-----------------------------------------------------------------------
# FightMode_DefineEnemy()
# Determine generic enemy and set enemy's abilities
# ENEMY ATTRIBUTES:
# $EN_FLEE_THRESHOLD - At what Health will enemy flee? :)
# $EN_EXP            - Exp player get if he manage to kill the enemy
#-----------------------------------------------------------------------
FightMode_DefineEnemy() {
    # Determine generic enemy type from chthulu, orc, varg, mage, goblin, bandit, boar, dragon, bear, imp (10)
    # Every enemy should have 3 appearances, not counting HOME.
    RollDice 100
    case "$SCENARIO" in # Lowest to Greatest % of encounter ENEMY in areas from civilized, to nature, to wilderness
	H ) ((DICE <= 10)) && ENEMY="chthulu" || ((DICE <= 30)) && ENEMY="imp"    || ENEMY="dragon" ;; # 10, 20, 70
	T ) ((DICE <= 10)) && ENEMY="dragon"  || ((DICE <= 45)) && ENEMY="mage"   || ENEMY="bandit" ;; # 10, 35, 55
	C ) ((DICE <= 5 )) && ENEMY="chthulu" || ((DICE <= 10)) && ENEMY="imp"    || ((DICE <= 50)) && ENEMY="dragon" || ENEMY="mage" ;;  #  5,  5, 40, 50
	. ) ((DICE <= 5 )) && ENEMY="orc"     || ((DICE <= 10)) && ENEMY="boar"   || ((DICE <= 30)) && ENEMY="goblin" || ((DICE <= 60)) && ENEMY="bandit" || ENEMY="imp"  ;;  #  5,  5, 20, 30, 40
	@ ) ((DICE <= 5 )) && ENEMY="bear"    || ((DICE <= 15)) && ENEMY="orc"    || ((DICE <= 30)) && ENEMY="boar"   || ((DICE <= 50)) && ENEMY="goblin" || ((DICE <= 70)) && ENEMY="imp" || ENEMY="bandit" ;; #  5, 10, 15, 20, 20, 30
	x ) ((DICE <= 5 )) && ENEMY="boar"    || ((DICE <= 10)) && ENEMY="goblin" || ((DICE <= 30)) && ENEMY="bear"   || ((DICE <= 50)) && ENEMY="varg"   || ((DICE <= 75)) && ENEMY="orc" || ENEMY="dragon" ;; #  5,  5, 20, 20, 25, 25
    esac

    case "$ENEMY" in
	bandit )  EN_STRENGTH=1 ; EN_ACCURACY=4 ; EN_FLEE=7 ; EN_HEALTH=30  ; EN_FLEE_THRESHOLD=18 ; EN_EXP=20   ;;
	imp )     EN_STRENGTH=2 ; EN_ACCURACY=3 ; EN_FLEE=3 ; EN_HEALTH=20  ; EN_FLEE_THRESHOLD=10 ; EN_EXP=10   ;;
	goblin )  EN_STRENGTH=3 ; EN_ACCURACY=3 ; EN_FLEE=5 ; EN_HEALTH=30  ; EN_FLEE_THRESHOLD=15 ; EN_EXP=30   ;;
	boar )    EN_STRENGTH=4 ; EN_ACCURACY=2 ; EN_FLEE=3 ; EN_HEALTH=60  ; EN_FLEE_THRESHOLD=35 ; EN_EXP=40   ;;
	orc )     EN_STRENGTH=4 ; EN_ACCURACY=4 ; EN_FLEE=4 ; EN_HEALTH=80  ; EN_FLEE_THRESHOLD=40 ; EN_EXP=50   ;;
	varg )    EN_STRENGTH=4 ; EN_ACCURACY=3 ; EN_FLEE=3 ; EN_HEALTH=80  ; EN_FLEE_THRESHOLD=60 ; EN_EXP=100  ;;
	mage )    EN_STRENGTH=5 ; EN_ACCURACY=3 ; EN_FLEE=4 ; EN_HEALTH=90  ; EN_FLEE_THRESHOLD=45 ; EN_EXP=150  ;;
	dragon )  EN_STRENGTH=5 ; EN_ACCURACY=3 ; EN_FLEE=2 ; EN_HEALTH=150 ; EN_FLEE_THRESHOLD=50 ; EN_EXP=180  ;;
	chthulu ) EN_STRENGTH=6 ; EN_ACCURACY=5 ; EN_FLEE=1 ; EN_HEALTH=500 ; EN_FLEE_THRESHOLD=35 ; EN_EXP=1000 ;;
	bear )    EN_STRENGTH=6 ; EN_ACCURACY=2 ; EN_FLEE=4 ; EN_HEALTH=160 ; EN_FLEE_THRESHOLD=25 ; EN_EXP=60   ;;
    esac

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
    EN_GOLD=$(    bc <<< "scale=2; if ($(RollDice2 100) > $EN_GOLD   ) 0 else $(RollDice2 10) * ($EN_GOLD / 100)" )
    EN_TOBACCO=$( bc <<< "scale=2; if ($(RollDice2 100) > $EN_TOBACCO) 0 else $(RollDice2 10) * ($EN_TOBACCO / 100)" )
    if (( $(RollDice2 100) <= EN_FOOD )) ; then # Loot: Food table for animal creatures
	case "$ENEMY" in
	    boar )    EN_FOOD=$( bc <<< "scale=2; $(RollDice2 10) * 0.5"  ) ;; # max 20 days, min 2 days   (has the most eatable foodstuff)
	    varg )    EN_FOOD=$( bc <<< "scale=2; $(RollDice2 10) * 0.13" ) ;; # max  5 days, min 0.5 day  (tough, sinewy meat and less eatable)
	    chthulu ) EN_FOOD=$(RollDice2 10)                               ;; # max 40 days, min 4 days   (is huge..)
	    dragon )  EN_FOOD=$( bc <<< "scale=2; $(RollDice2 10) * 0.25" ) ;; # max 10 days, min 1 day    (doesn't taste good, but works)
	    bear )    EN_FOOD=$( bc <<< "scale=2; $(RollDice2 10) * 0.4"  ) ;; # max    days, min   day    (is considered gourmet by some)
	esac
    fi
    # IDEA: Boars might have tusks, dragon teeth and varg pelts (skin) you can sell at the market. (3.0)
}

FightMode_DefineInitiative() {
    GX_Monster "$ENEMY"		# Display $ENEMY GX - only one time!
    tput sc 			# Store cursor position for FightMode_FightTable()
    Sleep 1 # Pause to admire monster :) # TODO playtest, not sure if this is helping..
    if (( EN_ACCURACY > ACCURACY )) || ((PLAYER_RESTING)) ; then
	NEXT_TURN="en"
	# IDEA: different promts for different enemies ???
	(( PLAYER_RESTING == 1 )) && echo -e "You're awoken by an intruder, the $ENEMY attacks!" || echo "The $ENEMY has initiative"
    else
	NEXT_TURN="pl"
	echo -e "$CHAR has the initiative!\n"
	read -sn 1 -p "          Press (F) to Flee (P) to Pickpocket or (A)ny key to fight" FLEE_OPT 2>&1
	tput rc && tput ed # restore cursor position && clear to the end of display
	# Firstly check for pickpocketing
	if [[ "$FLEE_OPT" == [pP] ]]; then
	    # TODO check this test
	    if (( $(RollDice2 6) > ACCURACY )) && (( $(RollDice2 6) < EN_ACCURACY )) ; then # 1st and 2nd check for pickpocket
		echo "You were unable to pickpocket from the ${ENEMY}!"           # Pickpocket falls
		NEXT_TURN="en"
	    else
		echo -en "You successfully stole the ${ENEMY}'s pouch, "        # "steal success" take loot
		case $(bc <<< "($EN_GOLD + $EN_TOBACCO) > 0") in                  # bc return 1 if true, 0 if false
	    	    0 ) echo -e "but it feels rather light..\n" ; PICKPOCKET=2 ;; # Player will get no loot but EXP for pickpocket
	    	    1 ) echo -e "and it feels heavy!\n";          PICKPOCKET=1 ;; # Player will get loot and EXP for pickpocket
		esac
		# Fight or flee 2nd round (player doesn't lose initiative if he'll fight after pickpocketing)
		read -sn 1 -p "                  Press (F) to Flee or (A)ny key to fight" FLEE_OPT 2>&1
	    fi
	fi
	# And secondly for flee
	if [[ "$FLEE_OPT" == [fF] ]]; then
	    echo -e "\nTrying to slip away unseen.."
	    RollDice 6
	    if (( DICE <= FLEE )) ; then
		Echo "You managed to run away!" "[Flee:D6 $DICE <= $FLEE ]"
		LUCK=3
		unset FIGHTMODE
	    else
		Echo "You lost your initiative.." "[Flee:D6 $DICE > $FLEE]"
		NEXT_TURN="en"
		Sleep 1
	    fi
	fi
    fi
    Sleep 1
}

#-----------------------------------------------------------------------
# FightMode_FightTable()
# Display enemy's GX, player and enemy abilities
# Used: FightMode()
#-----------------------------------------------------------------------
FightMode_FightTable() {
    tput rc && tput ed # restore cursor position && clear to the end of display  (GX_Monster "$ENEMY" is already displayed)
    printf "%-12.12s\t\tHEALTH: %s\tStrength: %s\tAccuracy: %s\n" "$SHORTNAME" "$CHAR_HEALTH" "$STRENGTH" "$ACCURACY"
    printf "%-12.12s\t\tHEALTH: %s\tStrength: %s\tAccuracy: %s\n\n" "$(Capitalize "$ENEMY")" "$EN_HEALTH" "$EN_STRENGTH" "$EN_ACCURACY"
}

#-----------------------------------------------------------------------
# FightMode_FightFormula()
# Display Formula in Fighting
# Arguments: $DICE_SIZE(int), $FORMULA(string), $SKILLABBREV(string)
#-----------------------------------------------------------------------
FightMode_FightFormula() {
    local DICE_SIZE="$1" FORMULA="$2" SKILLABBREV="$3"
    (( DICE_SIZE <= 9 )) && DICE_SIZE+=" "
    case "$FORMULA" in
	eq )    FORMULA="= " ;;
	gt )    FORMULA="> " ;;
	lt )    FORMULA="< " ;;
	ge )    FORMULA=">=" ;;
	le )    FORMULA="<=" ;;
	times ) FORMULA="x " ;;
    esac
    echo -n "Roll D${DICE_SIZE} $FORMULA $SKILLABBREV ( " # skill & roll
    # The actual symbol in $DICE vs eg $CHAR_ACCURACY is already
    # determined in the if and cases of the Fight Loop, so don't repeat here.
}

FightMode_CharTurn() {
    local FIGHT_PROMPT
    echo -n "It's your turn, press any key to (R)oll or (F) to Flee"
    FIGHT_PROMPT=$(Read)
    RollDice 6
    FightMode_FightTable
    case "$FIGHT_PROMPT" in
	f | F ) # Player tries to flee!
	    if (( DICE <= FLEE )); then # first check for flee
		Echo "You try to flee the battle .." "[D6 $DICE <= Flee $FLEE]"
		Sleep 2
		RollDice 6
		if (( DICE <= EN_ACCURACY )); then # second check for flee
		    Echo "\nThe $ENEMY blocks your escape route!" "[D6 $DICE <= EnemyAccuracy $EN_ACCURACY]"
		else # Player managed to flee
		    Echo "\nYou managed to flee!" "[D6 $DICE > EnemyAccuracy $EN_ACCURACY]"
		    unset FIGHTMODE
		    LUCK=3
		    return 0
		fi
	    else
		Echo "Your escape was unsuccessful!" "[D6 $DICE > Flee $FLEE]"
	    fi
	    ;;
	*)  # Player fights
	    if (( DICE <= ACCURACY )); then
		Echo "Your weapon hits the target!" "[D6 $DICE <= Accuracy $ACCURACY]"
		echo -en "\nPress the R key to (R)oll for damage"
		FIGHT_PROMPT=$(Read)
		RollDice 6
		DAMAGE=$(( DICE * STRENGTH ))
		Echo "${CLEAR_LINE}Your blow dishes out $DAMAGE damage points!" "[D6 $DICE * STRENGTH $STRENGTH]" #-${DAMAGE} ENEMY_HEALTH]"
		((EN_HEALTH -= DAMAGE))
	    else
		Echo "You missed!" "[D6 $DICE > Accuracy $ACCURACY]"
	    fi
    esac
}

FightMode_EnemyTurn() {
    echo -n "It's the ${ENEMY}'s turn:"
    Sleep 2
    if (( EN_HEALTH < EN_FLEE_THRESHOLD )) && (( EN_HEALTH < CHAR_HEALTH )); then # Enemy tries to flee
	echo -e "${CLEAR_LINE}$(Capitalize "$ENEMY") tries to flee the battle:"
	Sleep 2
	RollDice 20
	if (( DICE < EN_FLEE )); then
	    Echo "The $ENEMY uses an opportunity to flee!" "[D20 $DICE < EnemyFlee $EN_FLEE]"
	    LUCK=1
	    unset FIGHTMODE
	    Sleep 2 # TODO test
	    return 0 # bugfix: Fled enemy continue fighting..
	else
	    Echo "You block the ${ENEMY}'s escape route!" "[D20 $DICE >= EnemyFlee $EN_FLEE]"
	    Sleep 2.5
	fi	
	FightMode_FightTable # If enemy didn't manage to run
    fi  # Enemy does not lose turn for trying for flee
    RollDice 6
    if (( DICE <= EN_ACCURACY )); then
	Echo "${CLEAR_LINE}The $ENEMY strikes you!" "[D6 $DICE <= EnemyAccuracy $EN_ACCURACY]"
	Sleep 2
	RollDice 6
	local DAMAGE=$(( DICE * EN_STRENGTH )) # Bugfix (damage was not calculated but == DICE)
	Echo "\nThe $ENEMY's blow hits you with $DAMAGE points!" "[-${DAMAGE} HEALTH]" 
	((CHAR_HEALTH -= DAMAGE))
	SaveCurrentSheet
	Sleep 1 # TODO test
    else
	Echo "${CLEAR_LINE}The $ENEMY misses!" "[D6 $DICE > Accuracy $EN_ACCURACY]"
    fi
#    read -sn 1 ### DEBUG
}

FightMode_CheckForDeath() {
    if ((CHAR_HEALTH <= 0)); then # If player is dead
	FightMode_FightTable
	echo "Your health points are $CHAR_HEALTH"
	Sleep 2
	echo "You WERE KILLED by the $ENEMY, and now you are dead..."
	Sleep 2
	if ((CHAR_EXP >= 1000)) && ((CHAR_HEALTH > -15)); then
	    ((CHAR_HEALTH += 20))
	    echo "However, your $CHAR_EXP Experience Points relates that you have"
	    echo "learned many wondrous and magical things in your travels..!"
	    Echo "Health restored by 20 points (HEALTH: $CHAR_HEALTH)" "[+20 HEALTH]"
	elif HaveItem "$GUARDIAN_ANGEL" && ((CHAR_HEALTH > -5)); then
	    ((CHAR_HEALTH += 5))
	    echo "Suddenly you awake again, SAVED by your Guardian Angel!"
	    Echo "Health restored by 5 points (HEALTH: $CHAR_HEALTH)" "[+5 HEALTH]"
	else # DEATH!
	    echo "Gain 1000 Experience Points to achieve magic healing!"
	    Sleep 4
	    Death "$DEATH_FIGHT" # And CleanUp
	fi
	LUCK=2
	Sleep 8
    fi
}

#-----------------------------------------------------------------------
# FightMode_CheckForExp()
# Define how many EXP player will get for this battle
# Arguments: $LUCK(int)
#-----------------------------------------------------------------------
FightMode_CheckForExp() {
    case "$1" in
	1)  # ENEMY managed to FLEE (1/2 $EN_EXP)
	    EN_EXP=$((EN_EXP / 2))
	    Echo "The $ENEMY fleed from you!" "[+${EN__EXP} EXP]"
	    ((CHAR_EXP += EN__EXP)) ;;
	2)  # PLAYER died but saved by guardian angel or 1000 EXP
	    echo -e "When you come to, the $ENEMY has left the area ..." ;;
	3)  # PLAYER managed to FLEE during fight! (1/4 $EN_EXP)
	    EN_EXP=$((EN_EXP / 4)) 
	    Echo "You got away while the $ENEMY wasn't looking!" "[+${EN_EXP} EXP]"
	    ((CHAR_EXP += EN_EXP)) ;;
	*)  # ENEMY was slain!
	    Echo "You defeated the $ENEMY!" "[+${EN_EXP} EXP]"
	    ((CHAR_EXP += EN_EXP))
	    ((CHAR_KILLS++))
    esac
    ((CHAR_BATTLES++))		# At any case increase CHAR_BATTLES
    Sleep 1 # TODO test
}

#-----------------------------------------------------------------------
# FightMode_CheckForPickpocket()
# Check how many GOLD, TOBACCO and EXP for pickpocketing player will
# get for this battle
# Arguments: $PICKPOCKET(int)
#-----------------------------------------------------------------------
FightMode_CheckForPickpocket() {
    case "$1" in
	0 ) # no pickpocketing was
	    if ((LUCK == 0)); then # Only if $ENEMY was slain
		echo -en "\nSearching the dead ${ENEMY}'s corpse, you find "
		if (( $(bc <<< "($EN_GOLD + $EN_TOBACCO) == 0") )) ; then
		    echo "mostly just lint .."
		else
		    (( $(bc <<< "$EN_GOLD > 0")    )) && CHAR_GOLD=$( bc <<< "$CHAR_GOLD + $EN_GOLD" )          || EN_GOLD="no"
		    (( $(bc <<< "$EN_TOBACCO > 0") )) && CHAR_TOBACCO=$( bc <<< "$CHAR_TOBACCO + $EN_TOBACCO" ) || EN_TOBACCO="no"
		    echo "$EN_GOLD gold and $EN_TOBACCO tobacco"
		fi
	    fi ;;
	1 ) # loot and EXP
	    (( $(bc <<< "$EN_GOLD > 0")    )) && CHAR_GOLD=$( bc <<< "$CHAR_GOLD + $EN_GOLD" )          || EN_GOLD="no"
	    (( $(bc <<< "$EN_TOBACCO > 0") )) && CHAR_TOBACCO=$( bc <<< "$CHAR_TOBACCO + $EN_TOBACCO" ) || EN_TOBACCO="no"	    
	    echo -e "\nIn the pouch lifted from the ${ENEMY}, you find $EN_GOLD gold and $EN_TOBACCO tobacco" ;
	    Echo " and gained experience for successfully pickpocketing!" "[+${EN_PICKPOCKET_EXP} EXP]";
	    ((CHAR_EXP += EN_PICKPOCKET_EXP)) ;;
	2)  # no loot but EXP
	    echo -e "\nIn the pouch lifted from the ${ENEMY}, you find nothing of value.." ;
	    Echo ".. but you gained experience for successfully pickpocketing!" "[+${EN_PICKPOCKET_EXP} EXP]";
	    ((CHAR_EXP += EN_PICKPOCKET_EXP)) ;;
    esac
}

#-----------------------------------------------------------------------
# FightMode_CheckForLoot()
# Check which loot player will take from this enemy
# TODO: check for boar's tusks etc (3.0)
#-----------------------------------------------------------------------
FightMode_CheckForLoot() {
    if ((LUCK == 0)); then                   # Only if $ENEMY was slain
	if (( $(bc <<< "$EN_FOOD > 0") )); then	 #  and have some FOOD
	    Echo "\nYou scavenge $EN_FOOD food from the ${ENEMY}'s body" "[+${EN_FOOD} FOOD]"
	    CHAR_FOOD=$(bc <<< "$CHAR_FOOD + $EN_FOOD")
	fi
    fi
}

#-----------------------------------------------------------------------
# FightMode()
# Main fight loop.
#-----------------------------------------------------------------------
FightMode() {	# Used in NewSector() and Rest()
    FightMode_ResetFlags	                                                # Reset all FightMode flags to default
    FightMode_DefineEnemy                                                       # Define enemy for this battle
    FightMode_AddBonuses                                                        # Set adjustments for items
    FightMode_DefineInitiative                                                  # DETERMINE INITIATIVE (will usually be enemy)
    FightMode_RemoveBonuses                                                     # Remove adjustments for items
    ############################ Main fight loop ###########################
    while ((FIGHTMODE)); do                                                     # If player didn't manage to run
	FightMode_FightTable                                                    # Display enemy GX, player and enemy abilities
	[[ "$NEXT_TURN" == "pl" ]] && FightMode_CharTurn || FightMode_EnemyTurn # Define which turn is and make it
	((CHAR_HEALTH <= 0 || EN_HEALTH <= 0)) && unset FIGHTMODE               # Exit loop if player or enemy is dead
	[[ "$NEXT_TURN" == "pl" ]] && NEXT_TURN="en" || NEXT_TURN="pl"          #  or change initiative and next turn
	Sleep 2			                                                #  after pause
    done
    ########################################################################
    FightMode_CheckForDeath	                                                # Check if player is alive
    FightMode_FightTable	                                                # Display enemy GX last time
    FightMode_CheckForExp "$LUCK"	                                        #
    FightMode_CheckForPickpocket "$PICKPOCKET"                                  #
    FightMode_CheckForLoot	                                                #
    SaveCurrentSheet
    Sleep 6
    DisplayCharsheet
}
#                                                                      #
#                                                                      #
########################################################################

