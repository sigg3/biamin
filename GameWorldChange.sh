########################################################################
#                             GX_Bulletin                              #
#                                                                      #

## WORLD EVENT functions

# IDEA Weather functions really presume that the map is 18x15,
# But if we have a grid-system for WorldMap with 0-0 being "home map"
# this can more easily be coded. E.g. HOME C2 is 0C-02
# while a house (Home) != $HOME in map east of default is 1C-02.
# The preceeding INT is an X and Y for the greater map sections.

#-----------------------------------------------------------------------
# WorldWeatherSystem()
# Used: nowhere, until 3.0    THIS IS STILL JUST A SKETCH
# The complete system takes up 9% of the world map. That's pretty big.
#-----------------------------------------------------------------------

WorldWeatherSystem() {
    # WEATHER SYSTEM CORE
    local WS_CORE_X WS_CORE_Y MOVE_STORM_CORE CORE_SEVERITY CORE_SEVERITY_MODIFIER
    if [ -z "$WEATHER" ] ; then # Create weather system
	declare -a WEATHER
	while true ; do
	    WS_CORE_X=$(RollDice2 18) # X Pos
	    WS_CORE_Y=$(RollDice2 15) # Y Pos
	    WEATHER[0]=$(XYtoGPS "$WS_CORE_X" "$WS_CORE_Y")
	    [[ "${WEATHER[0]}" != "$CHAR_GPS" ]] && break
	done
	WEATHER[1]=$(RollDice2 18) # Storm severity (Beaufort scale, >8 ~ storm)
    else  # Move existing weather system
	read -r WS_CORE_X WS_CORE_Y <<< $(GPStoXY "${WEATHER[0]}") # Fixes LOCATION
	MOVE_STORM_CORE=$( RollDice2 5) # Storm can move in 4 directions + stay put
	case "$MOVE_STORM_CORE" in
	    1 ) (( WS_CORE_X++ )) ;; # Moving North
	    2 ) (( WS_CORE_X-- )) ;; # Moving South
	    3 ) (( WS_CORE_Y++ )) ;; # Moving East
	    4 ) (( WS_CORE_Y-- )) ;; # Moving West
	    # 5 ) Storm stays put ;;
	esac
	WEATHER[0]=$(XYtoGPS "$WS_CORE_X" "$WS_CORE_Y") # Save back as Mapnav location
	RollDice 10
	if (( DICE <= 5 )) && [[ ${WEATHER[1]} -le 17 ]] ; then
	    WEATHER[1]=$[[ ${WEATHER[1]} + 1 ]] # Storm increases
	elif (( DICE >= 6 )) && [[ ${WEATHER[1]} -ge 2 ]] ; then
	    WEATHER[1]=$[[ ${WEATHER[1]} - 1 ]] # Storm decreases
	fi
    fi
    
    # Global adjust weather strength according to calendar (and pressure mean)
    case "$MONTH" in
    0 | 1 | 1[1-2] ) CORE_SEVERITY_MODIFIER=-2 ;; # Winter = high pressure, less storms (but cold)
    2 | 3 | 4 )      CORE_SEVERITY_MODIFIER=1  ;; # Spring = low pressure, more storms (warmer)
    5 | 6 | 7 )      CORE_SEVERITY_MODIFIER=0  ;; # Summer = high pressure, less storms (but very warm)
    8 | 9 | 10 )     CORE_SEVERITY_MODIFIER=2  ;; # Autumn = low pressure, more storms (warm)
    esac
	CORE_SEVERITY=${WEATHER[1]}
    CORE_SEVERITY=$( bc <<< "$CORE_SEVERITY + $CORE_SEVERITY_MODIFIER" )
	(( CORE_SEVERITY > 18 )) && CORE_SEVERITY=18
	(( CORE_SEVERITY < 1  )) && CORE_SEVERITY=1
    WEATHER[1]=$CORE_SEVERITY

    # Additional conditions for core
    WorldWeatherSystemHumidity 1 2


    if [ -z "$MOVE_STORM_CORE" ] || [ "$MOVE_STORM_CORE" <= 4 ] ; then
	# WEATHER SYSTEM NEXUS (12 storm tentacles)
	# 	WEATHER[0,3,6,9....60] == Affected GPS locations
	# 	WEATHER[1,4,7,10...61] == Weather severity at locations
	# 	WEATHER[2,5,8,11...62] == Humidity at locations

	# Weather system illustrated as placed on map with all fields filled in
	#                               LEGEND        TYPE                            STRENGTH
	#    36 | 51 | 54 | 15 | 27     0           = core                          = random
	#   ------------------------    3,6,9,12    = child N,S,E,W                 = core  -1 OR core
	#    24 | 39 |  3 | 42 |        15,18,21,24 = grandchild N,S,E,W            = child -1 OR child
	#   ------------------------    27,30,33,36 = greatgrandchild N,S,E,W       = grandchild -1 OR grandchild
	#       | 12 |  0 |  9 |        39,42,45,48 = inner turbulence NW,NE,SW,SE  = core  -1
	#   ------------------------    51,54,57,60 = outer turbulence NW,N,S,SE    = core  -3
	#       | 45 |  6 | 48 | 21
	#   ------------------------
	#    30 | 18 | 57 | 60 | 33

	# WEATHER SYSTEM CHILDREN
	local WS_PARENT_X WS_PARENT_Y WS_CHILD_X WS_CHILD_Y # For GPS calculations
	local WS_CHILD_SEVERITY WS_CHILD_HUMIDITY WS_PARENT_SEVERITY WS_TURBULENCE=0 # Severity, humidity, severity, turbulence boolean
	local WS_CHILD_COUNTER=20       # Total number of cells
	local WS_CHILD_COUNTER_INDEX=3  # Starting array number of first child to core
	while (( WS_CHILD_COUNTER >=1 )) ; do
	    read -r WS_PARENT_X WS_PARENT_Y <<< $(GPStoXY "${WEATHER[0]}")                 # Center of storm
	    case "$WS_CHILD_COUNTER_INDEX" in
		3 )  WS_CHILD_X=$WS_PARENT_X           && WS_CHILD_Y=$(( WS_PARENT_Y + 1 )) ;; # Northern child
		6 )  WS_CHILD_X=$WS_PARENT_X           && WS_CHILD_Y=$(( WS_PARENT_Y - 1 )) ;; # Southern child
		9 )  WS_CHILD_X=$(( WS_PARENT_X + 1 )) && WS_CHILD_Y=$WS_PARENT_Y           ;; # Eastern  child
		12 ) WS_CHILD_X=$(( WS_PARENT_X - 1 )) && WS_CHILD_Y=$WS_PARENT_Y           ;; # Western  child
		15 ) WS_CHILD_X=$(( WS_PARENT_X + 1 )) && WS_CHILD_Y=$(( WS_PARENT_Y + 2 )) ;; # Northern grandchild
		18 ) WS_CHILD_X=$(( WS_PARENT_X - 1 )) && WS_CHILD_Y=$(( WS_PARENT_Y - 2 )) ;; # Southern grandchild
		21 ) WS_CHILD_X=$(( WS_PARENT_X + 2 )) && WS_CHILD_Y=$(( WS_PARENT_Y - 1 )) ;; # Eastern  grandchild
		24 ) WS_CHILD_X=$(( WS_PARENT_X - 2 )) && WS_CHILD_Y=$(( WS_PARENT_Y + 1 )) ;; # Western  grandchild
		27 ) WS_CHILD_X=$(( WS_PARENT_X + 2 )) && WS_CHILD_Y=$(( WS_PARENT_Y + 2 )) ;; # Northern greatgrandchild
		30 ) WS_CHILD_X=$(( WS_PARENT_X - 2 )) && WS_CHILD_Y=$(( WS_PARENT_Y - 2 )) ;; # Southern greatgrandchild
		33 ) WS_CHILD_X=$(( WS_PARENT_X + 2 )) && WS_CHILD_Y=$(( WS_PARENT_Y - 2 )) ;; # Eastern  greatgrandchild
		36 ) WS_CHILD_X=$(( WS_PARENT_X - 2 )) && WS_CHILD_Y=$(( WS_PARENT_Y + 2 )) ;; # Western  greatgrandchild
		39 ) WS_CHILD_X=$(( WS_PARENT_X - 1 )) && WS_CHILD_Y=$(( WS_PARENT_Y + 1 )) ;; # Inner turbulence field 1
		42 ) WS_CHILD_X=$(( WS_PARENT_X + 1 )) && WS_CHILD_Y=$(( WS_PARENT_Y + 1 )) ;; # Inner turbulence field 2
		45 ) WS_CHILD_X=$(( WS_PARENT_X - 1 )) && WS_CHILD_Y=$(( WS_PARENT_Y - 1 )) ;; # Inner turbulence field 3
		48 ) WS_CHILD_X=$(( WS_PARENT_X + 1 )) && WS_CHILD_Y=$(( WS_PARENT_Y - 1 )) ;; # Inner turbulence field 4
		51 ) WS_CHILD_X=$(( WS_PARENT_X - 1 )) && WS_CHILD_Y=$(( WS_PARENT_Y + 2 )) ;; # Outer turbulence field 1
		54 ) WS_CHILD_X=$WS_PARENT_X           && WS_CHILD_Y=$(( WS_PARENT_Y + 2 )) ;; # Outer turbulence field 2
		57 ) WS_CHILD_X=$WS_PARENT_X           && WS_CHILD_Y=$(( WS_PARENT_Y - 2 )) ;; # Outer turbulence field 3
		60 ) WS_CHILD_X=$(( WS_PARENT_X + 1 )) && WS_CHILD_Y=$(( WS_PARENT_Y - 2 )) ;; # Outer turbulence field 4
	    esac
	    # 1. GPS location
	    WEATHER[$WS_CHILD_COUNTER_INDEX]=$(XYtoGPS "$WS_CHILD_X" "$WS_CHILD_Y" )
	    (( WS_CHILD_COUNTER_INDEX++ )) # Increment to next array item
	    # 2. Severity
	    case "$WS_CHILD_COUNTER_INDEX" in
		4 | 7 | 10 | 13 )   WS_PARENT=1 && WS_TURBULENCE=0                     ;; # Use core's severity as base
		40 | 43 | 46 | 49 | 52 | 55 | 58 | 61 ) WS_PARENT=1 && WS_TURBULENCE=1 ;; # Use core's severity as base
		* ) WS_PARENT=$[[ $WS_PARENT + 3 ]] && WS_TURBULENCE=0                 ;; # Use parent's severity
	    esac
	    WS_PARENT_SEVERITY=$WS_PARENT
	    if (( WS_TURBULENCE == 1 )) ; then
	    case "$WS_CHILD_COUNTER_INDEX" in
		40 | 43 | 46 | 49 ) WEATHER[$WS_CHILD_COUNTER_INDEX]=$[[ ${WEATHER[$WS_PARENT_SEVERITY]} - 1 ]] ;; # core's severity -1 (inner turbulence field)
		52 | 55 | 58 | 61 ) WEATHER[$WS_CHILD_COUNTER_INDEX]=$[[ ${WEATHER[$WS_PARENT_SEVERITY]} - 3 ]] ;; # core's severity -3 (outer turbulence field)
		esac
	    else
	    (( WEATHER[$WS_PARENT_SEVERITY] >= 8 )) && WEATHER[$WS_CHILD_COUNTER_INDEX]=$[[ ${WEATHER[$WS_PARENT_SEVERITY]} - 1 ]] || WEATHER[$WS_CHILD_COUNTER_INDEX]=${WEATHER[$WS_PARENT_SEVERITY]}
		fi
	    # 3. Humidity
	    WS_CHILD_SEVERITY=${WEATHER[$WS_CHILD_COUNTER_INDEX]} # Tmp var 1 for humidity
	    (( WS_CHILD_COUNTER_INDEX++ )) # Increment to next array item
	    WS_CHILD_HUMIDITY=${WEATHER[$WS_CHILD_COUNTER_INDEX]} # Tmp var 2 for humidity
	    WorldWeatherSystemHumidity $WS_CHILD_SEVERITY $WS_CHILD_HUMIDITY # Function saves humidity
	    (( WS_CHILD_COUNTER_INDEX++ )) && (( WS_CHILD_COUNTER-- ))
	done
	
	# TODO simplify the one above to use WEATHER+=( "$NEW_VAL_1" "$NEW_VAL_2" "$NEW_VAL_3")
	# REWRITE to allow HUMIDITY. This is interpreted relative to seasons. Strength is necessarily connected to seasons.
	# HUMIDITY INT (1-4) : dry, humid, rainy, downpour or dry, humid, snowy, snow storm etc.
	# Belongs in WEATHER array.
	# Re: season-related: Months with high pressure, less aggressive weather and vice versa.
	
	# TODO possible simplification:
	# This could make all the number stuff irrelevant:) just add to array WEATHER=("${WEATHER[@]}" "$(XYtoGPS "$WS_CHILD_X" "$WS_CHILD_Y")" ...
	#
	# Add an element to an existing Bash Array
	# The following example shows the way to add an element to the existing array.
    #
    # cat arraymanip.sh
    # Unix=('Debian' 'Red hat' 'Ubuntu' 'Suse' 'Fedora' 'UTS' 'OpenLinux');
    # Unix=("${Unix[@]}" "AIX" "HP-UX")
    # echo ${Unix[7]}
    # $./arraymanip.sh
    # AIX
	#
	# In the array called Unix, the elements ‘AIX’ and ‘HP-UX’ are added in 7th and 8th index respectively

	# WEATHER AFFECTED AREAS (viz. Hotzone array for weather to be checked in world map turns)
	declare -a WEATHER_AFFECTED
	local WEATHER_SYSTEMS=0
	while (( WEATHER_SYSTEMS <= 60 )) ; do
		WEATHER_AFFECTED[$WEATHER_SYSTEMS]="${WEATHER[$WEATHER_SYSTEMS]}"
		WEATHER_SYSTEMS=$[[ $WEATHER_SYSTEMS + 3 ]]	
	done
    fi
}

