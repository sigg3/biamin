########################################################################
#                                                                      #
#                        0. GFX FUNCTIONS                              #
#                All ASCII banner-functions go here!                   #

# Horizontal ruler used almost everywhere in the game
HR="- ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ "

PressAnyKey() { read -sn 1 -p "$(MakePrompt 'Press (A)ny key to continue..')" 2>&1; } # Centered "Press Any Key to continue" string

GX_BiaminTitle() { # Used in GX_Banner(), GX_Credits(), GX_HowTo(), CleanUp() and License() !
    clear
    cat <<"EOT"
            ______                                                     
          (, /    )       /)     ,                    ,               
            /---(  _   _ (/_      __     _     ___     __      _/_  _ 
         ) / ____)(_(_(__/(__  _(_/ (_  (_(_   // (__(_/ (_(_(_(___(/_
        (_/ (   
EOT
}  

GX_Banner() {
    GX_BiaminTitle
    cat <<"EOT"
                                                     ___________(  )_ 
                                                    /   \      (  )  \
                                                   /     \     |`|    \   
                                                  /   _   \      ~ ^~  \ ~ ^~  
                                                 /|  |.|  |\___ (     ) (     )
                                                  |  | |  |    ( (     ) (     )
                                             """"""";::;"""""""(    )  )    )  )
                                                  ,::;;.        (_____) (_____)
                                                 ,:;::;           | |     | |
                                               ;:;:;:;            | |     | |
                                            ,;;;;;;;,            """""  """"""

                    
          /a/ |s|i|m|p|l|e| /b/a/s/h/ |a|d|v|e|n|t|u|r|e| /g/a/m/e/

              Sigg3.net (C) 2014 CC BY-NC-SA 4.0 and GNU GPL v.3
EOT
    echo "$HR"
}



GX_Credits() {
    GX_BiaminTitle
    cat <<EOF 
          
   Back in a minute is an adventure game with 4 playable races, 6 enemies,
   8 items and 6 scenarios spread across the 270 sections of the world map.
   Biamin saves character sheets between sessions and keeps a highscore!
   The game supports custom maps too! See --help or --usage for information.

   Game directory: $GAMEDIR/

   This timekiller's written entirely in BASH. It was intended for sysadmins
   but please note that it isn't console-friendly and it looks best in 80x24
   terminal emulators (white on black). Make sure it's a window you can close.
      
   BASH code (C) Sigg3.net GNU GPL Version 3 2014
   ASCII art (C) Sigg3.net CC BY-NC-SA 4.0 2014 (except figlet banners)

   Visit the Back in a minute website at <$WEBURL>
   for updates, feedback and to report bugs. Thank you.
$HR
EOF
}

GX_HowTo() {
    GX_BiaminTitle
    cat <<EOF
    
                          HOW TO PLAY Back in a Minute

   Go to Main Menu and hit (P)lay and enter the NAME of the character you want
   to create or whose character sheet you want to load (case-sensitive).
   You enter the World of Back in a Minute. The first sector is Home.
   
   Each sector gives you these action alternatives:
   (C)haracter sheet: Toggle Character Sheet
   (R)est: Sleep to gain health points
   (M)ap and travel: Toggle Map to find yourself, items and to travel
   (Q)uit: Save current status and quit the world of Back in a Minute
   Use W, A, S, D keys to travel North, West, South or East directly.
      
   Travelling and resting involves the risk of being attacked by the creatures
   inhabiting the different scenarios. Some places are safer than others.
   For more information please visit <$WEBURL>
$HR
                    Press any key to return to (M)ain Menu
EOF
    read -sn 1
}

GX_HighScore() {
    clear
    cat <<"EOT"
         _________     _    _ _       _                            
        |o x o x o|   | |__| (_) __ _| |__  ___  ___ ___  _ __ ___ 
         \_*.*.*_/    |  __  | |/ _` | '_ \/ __|/ __/ _ \| '__/ _ \
           \-.-/      | |  | | | (_| | | | \__ \ (_| (_) | | |  __/
           _| |_      |_|  |_|_|\__, |_| |_|___/\___\___/|_|  \___|
          |_____|                |___/                              
                                       Y e   H a l l e   o f   F a m e
EOT
    echo "$HR"
}

GX_LoadGame() {
    clear
    cat << "EOT"
        ___________ 
       (__________()   _                    _    ____                      
       / ,,,,,,,  /   | |    ___   __ _  __| |  / ___| __ _ _ __ ___   ___ 
      / ,,,,,,,  /    | |   / _ \ / _` |/ _` | | |  _ / _` | '_ ` _ \ / _ \
     / ,,,,,,,  /     | |__| (_) | (_| | (_| | | |_| | (_| | | | | | |  __/
   _/________  /      |_____\___/ \__,_|\__,_|  \____|\__,_|_| |_| |_|\___|
  (__________(/ 
 

EOT
    echo "$HR"
}

GX_CharSheet() { # Optional arg: EMPTY/1 = CHARSHEET, 2 = ALMANAC
    [[ -z "$1" ]] && local DISP=1 || local DISP="$1"
    clear
    cat <<"EOT"
 
                               /T\                           /""""""""\ 
      o-+----------------------------------------------+-o  /  _ ++ _  \
        |/                                            \|   |  / \  / \  \
        |                                              |   | | , | |, | |
        |                                              |   | |   |_|  | |
        |\                                            /|    \|   ...; |; 
      o-+----------------------------------------------+-o    \______/

EOT
    tput sc
    if (( DISP == 1 )) ; then
	MvAddStr 4 11 "C  H  A  R  A  C  T  E  R     S  H E  E  T"
	MvAddStr 6 23 "s t a t i s t i c s"
    else
	MvAddStr 4 11 "         A   L   M   A   N   A   C"
    fi
    tput rc
}


GX_Death() {
    clear
    cat <<"EOT"

     
         __   _  _  _/_   ,  __
        / (__(/_/_)_(__  _(_/ (_    __    _  _   _   _                __ 
                                    /_)__(/_(_(_(___(/_              /\ \
                                 .-/                                /  \ \   
         YOU ARE A STIFF,       (_/           # #  # #  # # #      /  \/\ \  
         PUSHING UP THE DAISIES          # # #  # # # # # # #  #  /   /\ \_\ 
         YOU ARE IRREVOCABLY DEAD     # # # # # #  # # # # #  # # \  /   / / 
                                    # # # # # # # # # ## # # # # # \    / /     
         Better luck next time!   # # # # #  # # # # # # # # #  # # \  / /
                                 # # #  #  # # # # # # # # # # # # # \/_/
                                   # #  # # # # # # ## # # # # ## #


EOT
    echo "$HR"
}

GX_Intro() { # Used in Intro()
    clear
    cat <<"EOT"
                                                                         
       YOU WAKE UP TO A VAST AND UNFAMILIAR LANDSCAPE !                   
                                                                          
       Use the MAP to move around                                         
       REST to regain health points                                             
                                 ___                ^^                /\        
       HOME, TOWNS and the    __/___\__                   ^^         /~~\      
       CASTLE are safest       _(   )_                           /\ /    \  /\
                              /       \    1                  __/  \      \/  \
___                          (         \__ 1                _/             \   \
   \________                  \       L___| )           @ @ @ @ @@ @ @@ @
            \_______________   |     |     1     @ @ @ @@ @ @ @@ @ @ @ @ @@ @
                            \__|  |  |_____1____                    @ @ @@ @@ @@
                               |  |  |_    1    \___________________________  
                               |__| ___\   1                                \___
EOT
    echo "$HR" ## && PressAnyKey #BUGFIX
    echo "                        Press (A)ny key to continue.." 
    local COUNTDOWN=60
    while (( COUNTDOWN >= 0 )) ; do
    	read -sn 1 -t 1 && break || ((COUNTDOWN--))
    done
    unset COUNTDOWN
}

GX_Races() {
    clear
    cat <<EOF

                        C H A R A C T E R   R A C E S :

      1. MAN            2. ELF              3. DWARF            4. HOBBIT
 
   Healing:  3/6      Healing:  4/6       Healing:  2/6        Healing:  4/6   
   Strength: 3/6      Strength: 3/6       Strength: 5/6        Strength: 1/6
   Accuracy: 3/6      Accuracy: 4/6       Accuracy: 3/6        Accuracy: 4/6
   Flee:     3/6      Flee:     1/6       Flee:     2/6        Flee:     3/6
   
   
   Dice rolls on each turn. Accuracy also initiative. Healing during resting.
   Men and Dwarves start with more gold, Elves and Hobbits with more tobacco.

$HR
EOF
}

GX_Calendar() { # Used in DisplayCharsheet()
    # TODO The Idea is simply put to have a calendar on the right side
    # and some info about the current month on the left (or vice-versa)
    clear
    echo "CALENDAR placeholder"
    echo "$HR"
    PressAnyKey
}


GX_Moon() { # Used in GX_Rest and Almanac_Moon
    case "$MOON" in
	"Old Moon" | "New Moon" ) cat <<"EOT"


                                                           .  - . 
                                                        ,         ` 
                                                                    .
                                                      '
                                                                     '
                                                      .             .

                                                        `  .   .  '


EOT
	    ;;
	"Growing Crescent" ) cat <<"EOT"


                                                               ~-.
                                                                 `'.
                                                                  ` : 
                                                                   ' :
                                                                   ) :
                                                                   ; '
                                                                 ,','
                                                              _.,'


EOT
	    ;;
	"First Quarter" ) cat <<"EOT"


                                                              ,~-.
                                                              :   `. 
                                                              '     `. 
                                                              :      :
                                                              '      :
                                                              :     ;'
                                                              '    ;'
                                                              l.,~'


EOT
	    ;;
	"Growing Gibbous" | "Waxing Gibbous" ) cat <<"EOT"


                                                          ,-~ ~-. 
                                                        ;'        `. 
                                                       ,           `:. 
                                                       .             :
                                                       .             :
                                                       .            ;'
                                                       `           ;'
                                                        ` -.___.,~'


EOT
	    ;;
	"Full Moon" ) cat <<"EOT"
                                                           .    .
                                                       .            .
                                                    .     ,.----.      .
                                                       ,;^        `.
                                                  .   :            `:.   .
                                                     ;               :
                                                 .   :               :   .
                                                     `:             ;'
                                                  .   `:           ;'   .
                                                        `~..___.,~'
                                                      .             .
                                                         .      .
EOT
	    ;;
	"Waning Gibbous" ) cat <<"EOT"


                                                          ,.---. 
                                                       ,;^      `.
                                                      :           .
                                                     ;             .
                                                     :             .
                                                     `:           ;
                                                      `:         ;
                                                        `~..___,'


EOT
	    ;;
	"Third Quarter" | "Last Quarter" ) cat <<"EOT"


                                                         ,~-. 
                                                       ,^   t
                                                      .     '
                                                     ;      :
                                                     :      '
                                                     `.     :
                                                      `.    '
                                                        `~._;


EOT
	    ;;
	"Waning Crescent" ) cat <<"EOT"

                                                           _
                                                        ,;`  
                                                      .:. 
                                                     .:. 
                                                     ; . 
                                                     l . 
                                                     `  . 
                                                      `: . 
                                                        `-:._ 


EOT
	    ;;
    esac
}

GX_Rest() { # Relies on GX_Moon for ASCII
    clear
    GX_Moon # Draw moon

    tput sc
    # Add universal text
    MvAddStr 5 9 "YOU TRY TO GET           *"
    MvAddStr 6 9 "SOME MUCH NEEDED REST       Z Z"

    # Add MOON specific text
    tput cup 8 9
    case "$MOON" in
	"Old Moon" | "New Moon" ) echo "It is dark, the Moon is" && tput cup 8 33
            [[ "$MOON" == "Old Moon" ]] && echo "Olde" || echo "Young" ;;
	"Growing Crescent" )      echo "It is a Growing Crescent Moon" ;;
	"First Quarter" )         echo "The Moon is in its First Quarter" ;;
	"Growing Gibbous" | "Waxing Gibbous" ) echo "The Moon is Waxing" ;;
	"Full Moon" )             echo "It is a Full Moon" ;;
	"Waning Gibbous" )        echo "The Moon is Waning" ;;
	"Third Quarter" | "Last Quarter" ) echo "The Moon is in the Last Quarter" ;;
	"Waning Crescent" )        echo "It is a Waning Crescent Moon" ;;
    esac

    # Finally, sprinkle with stars:
    MvAddStr 3 31 "*         Z Z Z   *"
    MvAddStr 3 77 "*"
    MvAddStr 7 43 "*"
    [ "$MOON" != "Full Moon" ] && MvAddStr 8 74 "*"
    MvAddStr 9 76 "*"
    tput rc
}




GX_Bulletin() { # Requires $BBSMSG as arg, default val=0
    # # Display custom message (BBSMSG)
    case $1 in		       # MAX 35 chars per line !!!
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

#-----------------------------------------------------------------------
# GX_DiceGame()
# Display dices GX for MiniGame_Dice()
# Arguments: $DGAME_DICE_1(int), $DGAME_DICE_2(int).
#-----------------------------------------------------------------------
GX_DiceGame() { 
    GDICE_SYM="@" # @ looks nice:)
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
    if (NR == 10) { $26 = '$1'; $53 = '$2'; }
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
}   # Return to MiniGame_Dice()


GX_DiceGame_Table() {
	clear
	cat <<"EOT"
                             __,"#`._
                           <' ;_   _; `>                                    
                            `-_______~'              
                           .~';;,_;; ~.      ____                        
                          /    ;:;'    \    `----'                 
                   ______(  (   ' __,7  )___ )  ( _________    
                  :\  __  \__\   (/____/ _  (____) _____   \     
                  ':\  ____ (_7  * *    ___________    ___  \
                   ':\_______________________________________\ 
                    'L.______________________________________]
EOT
	echo "$HR"
}


GX_DiceGame_Instructions() {
    GX_DiceGame_Table
    cat <<"EOT"
  We're playing Charm the Dice, friend. You put down your stake each round,
  which go in the pot on the table. Ask your deity for which number to bet,
  ranging from Dragon Eyes (2) to Pillars (12), and pray she smiles on you.
 
  Some numbers are more blessed than others. Lucky 7 being the safest bet,
  it pays out the least, while Dragon Eyes and Pillars pay out the full pot!
  If no one wins the round, the stakes go on into the next round. No one can
  take any Gold from the pot without winning it. The Gods are watching ..

EOT
    PressAnyKey
}

GX_Tavern() {
    clear
    cat <<"EOT"    
     __________             
    |  ______  |       ___________________________________          
    |  `\VV/   |      / \_|___|___|___|___|___|___|___|_/ \         /T\
    |    \/    |     /\ /    _                      \   \ /\     __/___\__
     \   /\   /     /__/   C|`|  _  _                \___\__\   | no orcs |
      \ (__) /      |__| ...|_|c[_]|_]D..            |   |__|   | allowed |   
       \ ** /  _____|__|  ''''''''''''''''           |   |__|   |_________| 
        \__/  |\    \ _|   __              __        |   |__|       ________ 
              |\\    \_|___||_____________ XX __     |`. |__|      // /  \  \ 
              |\\\        (__)            (__)  \    ,;: |__|     |==========|
              |\\\\______________________________\ ,;;:;:|__|     | | |   |  |
  ____________\\\\|_  __   __   ___  ____________| ::;:;;|__|_____|==========|
               \\\|_______  ______  __  ___  ____|  """"\|__|     | | |   |  |
                \\|__  _  ____  _____   ____  ___|                 \________/
                 \|______________________________|
               
EOT
    echo "$HR"
}

GX_Marketplace() { # Several Town shoppes view'd from end o' the street
    clear
    cat <<"EOT"
                                                            ,;;7 `l\\ \\\ \\\\
    ______    grocers                                     ,~`'      \ \\ \ \\\
      _   \__       ____                  trade          //'         \\ \\ \\ \
 \__   \__   \__  _  _  `~-.,8               ___        //|    ,.--.  \\ \ \ \\
    \     \     \[_]  \__#;' I             ,;___`.        |  ,' ,.. `. \\ \ \\
\_   _      _.-~'||| ,;. ||_ I .      .    ||____|    .   |  \,'   `./  \\\ \\ \
  \_[_],.-~'     |||;;','|| 7I  `.      -  \|____|  ,     |     _       |\\ \\\
 .-.|||          |||_|_ )||7 /   :        ` ~ -- -       .|c-c { ``e    ||\\ \ \
;; ~|||  .*,_____|||     || /    .                     ,  |l_| |   l    || ''_'_
,%.-||| ( ))_.-~' || ____||/    ,                     .   |    |   |    ||  [_|_
|___|||_.-~'      ||   ''"'    ,                      .   `~.  |  o|    ||  [_|_
    |||           ||        , '                        -     `~1   |    ||   
    |||          _||     , '                              .     `~.|    ||      
    |||     _.-~'     , '                                      .    `~._||______
    |||_.-~'     ,  '                                    tobacco     .     
EOT
    echo "$HR"

}

GX_Marketplace_Grocer() {
    clear
    cat <<"EOT"
                                                       __   __   _            
                                          || |  ;,   _(_ )_' _] /_\  || |     
           THE GROCER                     ||,'_&%0_ (______)  ] [_]  ||,l_____
                                      ____jl_______ %","","%` _______jl_______
    "Welcome to my humble store,      ~~~ |T~~~~ ,-~(  (.  )~-. ~~~~ |T~~~~~~~
    traveller, tell me what you need!     ||   ,;    -.__;-    `.    || | _)(_
                                          || .;        ""        `.  ||,'(____)
    If we don't have it, I suspect        |l;'  (      _|_     ,  `: |l_______ 
    nobody else will neither.             |;'  ,;)_ _ _ o_ _ _,^.   \',~~~~~~~
                                    ______,~,~ t(______________)_;~~~: _______
                                   _____  '----`    ____      __ '-^-^`  _____
   
EOT
    echo "$HR"
}



GX_Marketplace_Merchant() { # Used in GX_Marketplace (Goatee == dashing, not hipster)
    clear
    cat <<"EOT"
                                                            .--^`~~.
                                                            ),-~~._/     
              THE MERCHANT                                  j-, -`;;     
                                                            .~_~  ,'       
                                                         __..`#~-(.__
                                                      ,~'    `.\/,'  `\    
                                                     /  ,-.   |  |  .  \ .,,  
                                                     \  \ _)__;~~l__|\  `[ } 
                                           .-,        `._{__7-~-~-~~; `~-'|l  
                                           ,X.             :-'      |    ;  \  
                                        __(___)_.~~,__    ;     (  `l   (__,_)
                                       [ _ _ _ _,)(. _]  ;      l    `,        
                                       [_ _ _ ,'    `.] ;       )     )       
                                       [ _ _ /        \ \,_____/\____,'     
                                       l_____l        4    ;_/  ,|_/__ 
                                             `-._____,'   /--|  \._`_.) 
                                                          \_/    
EOT
    echo "$HR"
}

# GFX MAP FUNCTIONS
LoadCustomMap() { # Used in MapCreate()
    local LIMIT=9 OFFSET=0 NUM=0
    while (true) ; do
	GX_LoadGame
	awk '{printf "  | %-15.-15s | %-15.-15s | %-30.-30s\n", $1, $2, $3, $4;}' <<< 'NAME CREATOR DESCRIPTION'
	for (( a=1; a <= LIMIT ; a++)); do
	    NUM=$(( a + OFFSET ))
	    [[ ! ${MAPS[$NUM]} ]] && break	    
	    [[ ${MAPS[$NUM]} == "Deleted" ]] && echo "  | Deleted" && continue
	    awk '{ if (/^NAME:/)        { RLENGTH = match($0,/: /); NAME = substr($0, RLENGTH+2); }
                   if (/^CREATOR:/)     { RLENGTH = match($0,/: /); CREATOR = substr($0, RLENGTH+2); }
                   if (/^DESCRIPTION:/) { RLENGTH = match($0,/: /); DESCRIPTION = substr($0, RLENGTH+2); }
                   FILE = "'${MAPS[$NUM]}'";
                   gsub(".map$", "", FILE); }
             END { printf "%s | %-15.15s | %-15.15s | %-30.30s\n", "'$a'", NAME, CREATOR, DESCRIPTION ;}' "${GAMEDIR}/${MAPS[$NUM]}"
	    # I remember that it should be centered, but I haven't any ideas how to do it now :( kstn
	done
	(( i > LIMIT)) && echo -en "\n You have more than $LIMIT maps. Use (P)revious or (N)ext to list," # Don't show it if there are maps < LIMIT
	echo -en "\n Enter NUMBER of map to load or any letter to play (D)efault map: "
	read -n 1 NUM # TODO replace to read -p after debug
	case "$NUM" in
	    n | N ) ((OFFSET + LIMIT < i)) && ((OFFSET += LIMIT)) ;; # Next part of list
	    p | P ) ((OFFSET > 0))         && ((OFFSET -= LIMIT)) ;; # Previous part of list
	    [1-9] ) NUM=$((NUM + OFFSET));                           # Set NUM == selected map num
		MAP=$(awk '{ if (NR > 5) { print; }}' "${GAMEDIR}/${MAPS[$NUM]}")
		if grep -q 'Z' <<< "$MAP" ; then # check for errors
		    CustomMapError "${GAMEDIR}/${MAPS[$NUM]}" 
		    MAPS[$NUM]="Deleted"
		    continue 
		fi
		clear
		echo "$MAP"
		read -sn1 -p "Play this map? [Y/N]: " VAR 2>&1
		[[ "$VAR" == "y" || "$VAR" == "Y" ]] && CUSTOM_MAP="${GAMEDIR}/${MAPS[$NUM]}" ; return 0; # Return to MapCreate()
		unset MAP ;;
	    *     )  break;; 
	esac
    done
    return 1; # Return to MapCreate() and load default map
}

# FILL THE $MAP file using either default or custom map
MapCreate() {
    # CHECK for custom maps 
    local i=0 # Count of all sheets. We could use ${#array_name[@]}, but I'm not sure if MacOS'll understand that. So let's invent bicycle!
    # xargs ls -t - sort by date, last played char'll be the first in array
    for loadMAP in $(find "$GAMEDIR"/ -name '*.map' | sort) ; do # Find all sheets and add to array if any
	MAPS[((++i))]=$(basename "$loadMAP") # i++ THAN initialize SHEETS[$i]
    done

    if [[ "${MAPS[@]}" ]] ; then # If there is/are custom map/s
	GX_LoadGame
	read -sn 1 -p "Would you like to play (C)ustom map or (D)efault? " MAP 2>&1
	[[ "$MAP" == "C" || "$MAP" == "c" ]] && LoadCustomMap && return 0  #leave
    fi
    MAP=$(cat <<EOT
       A | B | C | D | E | F | G | H | I | J | K | L | M | N | O | P | Q | R 
   #=========================================================================#
 1 )   x   x   x   x   x   @   .   .   .   T   x   x   x   x   x   x   @   T (
 2 )   x   x   H   x   @   @   .   @   @   x   x   x   x   x   @   @   @   @ (
 3 )   @   @   .   @   @   @   .   x   x   x   x   x   @   x   @   x   @   @ (
 4 )   @   @   .   @   @   @   .   @   x   x   x   @   T   x   x   x   x   x (
 5 )   @   @   .   .   T   .   .   @   @   @   @   @   .   @   x   x   x   x (
 6 )   @   @   @   @   .   @   @   @   @   @   @   @   .   @   @   x   x   x (
 7 )   @   @   @   @   .   .   .   T   @   @   @   @   .   @   @   x   x   x (
 8 )   @   @   T   .   .   @   @   @   @   @   @   .   .   .   .   .   .   x (
 9 )   @   @   .   @   @   @   @   @   @   @   .   .   @   x   @   @   .   . (
10 )   @   @   .   @   @   @   T   @   @   @   .   @   @   x   x   x   x   . (
11 )   T   .   .   .   .   .   .   .   @   @   .   x   x   C   x   x   x   . (
12 )   x   @   @   @   .   @   @   .   .   .   .   x   x   x   x   x   x   . (
13 )   x   x   @   x   .   @   @   @   @   @   .   @   x   x   @   @   @   . (
14 )   x   x   x   x   .   @   @   @   @   T   .   @   x   x   @   @   .   . (
15 )   x   x   x   T   .   @   @   @   @   @   @   @   @   T   .   .   .   @ (
   #=========================================================================#
          LEGEND: x = Mountain, . = Road, T = Town, @ = Forest         N
                  H = Home (Heal Your Wounds) C = Oldburg Castle     W + E
                                                                       S
EOT
       )
}


#                          END GFX FUNCTIONS                           #
#                                                                      #
#                                                                      #
########################################################################

