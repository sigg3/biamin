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
    local CHANCE
    # define chances
    if [[ ! "$PLAYER_RESTING" ]] ; then # usual fight
	case "$1" in
	    H ) CHANCE=1  ;;
	    x ) CHANCE=50 ;;
	    . ) CHANCE=20 ;;
	    T ) CHANCE=15 ;;
	    @ ) CHANCE=35 ;;
	    C ) CHANCE=10 ;;
	    * ) CustomMapError ;;
	esac
    else 		     # player was attacked at rest
	case "$1" in
	    H ) return 0  ;; #  do nothing
	    x ) CHANCE=60 ;;
	    . ) CHANCE=30 ;;
	    T ) CHANCE=15 ;;
	    @ ) CHANCE=35 ;;
	    C ) CHANCE=5  ;;
	    * ) CustomMapError ;;
	esac
    fi
    # Find out if we're attacked
    RollDice 100
    if RollForEvent "${CHANCE}" "event" ; then # "Rolling for fight" is inaccurate:P
	FightMode
	return 1	     # check fails, fight
    else
	return 0 	     # check success, no fight was
    fi
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
#	1 - successful pickpocketing with loot (EXP + loot)
#	2 - successful pickpocketing without loot (only EXP)
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
# Named constants for enemies. Should be in accordance with ${ENEMIES[@]}
#-----------------------------------------------------------------------
declare -r  BANDIT=0
declare -r     IMP=1
declare -r  GOBLIN=2
declare -r    BOAR=3
declare -r     ORC=4
declare -r    VARG=5
declare -r    MAGE=6
declare -r  DRAGON=7
declare -r CHTHULU=8
declare -r    BEAR=9

#-----------------------------------------------------------------------
# ${ENEMIES[@]}
# Enemies ablilities table. Folders marked '%' is chances to have
# current loot.
# FleeTreshhold ($EN_FLEE_THRESHOLD) - At what Health will enemy flee?
# Exp($EN_EXP)                       - Exp player get if he manage to
#                                      kill the enemy
# PickpocketExp($EN_PICKPOCKET_EXP)  - How many EXP player'll get for
#                                      successful pickpocketing
#-----------------------------------------------------------------------
declare -ra ENEMIES=(
    #                                                        %    %       %
    #Name    Strength Accuracy Flee Health FleeTreshhold Exp Gold Tobacco Food PickpocketExp"
    "bandit  1        4        7     30    18             20 20   10        0   15"
    "imp     2        3        3     20    10             10  5    0        0   10"
    "goblin  3        3        5     30    15             30 10   20        0   20"
    "boar    4        2        3     60    35             40  0    0      100    0"
    "orc     4        4        4     80    40             50 15   25        0   35"
    "varg    4        3        3     80    60            100  0    0       70    0"
    "mage    5        3        4     90    45            150 50   60        0  100"
    "dragon  5        3        2    150    50            180 30    0       30  100"
    "chthulu 6        5        1    500    35           1000  0    0       90   40"
    "bear    6        2        4    160    25             60  0    0      100    0"
)