#-----------------------------------------------------------------------
# WorldWeatherSystemHumidity()
# Used: WorldWeatherSystem()
# Args: INT System severity & INT System humidity (required)
#-----------------------------------------------------------------------
WorldWeatherSystemHumidity() {
    case "${WEATHER[$1]}" in
	8 | 9 | 1[0-8] ) WEATHER[$2]=$(RollDice2 3) ;; # See WorldWeatherReport() for values
	1 | 2 | 3 | 4  ) WEATHER[$2]=0              ;; # Fine weather
	* )              WEATHER[$2]=1              ;; # Viz. rain
    esac
}

#-----------------------------------------------------------------------
# CheckWeatherForecast()
# Looks at $1 (GPS string) to determine what the weather's like there
# Returns 0 for affected and 1 for unaffected
#-----------------------------------------------------------------------
CheckWeatherForecast() {
    [[ "$1" = "${WEATHER_AFFECTED[@]}" ]] && return 0 || return 1
}

#-----------------------------------------------------------------------
# CheckForWeatherDamage()
# HP damage to CHAR_HEALTH in severe weather
#
# TODO
#-----------------------------------------------------------------------


#-----------------------------------------------------------------------
# WorldWeatherReport()
# Creates a weather report string for CHAR_GPS
# Args: INT System severity & INT System humidity
#-----------------------------------------------------------------------
WorldWeatherReport() {
    if (( $(CheckWeatherForecast $CHAR_GPS) == 0 )) ; then
	local WEATHER_SYSTEM_ID=0 	# Get system "ID"
	while true ; do
	    [[ "$CHAR_GPS" = "${WEATHER_AFFECTED[$WEATHER_SYSTEM_ID]} " ]] && break
	    (( WEATHER_SYSTEM_ID++ ))
	done
	local WEATHER_SYSTEM_SEVERITY=$[[ $WEATHER_SYSTEM_ID + 1 ]]
	local WEATHER_SYSTEM_HUMIDITY=$[[ $WEATHER_SYSTEM_ID + 2 ]]

	# Core severity string (Beaufort scale)
	case "${WEATHER[$WEATHER_SYSTEM_SEVERITY]}" in
	    1 )  WEATHER_REPORT="Calm"            ;;
	    2 )  WEATHER_REPORT="Light air"       ;;
	    3 )  WEATHER_REPORT="Light breeze"    ;;
	    4 )  WEATHER_REPORT="Gentle breeze"   ;;
	    5 )  WEATHER_REPORT="Moderate breeze" ;;
	    6 )  WEATHER_REPORT="Fresh breeze"    ;;
	    7 )  WEATHER_REPORT="Strong breeze"   ;;
	    8 )  WEATHER_REPORT="Moderate gale"   ;;
	    9 )  WEATHER_REPORT="Fresh gale"      ;;
	    10 ) WEATHER_REPORT="Whole gale"      ;;
	    11 ) WEATHER_REPORT="Storm"           ;;
	    12 | 13 | 14 | 15 | 16 | 17 | 18 ) WEATHER_REPORT="Hurricane" ;;
	esac

	# Core Humidity conditions
	case "${WEATHER[$WEATHER_SYSTEM_HUMIDITY]}" in
	    0 ) WEATHER_REPORT+=" and dry"   ;;
	    1 ) WEATHER_REPORT+=" and rainy" ;;
	    2 ) WEATHER_REPORT+=" and snowy" ;;
	    3 ) WEATHER_REPORT+=" and hail"  ;;
	esac
    else
	WEATHER_REPORT="Nice weather conditions"
    fi
}

