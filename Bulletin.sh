########################################################################
#                             GX_Bulletin                              #
#                                                                      #



## WORLD EVENT functions

WorldPriceFixing() { # Used in WorldChangeEconomy() and Intro()
    local VAL_FOOD=1 # Why constant? Player eats .25/day, so it's always true that 1 FOOD = 4 turns.
    # Warning! Old-style echo used on purpose here. Otherwise bc gives "illegal char" due to \n CRs 
    # O_o. Are you sure that all is right with your encoding settings? #kstn
    PRICE_FxG=$( echo "scale=2;$VAL_FOOD/$VAL_GOLD" | bc )
    PRICE_FxT=$( echo "scale=2;$VAL_FOOD/$VAL_TOBACCO" | bc ) # Price of 1 Food in Tobacco
    PRICE_GxT=$( echo "scale=2;$VAL_GOLD/$VAL_TOBACCO" | bc )
    PRICE_GxF=$( echo "scale=2;$VAL_GOLD/$VAL_FOOD" | bc )    # Price of 1 Gold in Food
    PRICE_TxG=$( echo "scale=2;$VAL_TOBACCO/$VAL_GOLD" | bc )
    PRICE_TxF=$( echo "scale=2;$VAL_TOBACCO/$VAL_FOOD" | bc )
    # Items are arbitrarily priced & not set here, but the same logic IxG applies.
}

#-----------------------------------------------------------------------
# CheckForWorldChangeEconomy()
# Used: NewSector()
#-----------------------------------------------------------------------
CheckForWorldChangeEconomy() {  
    (( --WORLDCHANGE_COUNTDOWN > 0 )) && return 0 # Decrease $WORLDCHANGE_COUNTDOWN then check for change
    (( $(RollDice2 100) > 15 )) && return 0       # Roll to 15% chance for economic event transpiring or leave immediately
    BBSMSG=$(RollDice2 "$MAX_BBSMSG")             # = Number of possible scenarios (+ default 0) and Update BBSMSG
    
    case "$BBSMSG" in
    	# Econ '+'=Inflation, '-'=deflation | 1=Tobacco, 2=Gold | Severity 12=worst (0.25-3.00 change), 5=lesser (0.25-1.25 change)
    	1 )  local CHANGE="+"; local UNIT="Tobacco" ; RollDice 12 ;; # Wild Fire Threatens Tobacco (serious inflation)
    	2 )  local CHANGE="+"; local UNIT="Tobacco" ; RollDice 5  ;; # Hobbits on Strike (lesser inflation)
    	3 )  local CHANGE="-"; local UNIT="Tobacco" ; RollDice 12 ;; # Tobacco Overproduction (serious deflation)
    	4 )  local CHANGE="-"; local UNIT="Tobacco" ; RollDice 5  ;; # Tobacco Import Increase (lesser deflation)
    	5 )  local CHANGE="+"; local UNIT="Gold"    ; RollDice 12 ;; # Gold Demand Increases due to War (serious inflation)
    	6 )  local CHANGE="+"; local UNIT="Gold"    ; RollDice 5  ;; # Gold Required for New Fashion (lesser inflation)
    	7 )  local CHANGE="-"; local UNIT="Gold"    ; RollDice 12 ;; # New Promising Gold Vein (serious deflation)
    	8 )  local CHANGE="-"; local UNIT="Gold"    ; RollDice 5  ;; # Discovery of Artificial Gold Prices (lesser deflation)
    	9 )  local CHANGE="-"; local UNIT="Gold"    ; RollDice 4  ;; # Alchemists promise gold (lesser deflation)
    	10 ) local CHANGE="+"; local UNIT="Tobacco" ; RollDice 4  ;; # Water pipe fashion (lesser inflation)
    	11 ) local CHANGE="+"; local UNIT="Gold"    ; RollDice 10 ;; # King Bought Tracts of Land (serious inflation)
    	12 ) local CHANGE="-"; local UNIT="Tobacco" ; RollDice 10 ;; # Rumor of Tobacco Pestilence false (serious deflation)
    esac

    case "$UNIT" in # Which market is affected?
	"Tobacco" ) # How is tobacco affected and restrict to 0.25 min
	    VAL_TOBACCO=$( bc <<< "var = $VAL_TOBACCO $CHANGE ($DICE * $VAL_CHANGE); if (var <= 0) 0.25 else var" ) ;; 
	"Gold"    ) # How is gold affected and restrict to 0.25 min 
	    VAL_GOLD=$( bc <<< "var = $VAL_GOLD $CHANGE ($DICE * $VAL_CHANGE); if (var <= 0) 0.25 else var" ) ;;       
	* ) Die "BUG in WorldChangeEconomy() with unit >>>${UNIT}<<< and scenario >>>${DICE}<<<" ;;
    esac
    WORLDCHANGE_COUNTDOWN=20 # Give the player a 20 turn break TODO Test how this works..
    SaveCurrentSheet         # Save world changes to charsheet # LAST!!!
    WorldPriceFixing         # Update all prices    
} # Return to NewSector()

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
    # Create strings for economical situation..
    VAL_GOLD_STR=$( awk '{ printf "%4.2f", $0 }' <<< $VAL_GOLD )       # Usual printf is locale-depended - it cant work with '.' as delimiter when
    VAL_TOBACCO_STR=$( awk '{ printf "%4.2f", $0 }' <<< $VAL_TOBACCO ) #  locale's delimiter is ',' (cyrillic locale for instance) #kstn
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
} # End of GX_Bulletin()

#                                                                      #
#                                                                      #
########################################################################