#-----------------------------------------------------------------------
# FightMode_DefineEnemy()
# Determine generic enemy and set enemy's abilities
# ENEMY ATTRIBUTES:
#-----------------------------------------------------------------------
FightMode_DefineEnemy() {
    # Determine generic enemy type from chthulu, orc, varg, mage, goblin, bandit, boar, dragon, bear, imp (10)
    # Every enemy should have 3 appearances, not counting HOME.
    RollDice 100
    case "$SCENARIO" in # Lowest to Greatest % of encounter ENEMY in areas from civilized, to nature, to wilderness
	H ) ((DICE <= 10)) && ENEMY="${CHTHULU}" || ((DICE <= 30)) && ENEMY="${IMP}"    || ENEMY="${DRAGON}" ;; # 10, 20, 70
	T ) ((DICE <= 10)) && ENEMY="${DRAGON}"  || ((DICE <= 45)) && ENEMY="${MAGE}"   || ENEMY="${BANDIT}" ;; # 10, 35, 55
	C ) ((DICE <= 5 )) && ENEMY="${CHTHULU}" || ((DICE <= 10)) && ENEMY="${IMP}"    || ((DICE <= 50)) && ENEMY="${DRAGON}" || ENEMY="${MAGE}" ;;  #  5,  5, 40, 50
	. ) ((DICE <= 5 )) && ENEMY="${ORC}"     || ((DICE <= 10)) && ENEMY="${BOAR}"   || ((DICE <= 30)) && ENEMY="${GOBLIN}" || ((DICE <= 60)) && ENEMY="${BANDIT}" || ENEMY="${IMP}"  ;;  #  5,  5, 20, 30, 40
	@ ) ((DICE <= 5 )) && ENEMY="${BEAR}"    || ((DICE <= 15)) && ENEMY="${ORC}"    || ((DICE <= 30)) && ENEMY="${BOAR}"   || ((DICE <= 50)) && ENEMY="${GOBLIN}" || ((DICE <= 70)) && ENEMY="${IMP}" || ENEMY="${BANDIT}" ;; #  5, 10, 15, 20, 20, 30
	x ) ((DICE <= 5 )) && ENEMY="${BOAR}"    || ((DICE <= 10)) && ENEMY="${GOBLIN}" || ((DICE <= 30)) && ENEMY="${BEAR}"   || ((DICE <= 50)) && ENEMY="${VARG}"   || ((DICE <= 75)) && ENEMY="${ORC}" || ENEMY="${DRAGON}" ;; #  5,  5, 20, 20, 25, 25
    esac

	# DEBUG TEST ENEMY HERE
	#ENEMY="${MAGE}" # COMMENT WHEN DONE

    # Set enemy abilities
    read ENEMY EN_STRENGTH EN_ACCURACY EN_FLEE EN_HEALTH EN_FLEE_THRESHOLD EN_EXP EN_GOLD EN_TOBACCO EN_FOOD EN_PICKPOCKET_EXP <<< "${ENEMIES[$ENEMY]}"

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
    if (( EN_ACCURACY > ACCURACY || PLAYER_RESTING)) ; then
	NEXT_TURN="en"
	# IDEA: different promts for different enemies ???
	(( PLAYER_RESTING == 1 )) && echo -e "You're awoken by an intruder, the $ENEMY attacks!" || echo "The $ENEMY has initiative"
    else
	NEXT_TURN="pl"
	echo -e "$CHAR has the initiative!\n"
	MakePrompt "Press (F) to Flee, (P) to Pickpocket or (A)ny key to fight"
	FLEE_OPT=$(Read)
	tput rc && tput ed # restore cursor position && clear to the end of display
	# Firstly check for pickpocketing
	if [[ "$FLEE_OPT" == [pP] ]]; then
	    # TODO check this test
	    if (( $(RollDice2 6) > ACCURACY && $(RollDice2 6) < EN_ACCURACY )) ; then # 1st and 2nd check for pickpocket
		echo "You were unable to pickpocket from the ${ENEMY}!"           # Pickpocket falls
		NEXT_TURN="en"
	    else
		echo -n "You successfully stole the ${ENEMY}'s pouch, "           # "steal success" take loot
		case $(bc <<< "($EN_GOLD + $EN_TOBACCO) > 0") in                  # bc return 1 if true, 0 if false
	    	    0 ) echo -e "but it feels rather light..\n" ; PICKPOCKET=2 ;; # Player will get no loot but EXP for pickpocket
	    	    1 ) echo -e "and it feels heavy!\n";          PICKPOCKET=1 ;; # Player will get loot and EXP for pickpocket
		esac
		# Fight or flee 2nd round (player doesn't lose initiative if he'll fight after pickpocketing)
		MakePrompt "Press (F) to Flee or (A)ny key to fight"
		FLEE_OPT=$(Read)
	    fi
	fi
	# And secondly for flee
	if [[ "$FLEE_OPT" == [fF] ]]; then
	    tput rc && tput ed # restore cursor position && clear to the end of display
	    echo  "Trying to slip away unseen.."
	    RollDice 6
	    if (( DICE <= FLEE )) ; then
		Echo "You managed to run away!" "[D6 $DICE <= Flee $FLEE ]"
		LUCK=3
		unset FIGHTMODE
	    else
		Echo "You lost your initiative.." "[D6 $DICE > Flee $FLEE]"
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
    printf "%-12.12s\t\tHEALTH: %s\tStrength: %s\tAccuracy: %s\n" "$(Capitalize "$CHAR")" "$CHAR_HEALTH" "$STRENGTH" "$ACCURACY"
    printf "%-12.12s\t\tHEALTH: %s\tStrength: %s\tAccuracy: %s\n\n" "$(Capitalize "$ENEMY")" "$EN_HEALTH" "$EN_STRENGTH" "$EN_ACCURACY"
}

# #-----------------------------------------------------------------------
# # FightMode_FightFormula()
# # Display Formula in Fighting
# # Arguments: $DICE_SIZE(int), $FORMULA(string), $SKILLABBREV(string)
# #-----------------------------------------------------------------------
# FightMode_FightFormula() {
#     local DICE_SIZE="$1" FORMULA="$2" SKILLABBREV="$3"
#     (( DICE_SIZE <= 9 )) && DICE_SIZE+=" "
#     case "$FORMULA" in
# 	eq )    FORMULA="= " ;;
# 	gt )    FORMULA="> " ;;
# 	lt )    FORMULA="< " ;;
# 	ge )    FORMULA=">=" ;;
# 	le )    FORMULA="<=" ;;
# 	times ) FORMULA="x " ;;
#     esac
#     echo -n "Roll D${DICE_SIZE} $FORMULA $SKILLABBREV ( " # skill & roll
#     # The actual symbol in $DICE vs eg $CHAR_ACCURACY is already
#     # determined in the if and cases of the Fight Loop, so don't repeat here.
# }