#-----------------------------------------------------------------------
# WorldPriceFixing()
# Used: WorldChangeEconomy(), Intro()
#-----------------------------------------------------------------------
WorldPriceFixing() {
    local VAL_FOOD=1 # Why constant? Player eats .25/day, so it's always true that 1 FOOD = 4 turns.
    PRICE_FxG=$(bc <<< "scale=2; $VAL_FOOD / $VAL_GOLD")
    PRICE_FxT=$(bc <<< "scale=2; $VAL_FOOD / $VAL_TOBACCO") # Price of 1 Food in Tobacco
    PRICE_GxT=$(bc <<< "scale=2; $VAL_GOLD / $VAL_TOBACCO")
    PRICE_GxF=$(bc <<< "scale=2; $VAL_GOLD / $VAL_FOOD")    # Price of 1 Gold in Food
    PRICE_TxG=$(bc <<< "scale=2; $VAL_TOBACCO / $VAL_GOLD")
    PRICE_TxF=$(bc <<< "scale=2; $VAL_TOBACCO / $VAL_FOOD")
    # Items are arbitrarily priced & not set here, but the same logic IxG applies.
}

#-----------------------------------------------------------------------
# CheckForWorldChangeEconomy()
# Used: NewSector()
#-----------------------------------------------------------------------
CheckForWorldChangeEconomy() {
    # Check for change economy
    (( --WORLDCHANGE_COUNTDOWN > 0 )) && return 0                              # Decrease $WORLDCHANGE_COUNTDOWN then check for change
    (( $(RollDice2 100) > 15 ))       && return 0                              # Roll to 15% chance for economic event transpiring or leave immediately
    # Define scenario
    BBSMSG=$(RollDice2 "$MAX_BBSMSG")                                          # Roll for random scenarion (exlude default scenario 0)
    case "$BBSMSG" in
    	# CHANGE : '+'=Inflation, '-'=deflation | Severity:  12=worst (0.25-3.00 change), 5=lesser (0.25-1.25 change)
    	1 )  local CHANGE="+"; declare -n CURRENCY=VAL_TOBACCO ; RollDice 12 ;; # Wild Fire Threatens Tobacco (serious inflation)
    	2 )  local CHANGE="+"; declare -n CURRENCY=VAL_TOBACCO ; RollDice 5  ;; # Hobbits on Strike (lesser inflation)
    	3 )  local CHANGE="-"; declare -n CURRENCY=VAL_TOBACCO ; RollDice 12 ;; # Tobacco Overproduction (serious deflation)
    	4 )  local CHANGE="-"; declare -n CURRENCY=VAL_TOBACCO ; RollDice 5  ;; # Tobacco Import Increase (lesser deflation)
    	5 )  local CHANGE="+"; declare -n CURRENCY=VAL_GOLD    ; RollDice 12 ;; # Gold Demand Increases due to War (serious inflation)
    	6 )  local CHANGE="+"; declare -n CURRENCY=VAL_GOLD    ; RollDice 5  ;; # Gold Required for New Fashion (lesser inflation)
    	7 )  local CHANGE="-"; declare -n CURRENCY=VAL_GOLD    ; RollDice 12 ;; # New Promising Gold Vein (serious deflation)
    	8 )  local CHANGE="-"; declare -n CURRENCY=VAL_GOLD    ; RollDice 5  ;; # Discovery of Artificial Gold Prices (lesser deflation)
    	9 )  local CHANGE="-"; declare -n CURRENCY=VAL_GOLD    ; RollDice 4  ;; # Alchemists promise gold (lesser deflation)
    	10 ) local CHANGE="+"; declare -n CURRENCY=VAL_TOBACCO ; RollDice 4  ;; # Water pipe fashion (lesser inflation)
    	11 ) local CHANGE="+"; declare -n CURRENCY=VAL_GOLD    ; RollDice 10 ;; # King Bought Tracts of Land (serious inflation)
    	12 ) local CHANGE="-"; declare -n CURRENCY=VAL_TOBACCO ; RollDice 10 ;; # Rumor of Tobacco Pestilence false (serious deflation)
    esac
                                                                                # Change currency and restrict to 0.25 min
    CURRENCY=$( bc <<< "var = ${CURRENCY} ${CHANGE} (${DICE} * ${VAL_CHANGE}); if (var <= 0) 0.25 else var" )
    unset -n CURRENCY                                                           # Unset REFERENCE
    WORLDCHANGE_COUNTDOWN=20                                                    # Give the player a 20 turn break TODO Test how this works..
    SaveCurrentSheet                                                            # Save world changes to charsheet # LAST!!!
    WorldPriceFixing                                                            # Update all prices
}

# Other WorldChangeFUNCTIONs go here:)

#-----------------------------------------------------------------------
# $MAX_BBS_MSG - total count of available BBSMSG (exclude ${BBSMSG[0]})
# Used: CheckForWorldChangeEconomy();
#-----------------------------------------------------------------------
MAX_BBSMSG=12

#-----------------------------------------------------------------------
# GX_Bulletin()
# Display custom message (BBSMSG)
# Arguments: $BBSMSG (int)
#-----------------------------------------------------------------------
GX_Bulletin() {
    # Firstly: create strings for economical situation... (for faster drawing afterwards)
    local VAL_GOLD_STR=$( awk '{ printf "%4.2f", $0 }' <<< $VAL_GOLD )       # Usual printf is locale-depended - it cant work with '.' as delimiter when
    local VAL_TOBACCO_STR=$( awk '{ printf "%4.2f", $0 }' <<< $VAL_TOBACCO ) #  locale's delimiter is ',' (cyrillic locale for instance) #kstn
    case $1 in # MAX 35 chars per line !!!
	1 ) # Wild Fire Threatens Tobacco (serious)
	    local BULLETIN=(
		"WILD FIRE THREATENS TOBACCO SUPPLY! "
		"Many Travellers have told of Wild   "
		"Forest Fires that may threaten the  "
		"steady Supply of Tobacco to the     "
		"Markets of the Realm. Rumours say   "
		"Harvest in Jeopardy & prices soar!  " ) ;;
	2 ) # Hobbits on Strike
	    local BULLETIN=(
		"       TOBACCO TOO CHEAP!           "
		"Traders Beware! Since last Harvest  "
		"many Halflings of great Repute have "
		"returned to Other Produce than Leaf "
		"Villages report malcontent of low   "
		"Tobacco Prices, refusing to sell.   ") ;;
	3 ) # Tobacco Overproduction (serious)
	    local BULLETIN=(
		" GREATEST TOBACCO HARVEST IN AGES!  "
		"Our Harvest may well prove to be ye "
		"Most Abundant in many Cycles, and   "
		"Hobbit Masters of Several Good Towns"
		"report with Joye an Increase in     "
		"Produce.           - The Hobbits    ") ;;
	4 ) # Tobacco Import Increases
	    local BULLETIN=(
		"     ROYALE IMPORT OF TOBACCOS      "
		"Facing a National Tobacco Famine ye "
		"King orders large-scale Leaf Import "
		"to satisfy His subjects. Several    "
		"Honorable Traders have volunteered  "
		"to Aide in the Import of Tobacco    ") ;;
	5 ) # Gold Increases due to War (serious)
	    local BULLETIN=(
		"     KING DEMANDS GOLD FOR WAR      "
		"By Royal Decree, A Treaty with The  "
		"Kingdom of Kastian was Broken by ye "
		"attack on Royal Emissaries in Acte  "
		"of Shame. Our King requires Gold to "
		"Summon an Army and Go to War! ~{K}~ ") ;;
	6 ) # Gold Required for New Fashion
	    local BULLETIN=(
		"       GOLDEN FASHION SPREADS       "
		"The Rich Habits of ye Royal Court   "
		"spreads to the Kingdom's Nobility.  "
		"The Price of Gold heightens as the  "
		"Ladies of the Court dress in Gowns  "
		"made in the Finest of Gold Fabrics! ") ;;
	7 ) # Discovery of New Promising Gold Field (serious)
	    local BULLETIN=(
		"         GOLDE VEIN PROMISING       "
		"A new Vein of Gold discovered in ye "
		"Royal Gold Mines promises a Flood   "
		"of Golde to the Kingdom's Markets.  "
		"Dwarven Advisors to ye King Himself "
		"assure future Finds to be Great!    ") ;;
	8 ) # Discovery of Artificial Gold Prices (them Dwarves!)
	    local BULLETIN=(
		"   GOLD PRICE MAY BE ARTEFICIAL     "
		"A Gentleman in The King's Court has "
		"reveal'd ye Price of Gold strangely "
		"Highe, as a Result of fraudelent    "
		"Reports by Dwarven Mines. Ye Dwarfs "
		"remain quiet about such Speculation ") ;;
	9 ) # Rumors of alchemy success
	    local BULLETIN=(
		"      ALCHEMISTS PROMISE GOLD       "
		"  Zosimos ye Alchemist recently     "
		"baffl'd the Royal Court proclaiming "
		"Endeavours to create Gold would be  "
		"sucessful by Year's End. Dwarven    "
		"Sceptical about Artificial Golde.   ") ;;
	10 ) # Water Pipe Fashion
	    local BULLETIN=(
		"    WATER PUFFING MORE HEALTHY      "
		"Ye Eastern Watr Pipes for Tobaccos  "
		"of Different Flavors Altogether are "
		"sayd to be Ailing for Sore Throats, "
		"Restoring Health. The Royale Courts "
		"report Increase in Strawberry Tabac ") ;;
	11 ) # King Buying Tracts of land, gold inflate (serious)
	    local BULLETIN=(
		"    KING TO PURCHASE MORE LAND      "
		"By Royale Decree, to come to Our    "
		"Esteem'd Neighbourdom Clausthall's  "
		"Aid ye King hath decree'd to Buy    "
		"huge Tracts of Land from ye House   "
		"of Clausthaler. Gold demanded! ~{K}~") ;;
	12 ) # Tobacco pest proven to be false (serious)
	    local BULLETIN=(
		"   RUMORS OF TOBACCO PEST FALSE     "
		"Rumors of a Tobacco Pestilence that "
		"destroys Entire Crops of Tabac have "
		"proven false! Several Halfling Towns"
		"expect Increase in Production due   "
		"Favourable Weather and plenty Sun.  ") ;;
	* ) # Default story on the board (no economic changes here)
	    local BULLETIN=(
		"     WIZARD CRAVE DRAGON (DEAD)     "
		"An Honorable Wizard in Royal School "
		"of Magic and Astronomy, promises a  "
		"Rewarde to be pay'd in Golde for ye "
		"Delivery of a Dragon to ye Schoole, "
		"preferably deceased, for study.     ") ;;
    esac
    case $1 in # Add generic consequence string
	1 | 2 | 10 ) BULLETIN[6]="TOBACCO RAISED TO: $VAL_TOBACCO_STR" ;;
	3 | 4 | 12 ) BULLETIN[6]="TOBACCO LOWERED TO: $VAL_TOBACCO_STR" ;;
	5 | 6 | 11 ) BULLETIN[6]="GOLD RAISED TO: $VAL_GOLD_STR" ;;
	7 | 8 | 9  ) BULLETIN[6]="GOLD LOWERED TO: $VAL_GOLD_STR" ;;
	*          ) BULLETIN[6]="REWARD SET TO: 500 GOLD" ;;
    esac
    # Ok, let's draw !!!
    clear
    cat <<"EOT"
                 ___                                     ____
                (___) _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ (____)
                 | T-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-T ||
 ^^              | |                                     | ||
    ^^           | |                                     | ||   ____________
        ___      | |                                     | ||  /           /\
     _ (   )_    | |                                     | || /           /||\
   (  )      )   | |                                     | ||/___________/ ||_\
 (__   ) (  ) )  | |                                     | ||  ||          ||
(     __)  ___)  | |                                     | || _||__________||
 (_____)T^T      | |                                     | || 1 T  T  T  T  T!
   |^|  |^|      | l___________,____________,____________j || 1_ 1 _| __  1_ !
-  |^|  |^|     -| ||  -       &            &       -    | || 1   __  1  1  _1_
  '""" '"""'     | ||        ,-6------------6-.          | || 1  1  1  1   | `-'
  -           -  | ||       :   Y e  N e w s   :         | || '""'""'""""'"|___|
                 | ||       `-.................'         | || .       -
       -         1 ll         -                          1 ll               -
            -~'"'""""'""~-                       --~""'"'"""""'~-
EOT
    echo "$HR"
    tput sc # save cursor position
    local NUM=0
    for i in 3 5 6 7 8 9 10 ; do
	MvAddStr $i 21 "${BULLETIN[((NUM++))]}" # 3 - TITLE, 5-9 TEXT, 10 consequence string
    done
    tput rc # restore cursor position
    PressAnyKey
}

#                                                                      #
#                                                                      #
########################################################################