FightMode_CharTurn() {
    local FIGHT_PROMPT
    echo -n "It's your turn, press any key to (R)oll or (F) to Flee"
    FIGHT_PROMPT=$(Read)
    RollDice 6
    FightMode_FightTable
    case "$FIGHT_PROMPT" in
	[fF] ) # Player tries to flee!
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
	* ) # Player fights
	    if (( DICE <= ACCURACY )); then
		Echo "Your weapon hits the target!" "[D6 $DICE <= Accuracy $ACCURACY]"
		echo -en "\nPress the R key to (R)oll for damage"
		FIGHT_PROMPT=$(Read)
		RollDice 6
		local DAMAGE=$(( DICE * STRENGTH ))
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
    if (( EN_HEALTH < EN_FLEE_THRESHOLD && EN_HEALTH < CHAR_HEALTH )); then # Enemy tries to flee
	echo -e "${CLEAR_LINE}$(Capitalize "$ENEMY") tries to flee the battle:"
	Sleep 2
	RollDice 20
	if (( DICE < EN_FLEE )); then
	    Echo "The $ENEMY uses an opportunity to flee!" "[D20 $DICE < EnemyFlee $EN_FLEE]"
	    if [[ "$DEBUG" ]] ; then
		if (( $(RollDice2 20) == 20 )) ; then
		    Sleep 2
		    echo -e "\nBut stumbles and falls!!!"  #language
		    return 0 	# Change to player's turn without enemy's
		fi
	    fi
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
	Echo "${CLEAR_LINE}The $ENEMY misses!" "[D6 $DICE > EnemyAccuracy $EN_ACCURACY]"
    fi
}

FightMode_CheckForDeath() {
    if ((CHAR_HEALTH <= 0)); then # If player is dead
	FightMode_FightTable
	echo "Your health points are $CHAR_HEALTH"
	Sleep 2
	echo "You WERE KILLED by the $ENEMY, and now you are dead..."
	Sleep 2
	if ((CHAR_EXP >= 1000 && CHAR_HEALTH > -15)); then
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
	    Echo "The $ENEMY fleed from you!" "[+${EN_EXP} EXP]" ;;
	2)  # PLAYER died but saved by guardian angel or 1000 EXP
	    echo "When you come to, the $ENEMY has left the area ..." ;;
	3)  # PLAYER managed to FLEE during fight! (1/4 $EN_EXP)
	    EN_EXP=$((EN_EXP / 4))
	    Echo "You got away while the $ENEMY wasn't looking!" "[+${EN_EXP} EXP]" ;;
	*)  # ENEMY was slain!
	    Echo "You defeated the $ENEMY!" "[+${EN_EXP} EXP]"
	    ((CHAR_KILLS++))
    esac
    (($1 != 2 )) && ((CHAR_EXP += EN_EXP)) # Add EXP if player didn't fleed
    ((CHAR_BATTLES++))		           # At any case increase CHAR_BATTLES
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
	    Echo " and gained experience for successfully pickpocketing!" "[+${EN_PICKPOCKET_EXP} EXP]";;
	2)  # no loot but EXP
	    echo -e "\nIn the pouch lifted from the ${ENEMY}, you find nothing of value.." ;
	    Echo ".. but you gained experience for successfully pickpocketing!" "[+${EN_PICKPOCKET_EXP} EXP]";;
    esac
    (($1 != 0 )) && ((CHAR_EXP += EN_PICKPOCKET_EXP)) # Add EXP if there was pickpocketing
}

#-----------------------------------------------------------------------
# FightMode_CheckForLoot()
# Check which loot player will take from this enemy
# TODO: check for boar's tusks etc (3.0)
#-----------------------------------------------------------------------
FightMode_CheckForLoot() {
    if ((LUCK == 0)); then                       # Only if $ENEMY was slain
	if (( $(bc <<< "$EN_FOOD > 0") )); then	 #  and have some FOOD
	    Echo "\nYou scavenge ${EN_FOOD} food from the ${ENEMY}'s body" "[+${EN_FOOD} FOOD]"
	    CHAR_FOOD=$(bc <<< "$CHAR_FOOD + $EN_FOOD")
	fi
    fi
}

#-----------------------------------------------------------------------
# FightMode()
# Main fight loop.
# Used: CheckForFight().
#-----------------------------------------------------------------------
FightMode() {
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
