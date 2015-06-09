#!/usr/bin/bash
# Back In A Minute created by Sigg3.net (C) 2014
# Code is GNU GPLv3 & ASCII art is CC BY-NC-SA 4.0
VERSION="1.9" # 12 items on TODO. Change to 2.0 when list is x'd out
WEBURL="http://sigg3.net/biamin/"
REPO="https://gitorious.org/back-in-a-minute/code"

########################  CONFIGURATION  ###############################
# Default dir for config, saves, etc, change at runtime                #
GAMEDIR="$HOME/.biamin" # (no trailing slash!)                         #
# Default file for config, change at runtime                           #
CONFIG="$GAMEDIR/config"                                               #
# Default file for highscore, change at runtime                        #
HIGHSCORE="$GAMEDIR/highscore"                                         #
#                                                                      #
# Disable BASH history for this session                                #
unset HISTFILE                                                         #
#                                                                      #
# Hero start location e.g. Home (custom maps only):                    #
START_LOCATION="C2"                                                    #
#                                                                      #
# Disable Cheats 1 or 0 (chars with >150 health set to 100 health )    #
DISABLE_CHEATS=0                                                       #
#                                                                      #
# Editing beyond this line is considered unsportsmanlike by some..!    #
# END CONFIGURATION                                                    #
#                                                                      #
# 'Back in a minute' uses the following coding conventions:            #
#                                                                      #
#  0. Variables are written in ALL_CAPS                                #
#  1. Functions are written in CamelCase                               #
#  2. Loop variables are written likeTHIS                              #
#  3. Put the right code in the right blocks (see INDEX below)         #
#  4. Please explain functions right underneath function declarations  #
#  5. Comment out unfinished or not working new features               #
#  6. If something can be improved, mark with TODO + ideas             #
#  7. Follow the BASH FAQ practices @ www.tinyurl.com/bashfaq          #
#  8. Please properly test your changes, don't break anyone's heart    #
#  9. $(grep "$ALCOHOLIC_BEVERAGE" fridge) only AFTER coding!          #
#                                                                      #
#  INDEX                                                               #
#  0. GFX Functions Block (~ 600 lines ASCII banners)                  #
#  1. Functions Block                                                  #
#  2. Runtime Block (should begin by parsing CLI arguments)            #
#                                                                      #
#  Please observe conventions when updating the script, thank you.     #
#                                           - Sigg3                    #
#                                                                      #
########################################################################
########################################################################
#                                                                      #
#                        0. GFX FUNCTIONS                              #
#                All ASCII banner-functions go here!                   #


#-----------------------------------------------------------------------
# GX_CharSheet()
# Display Charsheet or Almanac banner
# Arguments: $DISPLAY_WHAT(int)
#	EMPTY/1 = CHARSHEET,
#	2       = ALMANAC
#       3       = ALMANAC NOTES
#-----------------------------------------------------------------------
GX_CharSheet() {
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
    case "$1" in
	3 ) MvAddStr 3 11 "         A   L   M   A   N   A   C        " ;
	    MvAddStr 5 11 "                 N O T E S                " ;;
	2 ) MvAddStr 3 11 "         A   L   M   A   N   A   C        " ;;
	* ) MvAddStr 3 11 "C  H  A  R  A  C  T  E  R     S  H E  E  T" ;
	    MvAddStr 5 11 "            s t a t i s t i c s           " ;;
    esac
    tput rc
}

#-----------------------------------------------------------------------
# GX_Death()
# Display Death ASCII and text
# Arguments: $TYPE_OF_DEATH(int) (defined in Death.sh)
# Used: Death()
#-----------------------------------------------------------------------
GX_Death() {
    clear
    cat <<"EOT"


                                        ///`~ ,~---..._
                                 ~~--- \\\\ ',l        `~,.   ~ ~ --  ---  -- --
                                        _`~--;~,)_     ,',~`.      ,
                                 ,-    ;_`-,'_/  ;`~~-;,'    \              o
                                 `.`.    `~.'  _; ;    7 \   /
                               -   `.`.       `-~'    /  <\  \____ _          `
                                     `.`._,           `----\______\_`--
                                  ,   ;,~('         -         .     `--`    .
                                          `c
EOT
    echo "$HR"
    tput sc
    case "$1" in             # define text
	"$DEATH_FIGHT")      MvAddStr 3 9 "   YOU WERE DEFEATED  " ;
			     MvAddStr 5 9 "The smell of dirt and " ;
			     MvAddStr 6 9 "blood will be the last" ;
			     MvAddStr 7 9 "    thing you know.   " ;;
	"$DEATH_STARVATION") MvAddStr 3 9 " YOU STARVED TO DEATH " ;
			     MvAddStr 5 9 " Only death triumphs  " ;
			     MvAddStr 6 9 "     over hunger.     " ;;
	*)                   Die "${FUNCNAME}: Bad ARG >>>$1<<<" ;;
    esac
    tput rc
    PressAnyKey
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

#-----------------------------------------------------------------------
# GX_Intro()
# Display intro banner $1 seconds
# Arguments: $SECONDS(int)
# Used: Intro()
#-----------------------------------------------------------------------
GX_Intro() {
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

    local COUNTDOWN="$1"
    echo "$HR"
    echo -n "                         Press (A)ny key to continue.."
    tput sc
    while ((COUNTDOWN--)); do
	tput rc
    	((COUNTDOWN % 2)) && echo -n "." || echo -n " "
    	read -sn 1 -t 1 && break
    done
}

#-----------------------------------------------------------------------
# GX_Calendar()
# Used: DisplayCharsheet()
# TODO: The Idea is simply put to have a calendar on the right side
# and some info about the current month on the left (or vice-versa)
# TODO is this obsolete?
#-----------------------------------------------------------------------
GX_Calendar() {
    clear
    echo "CALENDAR placeholder"
    echo "$HR"
    PressAnyKey
}

#-----------------------------------------------------------------------
# GX_Moon()
# Arguments: $MOON(int[0-7]) (Count of moon phases)
# Used: GX_Rest(), Almanac_Moon()
#-----------------------------------------------------------------------
GX_Moon() {
    case "$1" in
	0 ) cat <<"EOT"


                                                           .  - .
                                                        ,         `
                                                                    .
                                                      '
                                                                     '
                                                      .             .

                                                        `  .   .  '


EOT
	    ;;
	1 ) cat <<"EOT"


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
	2 ) cat <<"EOT"


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
	3 ) cat <<"EOT"


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
	4 ) cat <<"EOT"
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
	5 ) cat <<"EOT"


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
	6 ) cat <<"EOT"


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
	7 ) cat <<"EOT"

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
	* ) Die "${FUNCNAME}: Bad ARG >>>$1<<<" ;;
    esac
}

#-----------------------------------------------------------------------
# GX_Rest()
# Relies on GX_Moon for ASCII
#-----------------------------------------------------------------------
GX_Rest() {
    clear
    GX_Moon "$MOON" # Draw moon

    tput sc
    # Add universal text
    MvAddStr 5 9 "YOU TRY TO GET           *"
    MvAddStr 6 9 "SOME MUCH NEEDED REST       Z Z"

    # Add MOON specific text
    tput cup 8 9
    case "$MOON" in
	0 ) echo "It is dark, the Moon is Young" ;;
	1 ) echo "It is a Growing Crescent Moon" ;;
	2 ) echo "The Moon is in its First Quarter" ;;
	3 ) echo "The Moon is Waxing" ;;
	4 ) echo "It is a Full Moon" ;;
	5 ) echo "The Moon is Waning" ;;
	6 ) echo "The Moon is in the Last Quarter" ;;
	7 ) echo "It is a Waning Crescent Moon" ;;
    esac

    # Finally, sprinkle with stars:
    MvAddStr 3 31 "*         Z Z Z   *"
    MvAddStr 3 77 "*"
    MvAddStr 7 43 "*"
    [ "$MOON" != "Full Moon" ] && MvAddStr 8 74 "*"
    MvAddStr 9 76 "*"
    tput rc
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

# GFX MAP FUNCTIONS
LoadCustomMap() { # Used in MapCreate()
    local LIMIT=9 OFFSET=0 NUM=0
    MAPS=("dummy" "${MAPS[@]}")	# Add dummy ${MAP[0]}
    local i=${#MAPS[@]}
    while (true) ; do
	GX_LoadGame
	awk '{printf "#   %-15.-15s   %-15.-15s   %-30.-30s\n", $1, $2, $3, $4;}' <<< 'NAME CREATOR DESCRIPTION'
	for (( a=1; a <= LIMIT ; a++)); do
	    NUM=$(( a + OFFSET ))
	    [[ ! ${MAPS[$NUM]} ]] && break
	    [[ ${MAPS[$NUM]} == "Deleted" ]] && echo "  | Deleted" && continue
	    awk '{ if (/^NAME:/)        { RLENGTH = match($0,/: /); NAME = substr($0, RLENGTH+2); }
                   if (/^CREATOR:/)     { RLENGTH = match($0,/: /); CREATOR = substr($0, RLENGTH+2); }
                   if (/^DESCRIPTION:/) { RLENGTH = match($0,/: /); DESCRIPTION = substr($0, RLENGTH+2); }
                   FILE = "'${MAPS[$NUM]}'";
                   gsub(".map$", "", FILE); }
             END { printf "%s   %-15.15s   %-15.15s   %-30.30s\n", "'$a'", NAME, CREATOR, DESCRIPTION ;}' "${MAPS[$NUM]}"
	done
	(( i > LIMIT)) && echo -en "\n You have more than $LIMIT maps. Use (P)revious or (N)ext to list," # Don't show it if there are maps < LIMIT
	echo "" # Empty line
	# TODO change to "Enter NUMBER of map to load, load (D)efault map or go to (M)ain menu: "
	echo -n "Enter NUMBER of map to load, load (D)efault map or (Q)uit: "
	read -sn 1 NUM
	case "$NUM" in
	    [nN]  ) ((OFFSET + LIMIT < i)) && ((OFFSET += LIMIT)) ;; # Next part of list
	    [pP]  ) ((OFFSET > 0))         && ((OFFSET -= LIMIT)) ;; # Previous part of list
	    [1-9] ) NUM=$((NUM + OFFSET));                           # Set NUM == selected map num
		    [[ ! "${MAPS[$NUM]}" ]] && continue              # Do not try to display absent map
		    [[ "${MAPS[$NUM]}" == "Deleted" ]] && continue   # Do not try to display deleted map
		    MAP=$(awk '{ if (NR > 5) { print; }}' "${MAPS[$NUM]}")
		    if grep -q 'Z' <<< "$MAP" ; then                 # Check for errors
			CustomMapError "${MAPS[$NUM]}"
			MAPS[$NUM]="Deleted"
			continue
		    fi
		    clear
		    # Simple map preview to confirm/reject choice of map
		    local MAP_NAME=$(sed -n '/^NAME:/s/NAME: //gp' "${MAPS[$NUM]}")
		    local MAP_AUTH=$(sed -n '/^CREATOR:/s/CREATOR: //gp' "${MAPS[$NUM]}" )
		    local MAP_DESC=$(sed -n '/^DESCRIPTION:/s/DESCRIPTION:/Description:/gp' "${MAPS[$NUM]}")
#			echo -e "\n$MAP" | grep -B 1 -A 17 "       A | B | C | D | E | F | G | H | I | J | K | L | M | N | O | P | Q | R" # Display without LEGEND
			echo 	# empty line
			sed -n 6,23p  "${MAPS[$NUM]}" # Display without LEGEND
			local MAP_AUTH_XPOS=75
			MAP_AUTH_XPOS=$( bc <<< "$MAP_AUTH_XPOS - ${#MAP_AUTH}" )
			tput sc
			MvAddStr 20 $MAP_AUTH_XPOS "By $MAP_AUTH" # Put CREATOR to the far right on same row as NAME
			tput rc
		    echo -en "\n   Custom map:  $MAP_NAME\n   $MAP_DESC\n$HR\n Play this map? [Y/N]: "
		    [[ $(Read) == [yY] ]] && CUSTOM_MAP="${MAPS[$NUM]}" && return 0; # Return to MapCreate()
		    unset MAP ;;
	    [qQ]  ) CleanUp ;;
	    *     ) break ;;
	esac
    done
    return 1; # Return to MapCreate() and load default map
}

# FILL THE $MAP file using either default or custom map
MapCreate() {
    # # xargs ls -t - sort by date, last played char'll be the first in array
    MAPS=( $(find "$GAMEDIR"/ -name '*.map' | sort) )     # CHECK for custom maps
    if [[ "${MAPS[@]}" ]] ; then # If there is/are custom map/s
	echo -en "\n Custom maps found in $GAMEDIR\n Would you like to play a (C)ustom map or the (D)efault? " #&& read -sn 1 CUSTOM_MAP_PROMPT
	[[ $(Read) == [Cc] ]] && LoadCustomMap && return 0  # leave
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
########################################################################
#                             GX_Item                                  #
#                                                                      #

#-----------------------------------------------------------------------
# GX_Item()
# Display GX for current magic item
# Arguments: $CHAR_ITEMS(int)
#-----------------------------------------------------------------------

GX_Item() {
    clear
    case "$1" in
	"$GIFT_OF_SIGHT")
	    cat <<"EOT"

                          G I F T   O F   S I G H T

                                ..............
                                ____________**:,.
                             .-'  /      \  ``-.*:,..
                         _.-*    |  .jM O |     `-..*;,,
                        `-.      :   WW   ;       .-'
                   ....    '._    \______/     _.'   .:
                      *::...  `-._ _________,;'    .:*
                          *::...                 ..:*
                               *::............::*

     You give aid to an old woman, carry her firewood and water from the
     stream, and after a few days she reveals herself as a White Witch!

     She gives you a blessing and the Gift of Sight in return for your help.
     "The Gift of Sight," she says, "will aide you as you aided me."

     Look for a ~ symbol in your map to discover new items in your travels.
     However, from the 7 remaining items only 1 is made visible at a time.

EOT
	    ;;
	"$EMERALD_OF_NARCOLEPSY")
	    cat <<"EOT"

                  E M E R A L D   O F   N A R C O L E P S Y
                             .   .  ____  .   .
                                .  /.--.\  .
                               .  //    \\  .
                            .  .  \\    //  .  .
                                .  \\  //  .
                             .   .  \`//  .   .
                                     \/
     You encounter a strange merchant from east of all maps who joins you
     for a stretch of road. He is a likeable fellow, so when he asks if he
     could share a campfire with you and finally get some much needed rest in
     these strange lands, you comply.

     The following day he presents you with a brilliant emerald that he says
     will help you sleep whenever you need to get some rest. Or at least
     fetch you a good price at the market. Then you bid each other farewell.

     +1 Healing, Chance of Healing Sleep when you are resting.

EOT
	    ;;
	"$GUARDIAN_ANGEL")
	    cat <<"EOT"

                          G U A R D I A N   A N G E L
                        .    . ___            __ ,  .
                      .      /* * *\  ,~-.  / * *\    .
                            /*   .:.\ l`; )/*    *\
                     .     |*  /\ :-,_,' ()*  /\  *|    .
                           \* |  ||\__   ~'  |  | */
                      .     \* \/ |  / /\ \  \ / */   .
                             \*     / ^  ^ \    */
                        .     )* _  ^|^|^|^^ _ *(    .
                             /* /     |  |    \ *\
                       .    (*  \__,   | | .__/  *)   .
                             \*  *_*_ // )*_*   */
                        .     \* /.,  `-'   .\* /    .
                          .    \/    .   .   `\/
                            .     .         .     .
                              .                 .
     You rescue a magical fairy caught in a cobweb, and in return she
     promises to come to your aid when you are caught in a similar bind.

     +5 Health in Death if criticality is less than or equal to -5

EOT
	    ;;
	"$FAST_MAGIC_BOOTS")
	    cat <<"EOT"

                        F A S T   M A G I C   B O O T S
                              _______  _______
                             /______/ /______/
                              |   / __ |   / __
                             /   /_(  \'  /_(  \
                            (_________/________/

     You are taken captive by a cunning gnome with magic boots, holding you
     with a spell that can only be broken by guessing his riddles.
     After a day and a night in captivity you decide to counter his riddles
     with one of your own: "What Creature of the Forest is terribly Red and
     Whiny, and Nothing Else without the Shiny?"

     The gnome ponders to and fro, talking to himself and spitting, as he gets
     more and more agitated. At last, furious, he demands "Show me!" and
     releases you from the spell. Before he knows it you've stripped off his
     boots and are running away, magically quicker than your normal pace.

     +1 Flee

EOT
	    ;;
	"$QUICK_RABBIT_REACTION")
	    cat <<"EOT"

                    Q U I C K   R A B B I T   R E A C T I O N

                                   .^,^
                                __/ ; /____
                               / c   -'    `-.
                              (___            )
                                  _) .--     _')
                                  `--`  `---'

     Having spent quite a few days and nights out in the open, you have grown
     accustomed to sleeping with one eye open and quickly react to the dangers
     of the forests, roads and mountains in the old world, that seek every
     opportunity to best you.

     Observing the ancient Way of the Rabbit, you find yourself reacting more
     quickly to any approaching danger, whether it be day or night.

     +1 Initiative upon enemy attack

EOT
	    ;;
	"$FLASK_OF_TERRIBLE_ODOUR")
	    cat <<"EOT"

                  F L A S K   O F   T E R R I B L E   O D O U R
                        /  /    * *  /    _\ \       ___ _
                        ^ /   /  *  /     ____)     /,- \ \
                         /      __*_     / / _______   \ \ \
                 ,_,_,_,_ ^_/  (_+ _) ,_,_/_/       ) __\ \_\___
                /          /  / |  |/     /         \(   \7     \
           ,   :'      \    ^ __| *|__    \    \  ___):.    ___) \____/)
          / \  :.       |    / +      \  __\    \      :.              (\
        _//^\\  ;.      )___(~~~~~~~*~~)_\_____  )_______:___            }
        \ |  \\_) ) _____,)  \________/   /_______)          vvvVvvvVvvvV
         \|   `-.,'
     Under a steep rock wall you encounter a dragon pup's undiscovered carcass.
     You notice that its rotten fumes curiously scare away all wildlife and
     lowlife in the surrounding area.
     You are intrigued and collect a sample of the liquid in a small flask that
     you carry, to sprinkle on your body for your own protection.

     +1 Chance of Enemy Flee

EOT
	    ;;
	"$TWO_HANDED_BROADSWORD")
	    cat <<"EOT"

                   T W O - H A N D E D    B R O A D S W O R D
                       .   .   .  .  .  .  .  .  .  .  .  .
                  .  .   /]______________________________   .
                .  ,~~~~~|/_____________________________ \
                .  `=====|\______________________________/  .
                  .  .   \]   .  .  .  .  .  .  .  .  .   .
                        .  .
     From the thickest of forests you come upon and traverse a huge unmarked
     marsh and while crossing, you stumble upon trinkets, shards of weaponry
     and old equipment destroyed by the wet. Suddenly you realize that you are
     standing on the remains of a centuries old, long forgotten battlefield.

     On the opposite side, you climb a mound only to find the wreckage of a
     chariot, crashed on retreat, its knight pinned under one of its wheels.
     You salvage a beautiful piece of craftmanship from the wreckage;
     a powerful two-handed broadsword, untouched by time.

     +1 Strength

EOT
	    ;;
	"$STEADY_HAND_BREW")
	    cat <<"EOT"

                      S T E A D Y   H A N D   B R E W
                              ___
                             (___)            _  _  _ _
                              | |           ,(  ( )  ) )
                             /   \         (. ^ ( ^) ^ ^)_
                            |     |        ( ~( _)- ~ )-_ \
                            |-----|         [_[[ _[[ _{  } :
                            |X X X|         [_[[ _[[ _{__; ;
                            |-----|         [_[[ _[[ _)___/
              ______________|     |   _____ [_________]
             |     | >< |   \___ _| _(     )__
             |     | >< |    __()__           )_
             |_____|_><_|___/     (__          _)
                                    (_________)

     Through the many years of travel you have found that your acquired taste
     of a strong northlandic brew served cool keeps you on your toes.

     +1 Accuracy and Initiative

EOT
	    ;;
	*)  Die "${FUNCNAME}: Bad ARG >>>$1<<<" ;;
    esac
    echo "$HR"
}

#                                                                      #
#                                                                      #
########################################################################
########################################################################
#                           GX_Monster                                 #
#                           (cc-version)                               #

#-----------------------------------------------------------------------
# GX_Monster()
# Display enemy's GX
# Arguments: ${enemy[name]} (string)
#-----------------------------------------------------------------------
GX_Monster() {
    clear
    case "$1" in
	"chthulu" ) # Created 2013, release 2014 (a684a35)
	cat <<"EOT"
                        \ \_|\/\      ,.---.      ,/'/            \`\
                         \ _    \   ;'      `\   ,/ /              \ \
         T H E            \ \____\.:          \-.J  l._   ____      \`\
         M I G H T Y       \_    _|            |       `,/ __ )      \ \
                             \  /,\    .\  /.  |        / |_ (_   __  \`\
         C H T H U L U ' S    \/,* '.         /       _/ /|  | \_/  )  \ \
                              7  , _;        t      / _/   \/   /-/|    \`\
         W R A T H   I S     ;  ; / ,(((| ;\,`\    / /          \/ |     \ \   (
         U P O N   Y O U    ;  .'( ',  "| :   \}  (, |~~~~~~~~~~L /       \`\ _/
                           ,' ,.  `~'   ' ',       \_) `.       |/         \_/
                          ,;  ';    \.   \_/            `.              .__(
                         ('   ()     `.                   `.         ,__(
                          \_\_`\      `\                    `.     ,_(
                                        )                     `.   (
EOT
	    ;;
	"orc" ) # Created 2013, release 2014 (a684a35)
	 cat <<"EOT"
                                                  |\            /|
                                                  | \_.::::::._/ |
                                                   |  __ \/__   |
                                                    |          |
         AN ANGRY ORC APPEARS,                  ____| _/|__/|_ |____
         BLOCKING YOUR WAY!                    /     \________/     \
                                              /                      \
         "Prepare to die", it growls.        |    )^|    _|_   |^(    |
                                             |   )  |          |  (   |
                                             |   |   |        |   (   |
                                              \_\_) |          | (_/_/
                                                   /     __     \
                                                  |     /  \     |
                                                  |    (    )    |
                                                  |____'    '____|
                                                 (______)  (______)
EOT
	    ;;
	"varg" ) # Created 2013, release 2014 (a684a35)
	cat <<"EOT"

                                                     ______
                                               ____.:      :.
                                        _____.:               \___
         YOU ENCOUNTER A         _____/  _  )      __            :.__
         TERRIBLE VARG!         |       7             `      _       \
                                  ^^^^^ \    ___        1___ /        |
         It looks hungry.           ^^^^  __/   |    __/    \1     /\  |
                                     \___/     /   _|        |    / | /  _
                                            __/   /           |  \  | | | |
                                           /_    /           /   |   \ ^  |
                                             /__/           |___/     \__/


EOT
	    ;;
	"mage" ) # Created 2013, release 2014 (a684a35)
	cat <<"EOT"
                                             ---.         _/""""""\
                                            (( ) )       /_____  |'
                                             \/ /       // \/  \  \
                                             / /       ||(.)_(.)|  |
                                             (|`\      ||  ( ;  |__|
         A FIERCE MAGE STANDS                (|  \      7| +++   /
         IN YOUR WAY!                        ||__/\____/  \___/  \___
                                             ||      |             /  \
         Before you know it, he begins       ||       \     \/    /    \
         his evil incantations..             ||\       \   ($)   /      \
                                             || \   /^\ \ ______/  ___   \
         "Lorem ipsum dolor sit amet..."     ||  \_/  |           /  __   |
                                             ||       |          |  /__|  |
                                             ||       |          \  |__/  |
                                             ||      /            \_____/
                                             ^      /               \
                                                   |        \        \
EOT
	    ;;
	"goblin" ) # Created 2013, release 2014 (a684a35)
	cat <<"EOT"
                                                    _______                   _
                                                   (       )/|    ===[]]]====(_)
                                                ____0(0)    /       7 _/^
                                                L__  _)  __/       / /
         A GOBLIN JUMPS YOU!                      /_V)__/ 1       / /
                                             ______/_      \____ / /
         He raises his club to attack..     /   .    \      _____/
                                           |  . _ .   | .__/|
                                           | . (_) .  |_____|
                                           |  . . .   |$$$$$|
                                            \________/$$$$$/ \
                                                 /  /\$$$$/\  \
                                             ___/  /      __|  \
                                            (_____/      (______)
EOT
	    ;;
	"bandit" ) # Created 2013, release 2014 (a684a35)
	cat <<"EOT"
                                                       /""""""';   ____
                                                      d = / =  |3 /1--\\
                                                 _____| _____  |_|11 ||||
         YOU ARE INEXPLICABLY                   /     \_\\\\\\_/  \111///
         AMBUSHED BY A LOWLIFE CRIMINAL!       /  _ /             _\1// \
                                              /  ) (     |        \ 1|\  \
         "Hand over your expensive stuffs,   /   )(o____ (   ____o) 1|(  7
         puny poncer, or have your skull     \   \ :              . 1/  /
         cracked open by the mighty club!"    \\\_\'.     *       ;|___/
                                                   /\____________/
                                                  / #############/
                                                 (    ##########/ \
                                                __\    \    \      )__
                                               (________)    (________)
EOT
	    ;;
	"boar" ) # Created June 2014 (2a62c4f)
	cat <<"EOT"
                                ;".  ,--~-./L-'"'"'"'"~,
                                |\ \/     /, | ~  ` ~   `"`~,-~~._.
                                (_\/ _  _ \__)~   ~     ~        ~ \.
                                   ) 6) 6       ~    ~       ~       \_
         A WILD BOAR              /   ,       \           ~       ~    \
         CROSSES YOUR PATH!      / /(,   )\    | ~   `         '     ~ '.
                                ( (,-~-.'L_)  /         ,)    ~   |   ~ |
         Careful, this beast     \(_o_o_)/ ,-'     ~   7'        7'     )
         is not as peaceful       `\ ___";'  ~  ~     _/'  ~    /'    ./
         as it looks.                \""'           y'      ,-***-v   \
                                      |    /"""\   /*~~-~--* |     \  |
                                       )  [    |  /      /  /      |  |
                                       [  |    ]  \     /  (       [  |
                                      /,__\   /,___\   /___%       /__7
EOT
	    ;;
	"dragon" ) # Created June 2014 (?)
	cat <<"EOT"
                                                         ,,_____.
                                                     ,~-'.------.`'~-._
                                 _,-----.._         / /""'       `7-,~-`.
                                /,-~"`-_ v,;.      / / ,......    /(
                                \(,-~t,.`\( `\.   ( l,;"'' '"::.   \
                                 `\     Y_\\ `\.  \\;:::.     ':.  `\
         A DRAGON SWOOPS IN!             ,`\\  `\  \\  `:.      `:. \\
                                     ___/(__))   \,; )  `:.       `:. \
         There is nowhere        ,_,'~   (~-^^^`~ ',^    `:.        `:.\  >>:.
         to hide or run.        ;__.-,  '_(       (       `:.        ,`;\   \W.
                                  ` _; ,Y `-.  ^           `:.      /(`\|    ;M
         Fight for your life!       `-'      \     ^ `  ,-.  `:.   ,/        M;
                                              `+._     (  `\_  `:.||        ,M'
                                                   > ,_  (   `\_`,`|n-, _ ,;M;
                                                   (  C`~-\  `_ `~_/ e`n';m*7
EOT
	    ;;
	"bear" ) # Created September 2014 (860b051)
	cat <<"EOT"
                                               ,--~~.._
                                          _.,;'        `-.....__
                                  ,..-~~^"                      `~~~~-.._
                                ,^ l`)                                    :.
                              ,'                                           `:.
         SUDDENLY,            )`~                    (  `                   `:.
         A MIGHTY CAVE       ,^        ;              \                      ::
         BEAR APPEARS       r  ,~^,    ,_             )  ,         ,         ::
                            `~^ ,',--'"' `j          /            ,         ,:'
                               `''        (         /   ;        ,        ,.:`
         It kicks the ground              :        ;             ;       ..;'
         and charges. Brace yourself.     ;'      ;~--'.~^~-__..;      .;'
                                          `:    ;\   .;         .:    ,;  \
                                          .;   ;  ;   :         :.   ./    \
                                       _,'    ;  _;  ;           :.   : `   }
                                    ,;'_..__,' .;_._}          ,,::.:-'"--~'
EOT
	    ;;
	"imp" ) # (wh)imp Simplified anime edition, December 2014 (0c682c5)
	cat <<"EOT"


                                                      _,^--^._
          AN YMPE SWOOPS DOWN!                ,^. ,^. \ ^..^ /,^. ,^.
                                             / ' ` ' `;  {}  '   '   \
          The imp is a common               /,     `-=/ ,  ,  }=~-  ` \
          nuisance for travellers.          Y^. ,v~^-( (  ( (,~-^~v. ,^Y
                                               y     _|`   ``|_     y
          Luckily, they are easily defeated.        (_ (   (  _)
                                                    /  /^^^^\  \
                                                    VvV      VvV


EOT
	    ;;
	*)  Die "${FUNCNAME}: Bad ARG >>>$1<<<" ;;
    esac
    echo "$HR"
}

# BACKUPS or SKETCHES
#
#	"imp" ) # Original imp October 2014 (f8292a2)
#    cat <<"EOT"
#
#
#                                                         __,__,
#                                                     ,-. \   (__,
#         AN YMPE SWOOPS DOWN!                       ;- 7) )     (
#                                                    `~.  \/  _ _ (
#         The imp is a common                    ,,~._,-.  ,^y Y Y
#         nuisance for travellers.                 ``-~_?  l
#                                                     (_  ,'
#         Luckily, they are easily defeated.           _;((
#
#
#EOT
#	    ;;

#                                                                      #
#                                                                      #
########################################################################
########################################################################
#                          ASCII places                                #
#                          (cc-version)                                #

#-----------------------------------------------------------------------
# GX_Place()
# Display scenario GFX and define place name for MapNav() and DisplayCharsheet()
# Arguments: $SCENARIO(char)
# Used: NewSector(), MapNav()
#-----------------------------------------------------------------------
GX_Place() {
    clear
    case "$1" in
	H ) PLACE="Home" ;
	    cat <<"EOT"
                                                     ___________(  )_
                                                    /   \      (  )  \
                                                   /     \     |`|    \
                                                  /   _   \      ~ ^~  \ ~ ^~
         MY HOME IS MY CASTLE                    /|  |.|  |\___ (     ) (     )
                                                  |  | |  |    ( (     ) (     )
         You are safe here                   """"""";::;"""""""(    )  )    )  )
         and fully healed.                        ,::;;.        (_____) (_____)
                                                 ,:;::;           | |     | |
                                               ;:;:;:;            | |     | |
                                            ,;;;;;;;,            """""  """"""

EOT
	    ;;
	x ) PLACE="Mountain" ;
	    cat <<"EOT"


                                           ^^      /\  /\_/\/\
         YOU'RE TRAVELLING IN           ^^     _  /~~\/~~\~~~~\
         THE MOUNTAINS                        / \/    \/\      \
                                             /  /    ./  \ /\   \/\
         The calls of the wilderness  ............:;'/    \     /
         turn your blood to ice        '::::::::::; /




EOT
	    ;;
	. ) PLACE="Road" ;
	    cat <<"EOT"
                             /V/V7/V/\V\V\V\
                            /V/V/V/V/V/V/V\V\                ,      ^^
                           /7/V/V/V###V\V\V\V\    ^^      , /X\           ,
                                   ###     ,____________ /x\ T ____  ___ /X\ ___
         ON THE ROAD AGAIN         ###   ,-               T        ; ;    T
                              ____ ### ,-______  ., . . . . , ___.'_;_______
         Safer than the woods      ###        .;'          ;                \_
         but beware of robbers!            .:'            ;                   \
                                        .:'              ;   ___               `
                                *,    .:'               .:  | 3 |
                               `)    :;'                :; '"""""'
                                   .;:                   `::.
EOT
	    ;;
	T ) PLACE="Town" ;
	    cat <<"EOT"
                                                           ___
                                                          / \_\   town house
                                 zig's inn                | | |______
         YOU HAVE REACHED   ______________________________| | |\_____\____
         A PEACEFUL TOWN   |\| | | | _|_|_| | | |/\____\ .|_|_|______| | |\
                            |\   _  /\____\  ....||____| :........  ____  |\
         A warm bath and     |  [x] ||____|  :   _____ ..:_____  : /\___\  |\
         cozy bed awaits    ........:        :  /\____\  /\____\ :.||___|   |\
         the weary traveller   |\   :........:..||____|  ||____|             |\
                                ||==|==|==|==|==|==|==|==|==|==|==|==|==|==|==|


EOT
	    ;;
	@ ) PLACE="Forest" ;
	    cat <<"EOT"
                                                                    /\
                                                                   //\\
                                        /\  /\               /\   /\/\/\
                                       /  \//\\             //\\ //\/\\/\
         YOU'RE IN THE WOODS          /    \^#^\           /\/\/\/\^##^\/\
                                     /      \#            //\/\\/\  ##
         It feels like something    /\/^##^\/\        .. /\/^##^\/\ ##
         is watching you ..             ##        ..::;      ##     ##
                                        ##   ..::::::;       ##
                                       ....::::::::;;        ##
                                   ...:::::::::::;;
                                ..:::::::::::::::;
EOT
	    ;;
	C ) PLACE="Oldburg Castle" ;
	    cat <<"EOT"
                             __   __   __                         __   __   __
                            |- |_|- |_| -|   ^^                  |- |_|- |_|- |
                            | - - - - - -|                       |- - - - - - |
                             \_- - - - _/    _       _       _    \_ - - - -_/
         O L D B U R G         |- - - |     |~`     |~`     |~`     | - - -|
         C A S T L E           | - - -|  _  |_   _  |_   _  |_   _  |- - - |
                               |- - - |_|-|_|-|_|-|_|-|_|-|_|-|_|-|_| - - -|
         Home of The King,     | - - -|- - - - - -_-_-_-_- - - - - -|- - - |
         The Royal Court and   |- - - | - - - - //        \ - - - - | - - -|
         other silly persons.  | - - -|- - - - -||        |- - - - -|- - - |
                               |- - - | - - - - ||        | - - - - | - - -|
                               | - - -|- - - - -||________|- - - - -|- - - |
                               |- - - | - - - - /        /- - - - - | - - -|
                               |_-_-_-_-_-_-_-_/        /-_-_-_-_-_-_-_-_-_|
                                              7________/
EOT
	    ;;
	Z | * ) CustomMapError;;
    esac
    echo "$HR"
}
#                                                                      #
#                                                                      #
########################################################################

########################################################################
#                                                                      #
#                                                                      #

#-----------------------------------------------------------------------
# GX_BiaminTitle()
# Used: GX_Banner(), GX_Credits(), GX_HowTo(), CleanUp(), License()
#-----------------------------------------------------------------------
GX_BiaminTitle() {
    clear
    cat <<"EOT"
            ______
          (, /    )       /)     ,                    ,
            /---(  _   _ (/_      __     _     ___     __      _/_  _
         ) / ____)(_(_(__/(__  _(_/ (_  (_(_   // (__(_/ (_(_(_(___(/_
        (_/ (
EOT
}

#-----------------------------------------------------------------------
# GX_Banner()
#-----------------------------------------------------------------------
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

#-----------------------------------------------------------------------
# GX_HighScore()
# Used: HighScore()
#-----------------------------------------------------------------------
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

#-----------------------------------------------------------------------
# GX_LoadGame()
#-----------------------------------------------------------------------
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

#                                                                      #
#                                                                      #
########################################################################

########################################################################
#                       Marketplace-related ASCII                      #
#                             (cc-version)                             #

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

#-----------------------------------------------------------------------
# GX_Marketplace_Grocer()
# Display Grocer ASCII. If $1 and $2 also display prices for FOOD and
# TOBACCO.
# Arguments: (optional) $PRICE_FxG(float), $PRICE_FxT(float).
#-----------------------------------------------------------------------
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
    if [[ "$@" ]] ; then # if args
	tput sc                                            # save cursor position
	[[ "$1" ]] && MvAddStr 10 4 "1 FOOD costs $1 Gold" # move to y=10, x=4 ( upper left corner is 0 0 )
	[[ "$2" ]] && MvAddStr 11 4  "or $2 Tobacco.\""    # move to y=11, x=4 ( upper left corner is 0 0 )
	tput rc                                            # restore cursor position
    fi
    Marketplace_Statusline
}


#-----------------------------------------------------------------------
# GX_Marketplace_Merchant()
# (Goatee == dashing, not hipster)
# Used: Marketplace_Merchant()
#-----------------------------------------------------------------------
GX_Marketplace_Merchant() {
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
    Marketplace_Statusline
}


#-----------------------------------------------------------------------
# GX_Marketplace_Beggar()
# Used: Marketplace_Beggar()
#-----------------------------------------------------------------------
GX_Marketplace_Beggar() {
    clear
    cat <<"EOT"

                                                                 /;        |
            THE OLD BEGGAR                                      //    \    |
                                                               /,mn-.      |
                                                              /,-'|'l    \ |
                                                             / ~ 'j||;     |
                                              ______   ,._ _//_"W|'|' `.   |
                                              \____;)=|   ` ` ```j|j|` :   |
                                                  `'' |   ,,,,._    j; ; \ |
                                                      |,~' `-. ';`-.   :   |
                                                     /  ,     `v      ';   |
                                                    / ,                | \ |
                                                 _ /__    ,-~~.        ;   |
                                               ,'_||_;`._;     `-__ _ ,'\  |
                                                                         \_|
EOT
    echo "$HR"
}


#-----------------------------------------------------------------------
# GX_Marketplace_Recruiter()
# Used: Marketplace_Recruiter()
# PLACEHOLDER
#-----------------------------------------------------------------------

#                                                                      #
#                                                                      #
########################################################################
########################################################################
#                             GX_DiceGame                              #
#                   GX for MiniGameDice (cc-version)                   #

#-----------------------------------------------------------------------
# GX_DiceGame_Table()
# Display ASCII for game table or empty table if $1 == 0
# Arguments: $DGAME_PLAYERS(int)
#-----------------------------------------------------------------------
GX_DiceGame_Table() {
    clear
    case "$1" in
	0 ) # Empty table, come back later
	    cat <<"EOT"



                           ________
                          ||       |       ~.
                   _______ll_______l_______||______________
                  :\  __   __  _   _____ ,-jl-. _  _____   \
                  ':\  ____  _   ____   _`~--~' ___    ___  \
                  |':\_______________________________________\
                  ||'L.______________________________________]
EOT
        ;;
	* )
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
	    ;;
    esac
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

#                                                                      #
#                                                                      #
########################################################################

########################################################################
#                  Menu GX used in GPL and CC versions                 #
#                                                                      #

# Horizontal ruler used almost everywhere in the game
HR="- ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ "

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

#                                                                      #
#                                                                      #
########################################################################


########################################################################
#                               Almanac                                #
#                                                                      #

# TODO Adjust Almanac_Moon etc. for -1 Y positions (moved ASCII upwards, Jan 2015)

# GAME ACTION: USE INV_ALMANAC (MOON info, NOTES, MAIN info)
Almanac_Moon() { # Used in Almanac()
    GX_CharSheet 2 # Display GX Header with ALMANAC header
    # Substitute "NOTES" with MOON string in banner
    tput sc
    case "${MOON_STR[$MOON]}" in
	"Full Moon" | "New Moon" | "Old Moon" )                    MvAddStr 5 27 " ${MOON^^} "                  ;;
	"First Quarter" | "Third Quarter")                         MvAddStr 5 16 "THE MOON IS IN THE ${MOON^^}" ;;
	"Waning Gibbous" | "Growing Gibbous" | "Waning Crescent" ) MvAddStr 5 25 "${MOON^^}"                    ;;
	"Growing Crescent" )                                       MvAddStr 5 24 "${MOON^^}"                    ;;
    esac
    tput rc

    GX_Moon # Draw Moon

    # Add "picture frame" ASCII to Moon
    local VERTI_FRAME="||"
    local HORIZ_FRAME="_______________________"
    tput sc
    MvAddStr  9 50 "$HORIZ_FRAME"
    MvAddStr 10 48 ".j                       l." # spaces rem "Full Moon" dots..
    for framey in {11..18} ; do
	MvAddStr $framey 48 "$VERTI_FRAME"
	MvAddStr $framey 73 "$VERTI_FRAME"
    done
    tput cup 19 49 && echo -n "l" && echo -n "$HORIZ_FRAME" && echo "j"
    if [ "$MOON" = "Full Moon" ] ; then # Remove "shiny" dots ..
	MvAddStr 20 57 "        "
	MvAddStr 11 52 " "
	MvAddStr 11 71 " "
	MvAddStr 13 50 " "
	MvAddStr 17 50 " "
	MvAddStr 17 72 " "
    fi
    tput rc

    # TODO v3 Add Left-aligned text "box" (without borders)
    # Follow template:
    # 1. Name of phase
    # 2. Mythological significance (Gods etc.)
    # 3. Normal consequences
    #      - Wildlife & people ("What stirs under a $MOON"?)
    #        e.g. People can "go crazy" + werewolves under Full Moon
    # 4. Special consequences
    #       - Abilities (e.g. +1 LUCK)
    #       - Omens (bad fortune, death, starvation)
    # 5. Relation to Wandering Moon

    echo "$HR"
    read -sn 1
} # Return to Almanac()

#-----------------------------------------------------------------------
# Almanac_Notes()
# Used: Almanac()
#-----------------------------------------------------------------------
# TODO version 3
# DONE Add creation of mktemp CHAR.notes file that is referenced in $CHARSHEET
# OR add NOTE0-NOTE9 in .sheet file.
# DONE Add opportunity to list (default action in Almanac_Notes), (A)dd or (E)rase notes.
# DONE Notes are "named" by numbers 0-9.
# DONE Notes may not exceed arbitrary ASCII-friendly length.
# DONE Notes must be superficially "cleaned" OR we can simply "list" them with cat <<"EOT".
# 	Just deny user to input EOT :)
#-----------------------------------------------------------------------
#language
Almanac_Notes() {
    local CHAR_NOTES="${GAMEDIR}/$(echo "$CHAR" | tr '[:upper:]' '[:lower:]' | tr -d " ").notes"
    local NOTES=()		                                                # Array for notes
    local i 			                                                # Counter
    GX_CharSheet 3                                                              # Display GX banner with ALMANAC header and NOTES subheader
    echo "$HR"
    if [[ ! -f "$CHAR_NOTES" ]]; then                                           # There is no $CHAR_NOTES file, so let's make it
	tput sc
	echo " In the back of your almanac, there is a page reserved for Your Notes."
	echo " There is only room for 10 lines, but you may erase obsolete information."
	echo
	echo -e "\n\n\n\n\n\n\n\n\n\n" > "$CHAR_NOTES"                          # making empty notes file
	PressAnyKey
	tput rc
	tput ed
    fi
    for i in {0..9}; do NOTES[$i]=$(sed -n "$((i + 1))p" "${CHAR_NOTES}"); done # load notes
    for i in {0..9}; do echo " $i - ${NOTES[$i]}"; done                         # display notes
    echo "$HR"
    tput sc			                                                # store cursor position
    while (true); do                                                      ### main loop
	tput rc 		                                          # restore cursor position at case if it is not first time loop
	echo -en "${CLEAR_LINE}$(MakePrompt '(A)dd;(E)rase;(Q)uit')"      # prompt
	tput ed			                                          # clear to the end of display at case if previous note was longer than 74
	case "$(Read)" in
	    [aA] ) echo -en "${CLEAR_LINE} Which one? [0-9]: ";           # prompt
		   i=$(Read);					          # read note num
		   grep -Eq '^[0-9]$' <<< "$i" || continue ;              # check if user input if int [0-9]
		   # TODO??? check if ${NOTE[$i} is emty
		   ReadLine "${CLEAR_LINE} > ";                           # read note
		   grep -Eq '^.+$' <<< "$REPLY" || continue;              # check if user input is empty
		   REPLY=$(sed -e 's/^\(.\{74\}\).*/\1/' <<< "$REPLY");   # restrict note length to 74
		   NOTES[$i]="$REPLY";                                    # store note in array
		   sed -i "$(($i + 1))s/^.*$/$REPLY/" "${CHAR_NOTES}";    # store note in file
		   MvAddStr $((9 + i)) 0 "$(tput el) $i - ${NOTES[$i]}";; # redraw note
	    [eE] ) echo -en "${CLEAR_LINE} Which one? [0-9]: ";           # prompt
		   i=$(Read);				                  # read note num
		   grep -Eq '^[0-9]$' <<< "$i" || continue                # check if user input if int [0-9]
		   NOTES[$i]="";                                          # erase note in array
		   sed -i "$(($i + 1))s/^.*$//" "${CHAR_NOTES}";          # erase note in file
		   MvAddStr $((9 + i)) 0 "$(tput el) $i - ${NOTES[$i]}";; # redraw note
	    [qQ] ) break;;
	    *    ) ;;
	esac
    done
} # Return to Almanac()

#-----------------------------------------------------------------------
# Almanac()
# Almanac (calendar).
# Used: DisplayCharsheet()
# TODO: when INV_ALMANAC=1 add NOTES 0-9 in charsheet.
#-----------------------------------------------------------------------
Almanac() {
    MakeCalendar   # Takes some time so do it first BEFORE any graphics
    GX_CharSheet 2 # Display GX banner with ALMANAC header
    # Add DATE string subheader
    ALMANAC_SUB="$(WeekdayString $WEEKDAY) $(Ordial $DAY) of $(MonthString $MONTH)"
    tput sc
    MvAddStr 5 $((32 - ( $(Strlen "$ALMANAC_SUB") / 2) )) "$ALMANAC_SUB" # centered sub
    tput rc

    # Draw graphics
    cat <<"EOT"
                                                     ringday
           Mo Be Mi Ba Me Wa Ri              washday    o    moonday
                                                     o . . o
                                         melethday  o . x . o  brenday
                                                     o . . o
                                             braigday   o   midweek
                                                       .^.


EOT
    # Draw ALREADY maked calendar
    tput sc
    for ((i = 0; ; i++)) ; do
	[[ "${CALENDAR[i]}" ]] || break
	MvAddStr $((10 + $i)) 10 "${CALENDAR[i]}"
    done
    tput rc

    # Add MONTH HEADER to CALENDAR
    tput sc
    local CAL_MONTH_HEADER=$(MonthString $MONTH)
    case $(Strlen $(MonthString "$MONTH")) in
	18 | 17 ) MvAddStr 8 13 "${CAL_MONTH_HEADER^}" ;;
	13      ) MvAddStr 8 14 "${CAL_MONTH_HEADER^}" ;;
	12 | 11 ) MvAddStr 8 15 "${CAL_MONTH_HEADER^}" ;;
	10 | 9  ) MvAddStr 8 16 "${CAL_MONTH_HEADER^}" ;;
	8       ) MvAddStr 8 17 "${CAL_MONTH_HEADER^}" ;;
    esac
    tput rc

    # Magnify WEEKDAY in HEPTOGRAM
    tput sc
    case "$WEEKDAY" in
	0 ) tput cup 8 53  ;; # "Ringday (Holiday)"
	1 ) tput cup 9 61  ;; # "Moonday"
	2 ) tput cup 11 63 ;; # "Brenday"
	3 ) tput cup 13 60 ;; # "Midweek"
	4 ) tput cup 13 45 ;; # "Braigday"
	5 ) tput cup 11 41 ;; # "Melethday"
	6 ) tput cup 9 45  ;; # "Washday"
    esac
    ((WEEKDAY == 0))  && echo "RINGDAY" || echo "$(Toupper $(WeekdayString "$WEEKDAY"))"
    tput rc

    # Add MOON PHASE to HEPTOGRAM (bottom)
    tput sc
    case "$MOON" in
	0 | 4 )     MvAddStr 15 52 "$(Toupper ${MOON_STR[$MOON]})" ;;
	2 | 5 | 6 ) MvAddStr 15 50 "$(Toupper ${MOON_STR[$MOON]})" ;;
	1 | 3 | 7 ) MvAddStr 15 49 "$(Toupper ${MOON_STR[$MOON]})" ;;
    esac
    tput rc

    local TRIVIA_HEADER="$(WeekdayString "$WEEKDAY") - $(WeekdayTriviaShort "$WEEKDAY")" # Add DEFAULT Trivia header

    # Add PARTICULAR Trivia body
    # Database of significant constellations of dates, months and phases

    # CUSTOM Powerful combinations (may overrule the above AND have gameplay consequences)
    case "$DAY+$MONTH_REMINDER+$MOON" in
	"12+12+Full Moon" ) local TRIVIA1="Very holy" && local TRIVIA2="Yes, indeed. [+1 LUCK]" ;;
    esac
    # TODO IDEA These powerful combos can adjust things like luck, animal attacks etc.
    # TODO make custom trivia a separate function instead..

    if [ -z "$TRIVIA1" ] && [ -z "$TRIVIA2" ] ; then
	case "$(WeekdayString $WEEKDAY)+$MOON" in #  $MOON is int [0-9] so this check will fall every time #kstn
	    "Moonday+Full Moon" ) local TRIVIA1="A Full Moon on Moon's day is considered a powerful combination." ;;
	    "Moonday+Waning Crescent" ) local TRIVIA1="An aging Crescent on Moon's Day makes evil magic more powerful." ;;
	    "Brenday+New Moon" )  local TRIVIA1="New Moon on Brenia's day means your courage will be needed." ;;
	    "Midweek+Old Moon" )  local TRIVIA1="An old moon midweek is the cause of imbalance. Show great care." ;;
	    "Ringday (Holiday)+New Moon" ) local TRIVIA1="New Moon on Ringday is a blessed combination. Be joyeful!" ;;
	    * ) local TRIVIA1=$(WeekdayTriviaLong "$WEEKDAY") ;;                     # display default info about the day
	esac

	# CUSTOM Month and Moon combinations (TRIVIA2)
	case "$(MonthString $MONTH)+$MOON" in #  $MOON is int [0-9] so this check will fall every time #kstn
	    "Harvest Month+Growing Crescent" ) local TRIVIA2="A Growing Crescent in Harvest Month foretells a Good harvest!" ;;
	    "Ringorin+Old Moon" ) local TRIVIA2="An Old Moon in Ringorin means the ancestors are watching. Tread Careful." ;;
	    "Ringorin+New Moon" ) local TRIVIA2="A New Moon in Ringorin is a good omen for the future if the aim is true." ;;
	    "Marrsuckur+Waning Crescent" ) local TRIVIA2="A crescent declining during Marrow-sucker sometimes foretell Starvation." ;;
	    * ) local TRIVIA2="$(MonthString $MONTH) - $(MonthTrivia $MONTH)" ;; # display default info about the month
	esac
    fi

    # Output Trivia (mind the space before sentences)
    echo -e " $TRIVIA_HEADER\n $TRIVIA1\n\n $TRIVIA2"
    echo "$HR"

    if [[ "$DEBUG" ]] ; then
	MakePrompt '(M)oon phase;(N)otes;(R)eturn'
	case "$(Read)" in
	    [mM] ) Almanac_Moon  ;;
    	    [nN] ) Almanac_Notes ;;
	esac
    else
	PressAnyKey '(R)eturn' # TODO change/update when features are ready
    fi
} # Return to DisplayCharsheet()


#                                                                      #
#                                                                      #
########################################################################
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

########################################################################
#                             Date                                     #
#                                                                      #

# Year has 360 days ( 12 monthes x 30 days)
# Weekday has 7 days
# One moon phase has 4 days
# Moon has 8 phases
# Moon month has 32 days

# Declare global calendar variables (used in DateFromTurn(),Almanac() and MakeCalendar())

declare -r MONTH_LENGTH=30                              # How many days are in month?
declare -r YEAR_MONTHES=12                              # How many monthes are in year?
declare -r YEAR_LENGHT=$((MONTH_LENGTH * YEAR_MONTHES)) # How many days are in year?
declare -r MOON_PHASE_LENGTH=4                          # How many days one Moon Phase lenghts
declare -r MOON_CYCLE=$((MOON_PHASE_LENGTH * 8))        # How many days are in moon month? (8 phases * $MOON_PHASE_LENGTH) ATM == 32.

# Moon Phases names
declare -r MOON_STR=("New Moon" "Growing Crescent" "First Quarter" "Growing Gibbous" "Full Moon" "Waning Gibbous" "Third Quarter" "Waning Crescent")

# Month names and trivia
declare -r -a MONTH_STR=(
    # Month name         # Month trivia
    "Biamin Festival"    "Rarely happens, if ever :(" # Arrays numeration starts from 0, so we need dummy ${MONTH_LENGTH[0]}
    "After-Frost"        "1st Month of the Year\n This is the coldest and darkest month of the year. Stay in, stay warm."
    "Marrsuckur"         "2nd Month of the Year\n \"Marrow-sucker\" is a lean month. Some nobles have a custom of fasting."
    "Plough-Tide"        "3rd Month of the Year\n Farmers return to their ploughs. Hobbit villages celebrate Springtide."
    "Anorlukis"          "4th Month of the Year\n The winter darkness is overwon by Anor's arrows. Holy month for Elves."
    "Summer-Tide"        "5th Month of the Year\n Middle of year. While the heat is welcoming, watch out for orcs and goblins!"
    "Summer-Turn"        "6th Month of the Year\n A celebration of the Turn of Anor, in which one gives thanks for any good."
    "Merentimes"         "7th Month of the Year\n From 'Meren' (happiness). This warm month is oft celebrated by travellers."
    "Harvest Month"      "8th Month of the Year\n Autumn is the busiest time of year. And evil grows in the wilderness."
    "Ringorin"           "9th Month of the Year\n From 'Ringorn' (circle, life, produce). Holy month for farmers."
    "Brew-Tasting Tide"  "10th Month of the Year\n Traditional tasting of ales begin this month. Don't venture about alone."
    "Winter Month"       "11th Month of the Year\n By now the stocks are full of produce. Livestock & people shelter in."
    "Midwinter Offering" "12th Month of the Year\n The Offering is a significant and holy event for priests and people alike."
)

#-----------------------------------------------------------------------
# Month*()
# Returns $MONTH name and trivia.
# Arguments: $MONTH(int [0-11])
# TODO: add check for $1 size
# TODO: add return current $MONTH name\trivia if [[ ! "$1" ]]
#-----------------------------------------------------------------------
MonthString()      { echo ${MONTH_STR[((  $1 * 2      ))]} ;} # Return month $1 name
MonthTrivia()      { echo ${MONTH_STR[(( ($1 * 2) + 1 ))]} ;} # Return month $1 trivia

declare -r WEEK_LENGTH=7 # How many days are in week?
declare -r -a WEEKDAY_STR=(
    # Weekday           # Short trivia                        # Long trivia
    "Ringday (Holiday)" "Day of Festivities and Rest"         "Men and Halflings celebrate Ringday as the end and beginning of the week."
    "Moonday"           "Mor's Day (Day of the Moon)"         "Elves and Dwarves once celebrated Moon Day as the holiest. Some still do."
    "Brenday"           "Brenia's Day (God of Courage)"       "Visit the Temple on Brenia's Day to honor those who perished in warfare."
    "Midweek"           "Middle of the Week (Day of Balance)" "In some places, Midweek Eve is celebrated with village dances and ale."
    "Braigday"          "Braig's Day (God of Wilderness)"     "Historically, a day of hunting. Nobility still hunt every Braig's Day."
    "Melethday"         "Melethril's Day (God of Love)"       "Commonly considered Lovers' Day, it is also a day of mischief and trickery."
    "Washday"           "Final Workday of the Week"           "Folk name for Lanthir's Day, the God of Water, Springs and Waterfalls."
)

#-----------------------------------------------------------------------
# Weekday*()
# Returns $WEEKDAY name, short and long trivia.
# Arguments: $WEEKDAY(int [0-6])
# TODO: add check for $1 size
# TODO: add return current $WEEKDAY name\trivia if [[ ! "$1" ]]
#-----------------------------------------------------------------------
WeekdayString()      { echo ${WEEKDAY_STR[((  $1 * 3      ))]} ;} # Return weekday $1 name
WeekdayTriviaShort() { echo ${WEEKDAY_STR[(( ($1 * 3) + 1 ))]} ;} # Return weekday $1 short trivia
WeekdayTriviaLong()  { echo ${WEEKDAY_STR[(( ($1 * 3) + 2 ))]} ;} # Return weekday $1 long trivia

#-----------------------------------------------------------------------
# TurnFromDate()
# Get $TURN from current (real) date. Real date used only as seed for
# internal date
# IDEA: rename to Creation() ?
#-----------------------------------------------------------------------
TurnFromDate() {
    local YEAR MONTH DAY
    read -r "YEAR" "MONTH" "DAY" <<< "$(date '+%-y %-m %-d')"
    bc <<< "($YEAR * $YEAR_LENGHT) + ($MONTH_LENGTH * $MONTH) + $DAY"
}

#-----------------------------------------------------------------------
# DateFromTurn()
# Get intenal (biamin) date from turn
# Arguments: $TURN(int)
#-----------------------------------------------------------------------
DateFromTurn() { # Some vars used in Almanac(
    # The thought was originally: century, cycle, age.. Table it for now (sigge)
    # By atm age == cycle as I understand it. Isn't it right? (kstn)

    # get date
    YEAR=$(bc <<< "$TURN / $YEAR_LENGHT")                       # Find out which YEAR we're in
    CENTURY=$(bc <<< "($YEAR / 100) + 200" )                    # Find out which CENTURY we're in (We start in year 2nn, actually :) )
    ((YEAR >= 100)) && YEAR=$(bc <<< "$YEAR % 100")             # Cut down years more than 100
    local REMAINDER=$(bc <<< "$TURN % $YEAR_LENGHT")            # Month + days
    MONTH=$(bc <<< "$REMAINDER / $MONTH_LENGTH")                # Find out which MONTH we're in   # 0-11
    DAY=$(bc <<< "$REMAINDER % $MONTH_LENGTH")                  # Find out which DAY we're in     # 0-29
    WEEKDAY=$( bc <<< "$TURN % $WEEK_LENGTH" )                  # Find out which WEEKDAY we're in # 0-6
    MOON=$(bc <<< "($TURN % $MOON_CYCLE) / $MOON_PHASE_LENGTH") # Find out current Moon Phase     # 0-7

    # Fix date (AFTER getting MONTH, DAY, etc !!!)
    ((DAY++))
    ((MONTH++))
    ((YEAR++))

    # Output example "3rd of Year-Turn in the 13th cycle"
    BIAMIN_DATE_STR="$(Ordial $DAY) of $(MonthString $MONTH) in the $(Ordial $YEAR) Cycle"
}

# Global variable for calendar
CALENDAR=()

#-----------------------------------------------------------------------
# MakeCalendar()
# Full calendar array like
# ---
# CALENDAR=(
#     "                 1  2"
#     "  3  4  5  6  7  8  9"
#     " 10 11 12 13 14 15 16"
#     " 17 18 19 20 21 22 23"
#     " 24 25 26 27 28 29 30"
# )
# ---
# Array can be displayed this way:
# ---
# i=0
# while [[ "${CALENDAR[i]}" ]]; do
#     echo "${CALENDAR[$((i++))]}"
# done
# ---
# or
# ---
# for ((i = 0; ; i++)) ; do
#     [[ "${CALENDAR[i]}" ]] || break
#     MvAddStr $(($y + $i)) $x "${CALENDAR[i]}"
# done
# ---
#-----------------------------------------------------------------------
MakeCalendar() {
    local a=0 i
    CALENDAR=()                                                                # Reset old calendar
    local FIRSTDAY=$((TURN - DAY + 1))                                         # Find 1st day of month. NB DAYS are 0-29
    FIRSTDAY=$( bc <<< "$FIRSTDAY % $WEEK_LENGTH" )                            # Find which day of week is FIRSTDAY. NB 0 is Sunday !!!
    ((FIRSTDAY == 0)) && FIRSTDAY=7                                            # Fix Sunday from 0 to 7
    ((FIRSTDAY > 1)) && CALENDAR[a]=$(printf "%$(((FIRSTDAY - 1) * 3 ))c" " ") # Add spaces if FIRSDAY is not Monday
    for ((i = 1; i <= MONTH_LENGTH; i++)) ; do                                 #  and fill Calendar array
	CALENDAR[a]+=$(printf " %2i" "$i")
	(( $(Strlen "${CALENDAR[a]}") == 21)) && ((a++))
    done
}

#                                                                      #
#                                                                      #
########################################################################
########################################################################
#                   Death and death-related functions                  #
#                                                                      #

#-----------------------------------------------------------------------
# $DEATH_* - named variables for types of Death :)
# Used: Death(), GX_Death()
#-----------------------------------------------------------------------
declare -r DEATH_FIGHT=0
declare -r DEATH_STARVATION=1

#-----------------------------------------------------------------------
# ResetStarvation()
# Reset STARVATION and restore lost ability (race-depended) after
# overcoming starvation
# Used: CheckForStarvation(), TavernRest()
#-----------------------------------------------------------------------
ResetStarvation() {
    if (( STARVATION >= 8 )) ; then
	case "$CHAR_RACE" in
	    1 | 3 ) (( STRENGTH++ ));
		    # echo "+1 STRENGTH: You restore your body to healthy condition (STRENGTH: $STRENGTH)" ;;
		    Echo "You restore your body to healthy condition" "[+1 STRENGTH]" ;;
	    2 | 4 ) (( ACCURACY++ ));
		    # echo "+1 ACCURACY: You restore your body to healthy condition (ACCURACY: $ACCURACY)" ;;
		    Echo "You restore your body to healthy condition" "[+1 ACCURACY]" ;;
	    *     ) Die "${FUNCNAME}: Bad \$CHAR_RACE >>>${CHAR_RACE}<<<" ;;
	esac
    fi
    STARVATION=0
    read -sn 1
}

#-----------------------------------------------------------------------
# CheckForStarvation()
# Food check
# Used: NewSector()
# TODO: not check for food at the 1st turn ??? Yes, skip it the 1st round, like NODICE
# TODO: make lesser sleep after successful check
#-----------------------------------------------------------------------
CheckForStarvation(){
    if (( $(bc <<< "${CHAR_FOOD} > 0") )) ; then
	CHAR_FOOD=$( bc <<< "${CHAR_FOOD} - 0.25" )
	Echo "You eat from your stock: $CHAR_FOOD remaining .." "[-.25 FOOD]"
	echo 			# empty line
	((STARVATION)) && ResetStarvation
    else
	((STARVATION++))
	# Starvation penalty -5HP per turn
	local PROMPT="You're starving on the $(Ordial "${STARVATION}") "
	case "$STARVATION" in
	    1 )  PROMPT+="day and feeling hungry .."            ;;
	    2 )  PROMPT+="day and feeling weak .."              ;;
	    3 )  PROMPT+="day and feeling weaker .."            ;;
	    4 )  PROMPT+="day and feeling weaker and weaker .." ;;
	    15 ) PROMPT+="day, slowly starving to death .."     ;;
	    * )  PROMPT+="day, you're famished .."              ;;
	esac
	# echo "-5 HEALTH: Your body is suffering from starvation .. (HEALTH: $CHAR_HEALTH)"
	# Echo "Your body is suffering from starvation .. (HEALTH: $CHAR_HEALTH)" "[-5 HEALTH]"
	(( CHAR_HEALTH -= 5 ))
	Echo "${PROMPT}" "[-5 HEALTH]"
	if (( STARVATION == 8 )); then # Extreme Starvation penalty
	    case "$CHAR_RACE" in
		1 | 3 ) (( STRENGTH-- ));
			# echo "-1 STRENGTH: You're slowly starving to death .. (STRENGTH: $STRENGTH)" ;;
			Echo "\nYou're slowly starving to death... (STRENGTH: $STRENGTH)" "[-1 STRENGTH]" ;;
		2 | 4 ) (( ACCURACY-- ));
			# echo "-1 ACCURACY: You're slowly starving to death .. (ACCURACY: $ACCURACY)" ;;
			Echo "\nYou're slowly starving to death... (ACCURACY: $ACCURACY)" "[-1 ACCURACY]" ;;
		*     ) Die "${FUNCNAME}: Bad \$CHAR_RACE >>>${CHAR_RACE}<<<" ;;
	    esac
	fi
	if (( CHAR_HEALTH <= 0 )) ; then
	    Sleep 2.5
	    Death "$DEATH_STARVATION"
	fi
	Sleep 2 # Sleep penalty when starving (game goes slower)
    fi
    Sleep 1.5 # DEBUG     # sleep 4.5 # (too slow for play-testing:)
}


#-----------------------------------------------------------------------
# Death()
# Used: FightMode()
# Arguments: $TYPE_OF_DEATH(int)
#-----------------------------------------------------------------------
Death() {
    GX_Death "$1"
    echo " The $BIAMIN_DATE_STR:"
    echo " In such a short life, this sorry $CHAR_RACE_STR gained $CHAR_EXP Experience Points."
    local COUNTDOWN=20
    while ((COUNTDOWN--)); do
	echo -en "${CLEAR_LINE}$(MakePrompt "We honor $CHAR with $COUNTDOWN secs silence.")"
    	read -sn 1 -t 1 && break
    done
    unset COUNTDOWN
    # Output example "400;Legolas;2;20;7;6;17th;Fore-Mystery;14th"
    echo "$CHAR_EXP;$CHAR;$CHAR_RACE;$CHAR_BATTLES;$CHAR_KILLS;$CHAR_ITEMS;$(Ordial $DAY);$(MonthString $MONTH);$(Ordial $YEAR)" >> "$HIGHSCORE"
    [[ -f "$CHARSHEET" ]] && rm -f "${CHARSHEET}" # A sense of loss is important for gameplay:)
    unset CHARSHEET CHAR CHAR_RACE CHAR_HEALTH CHAR_EXP CHAR_GPS SCENARIO CHAR_BATTLES CHAR_KILLS CHAR_ITEMS # Zombie fix     # Do we need it ????
    # Showing Highscore list here
    GX_HighScore  # HighScore()
    echo "" # empty line TODO fix it
    HighscoreRead 	# Show 10 highscore entries
    echo ""  # empty line TODO fix it
    PressAnyKey
    CleanUp
}

#                                                                      #
#                                                                      #
########################################################################
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
		if (( $(RollDice2 20) == 0 )) ; then
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
	Echo "${CLEAR_LINE}The $ENEMY misses!" "[D6 $DICE > Accuracy $EN_ACCURACY]"
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
########################################################################
#                           Game items                                 #
#                                                                      #

#-----------------------------------------------------------------------
# Items global constants.
# Used: ItemWasFound(), GX_Item(), FightMode_AddBonuses(),
#  FightMode_RemoveBonuses(), BiaminSetup_SetItemsAbilities()
#-----------------------------------------------------------------------
declare -r GIFT_OF_SIGHT=0
declare -r EMERALD_OF_NARCOLEPSY=1
declare -r GUARDIAN_ANGEL=2
declare -r FAST_MAGIC_BOOTS=3
declare -r QUICK_RABBIT_REACTION=4
declare -r FLASK_OF_TERRIBLE_ODOUR=5
declare -r TWO_HANDED_BROADSWORD=6
declare -r STEADY_HAND_BREW=7

declare -r MAX_ITEMS=8 # Maximum count of items

#-----------------------------------------------------------------------
# HaveItem()
# Check if player have this item
# Arguments: $ITEM(int)
#-----------------------------------------------------------------------
HaveItem() { ((CHAR_ITEMS > $1)) && return 0 || return 1; }

#-----------------------------------------------------------------------
# CheckHotzones()
# Check if this GPS is in the items array (${HOTZONE[@]})
# Arguments: $GPS(string [A-R][1-15])
# Used: HotzonesDistribute(), CheckForItem()
#-----------------------------------------------------------------------
CheckHotzones() {
    [[ $(grep -E "(^| )$1( |$)" <<< "${HOTZONE[@]}") ]] && return 0 || return 1
}

#-----------------------------------------------------------------------
# HotzonesDistribute()
# Scatters special items across the map
# Arguments: $CHAR_ITEMS(int)
# Used: ItemWasFound(), Intro()
#-----------------------------------------------------------------------
HotzonesDistribute() {
    local ITEMS_2_SCATTER=$((MAX_ITEMS - $1))                     # Scatter only absent items
    HOTZONE=()                                                    # Reset HOTZONE
    while ((ITEMS_2_SCATTER > 0)) ; do			          # If player already have all items, ITEMS_2_SCATTER'll be 0
	local ITEM_GPS=$(XYtoGPS $(RollDice2 18) $(RollDice2 15)) # Create random item GPS
	[[ "$ITEM_GPS" == "$CHAR_GPS" ]] && continue              # Reroll if HOTZONE == CHAR_GPS
	CheckHotzones "$ITEM_GPS" && continue                     # Reroll if "$ITEM" is already in ${HOTZONE[@]}
	((ITEMS_2_SCATTER--))                                     # Decrease ITEMS_2_SCATTER (because array starts from ${HOTZONE[0]} #kstn)
	HOTZONE["$ITEMS_2_SCATTER"]="$ITEM_GPS"                   # Init ${HOTZONE[ITEMS_2_SCATTER]},
    done
}

#-----------------------------------------------------------------------
# ItemWasFound()
# Display found item GX, add ability (if any), increase $CHAR_ITEMS
# and redistribute hotzones
#-----------------------------------------------------------------------
ItemWasFound() {
    GX_Item "$CHAR_ITEMS"	     # Defined in GX_Item.sh
    case "$CHAR_ITEMS" in
	"$EMERALD_OF_NARCOLEPSY" ) ((HEALING++))  ;;
	"$FAST_MAGIC_BOOTS"      ) ((FLEE++))     ;;
	"$TWO_HANDED_BROADSWORD" ) ((STRENGTH++)) ;;
	"$STEADY_HAND_BREW"      ) ((ACCURACY++)) ;;
    esac
    local COUNTDOWN=180
    while (( COUNTDOWN > 0 )); do
	echo -en "${CLEAR_LINE}                      Press any letter to continue  ($COUNTDOWN)"
	read -sn 1 -t 1 && break || ((COUNTDOWN--))
    done
    ((++CHAR_ITEMS))                 # Increase CHAR_ITEMS
    HotzonesDistribute "$CHAR_ITEMS" # Re-distribute items to increase randomness. Now it is not bugfix but feature
    SaveCurrentSheet                 # Save CHARSHEET items
    NODICE=1                         # No fighting if item is found..
}

#-----------------------------------------------------------------------
# CheckForItem()
# Calls ItemWasFound() if this GPS is in the items array ($HOTZONES[])
# Arguments: $CHAR_GPS([A-R][1-15])
# Used: NewSector()
#-----------------------------------------------------------------------
CheckForItem() { ((CHAR_ITEMS < MAX_ITEMS)) && CheckHotzones $1 && ItemWasFound ; } # TODO!!! CHECK IT!!! #kstn

#                                                                      #
#                                                                      #
########################################################################

########################################################################
#                            Main game loop                            #
#                                                                      #

#-----------------------------------------------------------------------
# GPStoXY()
# Converts $GPS(string [A-R][1-15]) to $X(int [1-18]) $Y(int)
# Arguments: $CHAR_GPS(string [A-R][1-15])
# Used: NewSector(), HotzonesDistribute()
#-----------------------------------------------------------------------
GPStoXY() {
    awk '{ print index("ABCDEFGHIJKLMNOPQR", substr($0, 1 ,1));
           print substr($0, 2); }' <<< "$1"
}

#-----------------------------------------------------------------------
# XYtoGPS()
# Converts $X(int [1-18]) $Y(int) to $GPS(string [A-R][1-15])
# Arguments: $X(int) $Y(int)
# Used: MapNav()
#-----------------------------------------------------------------------
XYtoGPS() {
    awk '{ print substr("ABCDEFGHIJKLMNOPQR", $1, 1) $2; }' <<< "$1 $2"
}

#-----------------------------------------------------------------------
# GX_Map()
# Display map and ItemToSee if player have GiftOfSight and haven't all
# items
# Used: MapNav()
#-----------------------------------------------------------------------
GX_Map() {
    local ITEM2C_Y=0 ITEM2C_X=0 # Lazy fix for awk - it falls when see undefined variable #kstn
    # Check for Gift of Sight. Show ONLY the NEXT item viz. "Item to see" (ITEM2C).
    # Remember, the player won't necessarily find items in HOTZONE array's sequence.
    # Retrieve item map positions e.g. 1-15 >> X=1 Y=15. There always will be item in HOTZONE[0]!
    HaveItem "$GIFT_OF_SIGHT" && ((CHAR_ITEMS < MAX_ITEMS)) && read -r "ITEM2C_X" "ITEM2C_Y" <<< $(GPStoXY "${HOTZONE[0]}")

    clear
    awk 'BEGIN { FS = "   " ; OFS = "   "; }
    { # place "o" (player) on map
      if (NR == '$(( MAP_Y + 2 ))') {  # lazy fix for ASCII borders
         if ('$MAP_X' == 18 ) { $'$(( MAP_X + 1 ))'="o ("; }
         else                 { $'$(( MAP_X + 1 ))'="o";   }
         }
      # if player has Gift-Of-Sight and not all items are found
      if ( '${CHAR_ITEMS}' > 0 && '${CHAR_ITEMS}' < 8) {
         # place ITEM2C on map
         # ITEM2C_Y+2 and ITEM2C_X+1 - fix for boards
 	 if (NR == '$(( ITEM2C_Y + 2 ))') {
            if ( '$ITEM2C_X' == 18 ) { $'$(( ITEM2C_X + 1 ))'="~ ("; }
            else                     { $'$(( ITEM2C_X + 1 ))'="~";   }
            }
         }
      # All color on map sets here
      if ('${COLOR}' == 1 ) {
         # Terminal color scheme bugfix
         if ( NR == 1 ) { gsub(/^/, "'$(printf "%s" "${RESET}")'"); }
         # colorise "o" (player) and "~" (ITEM2C)
	 if ( NR > 2 && NR < 19 ) {
 	    gsub(/~/, "'$(printf "%s" "${YELLOW}~${RESET}")'")
	    gsub(/o/, "'$(printf "%s" "${YELLOW}o${RESET}")'")
	    }
         }
      print; }' <<< "$MAP"
}

#-----------------------------------------------------------------------
# MapNav()
# Game action: show map and move or move directly
# Arguments: $DESTINATION(string)
# Used: NewSector()
#-----------------------------------------------------------------------
MapNav() {
    local DEST
    read -r MAP_X MAP_Y <<< $(GPStoXY "$CHAR_GPS") # Fixes LOCATION in CHAR_GPS "A1" to a place on the MapNav "X1,Y1"
    case "$1" in
	m | M ) GX_Map ;                           # If player want to see the map
	                                           # If COLOR==0, YELLOW and RESET =="" so string'll be without any colors
	    echo -e " ${YELLOW}o ${CHAR}${RESET} is currently in $CHAR_GPS ($PLACE)\n$HR" ; # PLACE var defined in GX_Place()
	    echo -n " I want to go  (W) North  (A) West  (S)outh  (D) East  (Q)uit :  " ;
	    DEST=$(Read);;
	* ) DEST="$1" ;                            # The player did NOT toggle map, just moved without looking from NewSector()..
	    # GX_Place "$SCENARIO" ;                 # Shows the _current_ scenario scene, not the destination's.
	    echo -en "${CLEAR_LINE}";              # Current scenario ASCII is already on the screen, so just clear prompt from NewSector()
    esac

    case "$DEST" in                                # Fix for 80x24. Dirty but better than nothing #kstn
	[wWnN] ) echo -n "You go North";           # Going North (Reversed: Y-1)
		 ((MAP_Y != 1 )) && ((MAP_Y--)) || echo -en "${CLEAR_LINE}You wanted to visit Santa, but walked in a circle.." ;;
	[dDeE] ) echo -n "You go East"             # Going East (X+1)
		 ((MAP_X != 18)) && ((MAP_X++)) || echo -en "${CLEAR_LINE}You tried to go East of the map, but walked in a circle.." ;;
	[sS]   ) echo -n "You go South"            # Going South (Reversed: Y+1)
		 ((MAP_Y != 15)) && ((MAP_Y++)) || echo -en "${CLEAR_LINE}You tried to go someplace warm, but walked in a circle.." ;;
	[aA]   ) echo -n "You go West"             # Going West (X-1)
		 ((MAP_X != 1 )) && ((MAP_X--)) || echo -en "${CLEAR_LINE}You tried to go West of the map, but walked in a circle.." ;;
	[qQ]   ) CleanUp ;;                        # Save and exit
	*      ) echo -n "Loitering.."
    esac
    CHAR_GPS=$(XYtoGPS "$MAP_X" "$MAP_Y")          # Translate MAP_X numeric back to A-R and store
    Sleep 1.5
}

#-----------------------------------------------------------------------
# NewSector_GetScenario()
# Get scenario char at current GPS
# Arguments: $CHAR_GPS(string[A-R][1-15])
#-----------------------------------------------------------------------
NewSector_GetScenario() {
    read -r MAP_X MAP_Y <<< $(GPStoXY "$1")                                   # Fixes LOCATION in CHAR_GPS "A1" to a place on the MapNav "X1,Y1"
    awk '{ if ( NR == '$((MAP_Y+2))') { print $'$((MAP_X+2))'; }}' <<< "$MAP" # MAP_Y+2 MAP_X+2 - padding for borders
}

#-----------------------------------------------------------------------
# NewTurn()
# Increase turn and set new date
# Used: NewSector(), TavernRest()
#-----------------------------------------------------------------------
NewTurn() {
    ((TURN++))   # Nev turn, new date
    DateFromTurn # Get year, month, day, weekday
}

#-----------------------------------------------------------------------
# NewSector()
# Main game loop
# Used in runtime section
#-----------------------------------------------------------------------
NewSector() {
    while (true); do                                          # While (player-is-alive) :)
	NewTurn                                               # Increase turn and set new date
	CheckForItem "$CHAR_GPS"                              # Look for treasure @ current GPS location
	SCENARIO=$(NewSector_GetScenario "$CHAR_GPS")         # Get scenario char at current GPS
	GX_Place "$SCENARIO"                                  # Display current $SCENARIO ASCII
	if [[ "$NODICE" ]] ; then                             # Do not attack player at the first turn of after finding item
	    unset NODICE                                      # Reset flag
	else
	    CheckForFight "$SCENARIO" || GX_Place "$SCENARIO" # Redraw $SCENARIO ASCII if there was fight
	fi
	CheckForStarvation                                    # Food check
	CheckForWorldChangeEconomy                            # Change economy if success

	while (true); do                                      # Secondary loop, at current $SCENARIO
	    GX_Place "$SCENARIO"
	    case "$SCENARIO" in                               # Determine promt
		T | C ) echo -n "     (C)haracter    (R)est    (G)o into Town    (M)ap and Travel    (Q)uit" ;;
		H )     echo -n "     (C)haracter     (B)ulletin     (R)est     (M)ap and Travel     (Q)uit" ;;
		* )     echo -n "        (C)haracter        (R)est        (M)ap and Travel        (Q)uit"    ;;
	    esac
	    local ACTION=$(Read)	                      # Read only one symbol
	    case "$ACTION" in
		[cC] ) DisplayCharsheet ;;
		[rR] ) Rest "$SCENARIO";;                     # # Player may be attacked during the rest :)
		[qQ] ) CleanUp ;;                             # Leaving the realm of magic behind ....
		[bB] ) [[ "$SCENARIO" == "H" ]] && GX_Bulletin "$BBSMSG" ;;
		[gG] ) [[ "$SCENARIO" == "T" || "$SCENARIO" == "C" ]] && GoIntoTown ;;
		*    ) MapNav "$ACTION"; break ;;             # Go to Map then move or move directly (if not WASD, then loitering :)
	    esac
	done
    done
}

#                                                                      #
#                                                                      #
########################################################################
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
	MvAddStr 6 4 "$MERCHANT_ITEM, it can be"
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

	# Create semi-random profit/discount margin in a function of VAL_CHANGE (econ. stability)
	RollDice 3
	local MERCHANT_MARGIN=$( bc <<< "scale=2;$DICE*$VAL_CHANGE" )

	# Add positive and negative margins to what the merchant wants to keep for himself
	RollDice 3
	case "$DICE" in                                                          # Merchant WANTS to buy and only reluctantly sells:
	    1 ) # Merchant wants to keep food for himself
		MERCHANT_FxG=$( bc <<< "scale=2;$MERCHANT_FxG+$MERCHANT_MARGIN" )    # Food (player's increased cost in gold purchasing food)
		MERCHANT_GxF=$( bc <<< "scale=2;$MERCHANT_GxF-$MERCHANT_MARGIN" )    # Food (player's discount in food purchasing gold)
		MERCHANT_FxT=$( bc <<< "scale=2;$MERCHANT_FxT+$MERCHANT_MARGIN" )
		MERCHANT_TxF=$( bc <<< "scale=2;$MERCHANT_TxF-$MERCHANT_MARGIN" ) ;;
	    2 ) # Merchant wants to keep tobacco for himself
		MERCHANT_TxG=$( bc <<< "scale=2;$MERCHANT_TxG+$MERCHANT_MARGIN" )    # Tobacco (player's increased cost in gold purchasing tobacco)
		MERCHANT_GxT=$( bc <<< "scale=2;$MERCHANT_GxT-$MERCHANT_MARGIN" )    # Tobacco (player's discount in tobacco purchasing gold)
		MERCHANT_TxF=$( bc <<< "scale=2;$MERCHANT_TxF+$MERCHANT_MARGIN" )
		MERCHANT_FxT=$( bc <<< "scale=2;$MERCHANT_FxT-$MERCHANT_MARGIN" ) ;;
	    3 ) # Merchant wants to keep gold for himself
		MERCHANT_GxF=$( bc <<< "scale=2;$MERCHANT_GxF+$MERCHANT_MARGIN" )    # Gold (player's increased cost in food purchasing gold)
		MERCHANT_FxG=$( bc <<< "scale=2;$MERCHANT_FxG-$MERCHANT_MARGIN" )    # Gold (player's discount in gold purchasing food)
		MERCHANT_GxT=$( bc <<< "scale=2;$MERCHANT_GxT+$MERCHANT_MARGIN" )
		MERCHANT_TxG=$( bc <<< "scale=2;$MERCHANT_TxG-$MERCHANT_MARGIN" )
		MERCHANT_GxI=$( bc <<< "scale=2;$MERCHANT_GxI+$MERCHANT_MARGIN" )     # You can only buy/sell items with gold
		MERCHANT_IxG=$( bc <<< "scale=2;$MERCHANT_IxG-$MERCHANT_MARGIN" ) ;;
	esac

	# Set any value equal or below 0 to defaults (must be done in pairs)
	(( $( bc <<< "if (${MERCHANT_FxG} <= 0) 0 else 1" ) == 0 )) && MERCHANT_FxG=$PRICE_FxG && MERCHANT_GxF=$PRICE_GxF
	(( $( bc <<< "if (${MERCHANT_GxF} <= 0) 0 else 1" ) == 0 )) && MERCHANT_GxF=$PRICE_GxF && MERCHANT_FxG=$PRICE_FxG
	(( $( bc <<< "if (${MERCHANT_FxT} <= 0) 0 else 1" ) == 0 )) && MERCHANT_FxT=$PRICE_FxT && MERCHANT_TxF=$PRICE_TxF
	(( $( bc <<< "if (${MERCHANT_TxF} <= 0) 0 else 1" ) == 0 )) && MERCHANT_TxF=$PRICE_TxF && MERCHANT_FxT=$PRICE_FxT
	(( $( bc <<< "if (${MERCHANT_GxI} <= 0) 0 else 1" ) == 0 )) && MERCHANT_GxI=$PRICE_GxI && MERCHANT_IxG=$PRICE_IxG
	(( $( bc <<< "if (${MERCHANT_IxG} <= 0) 0 else 1" ) == 0 )) && MERCHANT_IxG=$PRICE_IxG && MERCHANT_GxI=$PRICE_GxI	

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
	    b | B ) BARGAIN_TYPE=1  ;; # Buying  MERCHANDISE ($MERCHANDISE) from Merchant using MERCHANT_GxF (G
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
		"Food" )    (( BARGAIN_TYPE == 1 )) && COST_GOLD=$( bc <<< "$MERCHANT_FxG * $QUANTITY" )
			    (( BARGAIN_TYPE == 2 )) && COST_GOLD=$( bc <<< "$MERCHANT_GxF * $QUANTITY" )
			    (( BARGAIN_TYPE == 1 )) && COST_TOBACCO=$( bc <<< "$MERCHANT_FxT * $QUANTITY" )
			    (( BARGAIN_TYPE == 2 )) && COST_TOBACCO=$( bc <<< "$MERCHANT_TxF * $QUANTITY" )
			    MERCHANT_ORDER_2+="$COST_GOLD Gold or $COST_TOBACCO Tobacco."
			    ;;
		"Tobacco" ) (( BARGAIN_TYPE == 1 )) && COST_GOLD=$( bc <<< "$MERCHANT_TxG * $QUANTITY" )
			    (( BARGAIN_TYPE == 2 )) && COST_GOLD=$( bc <<< "$MERCHANT_GxT * $QUANTITY" )
			    (( BARGAIN_TYPE == 1 )) && COST_FOOD=$( bc <<< "$MERCHANT_TxF * $QUANTITY" )
			    (( BARGAIN_TYPE == 2 )) && COST_FOOD=$( bc <<< "$MERCHANT_FxT * $QUANTITY" )
			    MERCHANT_ORDER_2+="$COST_GOLD Gold or $COST_FOOD Food."
			    ;;
		"Gold" )    (( BARGAIN_TYPE == 1 )) && COST_FOOD=$( bc <<< "$MERCHANT_GxF * $QUANTITY" )
			    (( BARGAIN_TYPE == 2 )) && COST_FOOD=$( bc <<< "$MERCHANT_FxG * $QUANTITY" )
			    (( BARGAIN_TYPE == 1 )) && COST_TOBACCO=$(bc <<< "$MERCHANT_TxG * $QUANTITY" )
			    (( BARGAIN_TYPE == 2 )) && COST_TOBACCO=$(bc <<< "$MERCHANT_GxT * $QUANTITY" )
			    MERCHANT_ORDER_2+="$COST_FOOD Food or $COST_TOBACCO Tobacco."
			    ;;
		"Item" )    (( BARGAIN_TYPE == 1 )) && COST_GOLD=$( bc <<< "$MERCHANT_IxG * $QUANTITY" )
			    (( BARGAIN_TYPE == 2 )) && COST_GOLD=$( bc <<< "$MERCHANT_GxI * $QUANTITY" )
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
			    (( BARGAIN_TYPE == 2 )) && MERCHANTVAR="N"                                                                    ;; # TODO Temp workaround (have no items to sell)
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
	    #echo "        DEBUG       Summary BEFORE transaction" >2
	    #echo "        DEBUG       MERCHANDISE: $MERCHANDISE" >2
	    #echo "        DEBUG       QUANTITY:    $QUANTITY" >2
	    #echo "        DEBUG       MERCHANTVAR: $MERCHANTVAR" >2
	    #echo "        DEBUG       COST_GOLD:   $COST_GOLD" >2
	    #echo "        DEBUG       COST_TOBACCO $COST_TOBACCO" >2
	    #echo "        DEBUG       COST_FOOD:   $COST_FOOD" >2
	    #echo "        DEBUG       COST_ITEM:   $COST_ITEM" >2
	    #echo "        DEBUG       TRANSACTION: $TRANSACTION_STATUS" >2
	    #echo "        DEBUG       CHAR_TOBAC:  $CHAR_TOBACCO" >2
	    #echo "        DEBUG       CHAR_GOLD:   $CHAR_GOLD" >2
	    #echo "        DEBUG       CHAR_FOOD:   $CHAR_FOOD" >2
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
	    #echo "        DEBUG       Summary AFTER transaction" >2
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
    if [ -z "$GAMETABLE" ] || [ "$GAMETABLE" != "$CHAR_GPS" ] ; then 
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
    echo -e "\nYou put down $DGAME_STAKES Gold and pull out a chair .. [ -$DGAME_STAKES Gold ]"
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

########################################################################
#                                                                      #
#                          1. FUNCTIONS                                #
#                    All program functions go here!                    #


#-----------------------------------------------------------------------
# CustomMapError()
# PRE-CLEANUP tidying function for buggy custom maps
# Used: MapCreate(), GX_Place(), NewSector()
# Arguments: $ERROR_MAP (string[/path/to/map.map])
#-----------------------------------------------------------------------
CustomMapError() {
    clear
    echo "Whoops! There is an error with your map file!
Either it contains unknown characters or it uses incorrect whitespace.
Recognized characters are: x . T @ H C
Please run game with --map argument to create a new template as a guide.

What to do?
1) rename $1 to ${1}.error or
2) delete template file CUSTOM.map (deletion is irrevocable)."
    echo -n "Please select 1 or 2: "
    case "$(Read)" in
	1 ) mv "${1}" "${1}.error" ;
	    echo -e "\nCustom map file moved to ${1}.error" ;;
	2 ) rm -f "${1}" ;
	    echo -e "\nCustom map deleted!" ;;
	* ) Die "\nBad option! Quitting.." ;;
    esac
    Sleep 4
}


#-----------------------------------------------------------------------
# SaveCurrentSheet()
# Saves current game values to CHARSHEET file (overwriting)
#-----------------------------------------------------------------------
SaveCurrentSheet() {
    echo "VERSION: $VERSION
CHARACTER: $CHAR
RACE: $CHAR_RACE
BATTLES: $CHAR_BATTLES
EXPERIENCE: $CHAR_EXP
LOCATION: $CHAR_GPS
HEALTH: $CHAR_HEALTH
ITEMS: $CHAR_ITEMS
KILLS: $CHAR_KILLS
HOME: $CHAR_HOME
GOLD: $CHAR_GOLD
TOBACCO: $CHAR_TOBACCO
FOOD: $CHAR_FOOD
BBSMSG: $BBSMSG
VAL_GOLD: $VAL_GOLD
VAL_TOBACCO: $VAL_TOBACCO
VAL_CHANGE: $VAL_CHANGE
STARVATION: $STARVATION
TURN: $TURN
INV_ALMANAC: $INV_ALMANAC" > "$CHARSHEET"
}

#-----------------------------------------------------------------------
# Intro()
# Intro function basically gets the game going
# Used: runtime section.
#-----------------------------------------------------------------------
Intro() {
    MapCreate                        # Create session map in $MAP
    HotzonesDistribute "$CHAR_ITEMS" # Place items randomly in map
    WORLDCHANGE_COUNTDOWN=0          # WorldChange Counter (0 or negative value allow changes)
    WorldPriceFixing                 # Set all prices
    GX_Intro 60                      # With countdown 60 seconds
    NODICE=1                         # Do not roll on first section after loading/starting a game in NewSector()
}

################### GAME SYSTEM #################

#-----------------------------------------------------------------------
# RollDice()
# Arguments: $DICE_SIZE (int)
# Used: RollForEvent(), RollForHealing(), etc
#-----------------------------------------------------------------------
RollDice() {
    DICE_SIZE=$1         # DICE_SIZE used in RollForEvent()
    DICE=$((RANDOM%$DICE_SIZE+1))
}

#-----------------------------------------------------------------------
# RollDice()
# Temp wrapper for RollDice()
# Arguments: $DICE_SIZE (int)
# Used: RollForEvent(), RollForHealing(), etc
#-----------------------------------------------------------------------
RollDice2() { RollDice $1 ; echo "$DICE" ; }

#-----------------------------------------------------------------------
# DisplayCharsheet()
# Display character sheet.
# Used: NewSector(), FightMode()
#-----------------------------------------------------------------------
DisplayCharsheet() {
    local MURDERSCORE=$(bc <<< "if ($CHAR_KILLS > 0) {scale=zero; 100 * $CHAR_KILLS/$CHAR_BATTLES } else 0" ) # kill/fight percentage
    local RACE=$(Capitalize "$CHAR_RACE_STR")   # Capitalize
    local CHARSHEET_INV_STR="$CHAR_GOLD Gold, $CHAR_TOBACCO Tobacco, $CHAR_FOOD Food" # Create Inventory string
    (( INV_ALMANAC == 1 )) && CHARSHEET_INV_STR+=", Almanac" # Add below as necessary..
    GX_CharSheet
    cat <<EOF
 Character:                 $CHAR ($RACE)
 Health Points:             $CHAR_HEALTH
 Experience Points:         $CHAR_EXP
 Current Location:          $CHAR_GPS ($PLACE)
 Number of Battles:         $CHAR_BATTLES
 Enemies Slain:             $CHAR_KILLS ($MURDERSCORE%)
 Items found:               $CHAR_ITEMS of $MAX_ITEMS
 Special Skills:            Healing $HEALING, Strength $STRENGTH, Accuracy $ACCURACY, Flee $FLEE
 Inventory:                 $CHARSHEET_INV_STR
 Current Date:              $BIAMIN_DATE_STR

EOF

    case "$INV_ALMANAC" in		                                    # Define prompt
	1) MakePrompt '(D)isplay Race Info;(A)lmanac;(C)ontinue;(Q)uit'  ;; # Player has    Almanac
	*) MakePrompt '(D)isplay Race Info;(A)ny key to continue;(Q)uit' ;; # Player hasn't Almanac
    esac
    case $(Read) in
	d | D ) GX_Races && PressAnyKey ;;
	a | A ) ((INV_ALMANAC)) && Almanac ;;
	q | Q ) CleanUp ;;
    esac
}


# GAME ACTION: REST
RollForHealing() { # Used in Rest()
    RollDice 6
    if ((DICE > HEALING)) ; then
	Echo "Rolling for healing:" "[D6 $DICE > Healing $HEALING]"
	echo -e "\n$2"
    else
	(( CHAR_HEALTH += $1 ))
	Echo "Rolling for healing:" "[D6 $DICE <= Healing $HEALING]"
	Echo "\nYou slept well and gained $1 Health." "[+${1} HEALTH]"
	# TODO add restriction to 150 HEALTH
    fi
    Sleep 2
}   # Return to Rest()

#-----------------------------------------------------------------------
# Rest()
# Game balancing can also be done here, if you think players receive
# too much/little health by resting.
# Arguments: $SCENARIO(char)
# Used: NewSector()
#-----------------------------------------------------------------------
Rest() {
    PLAYER_RESTING=1 # Set flag for FightMode()
    RollDice 100
    GX_Rest
    echo "$HR"
    CheckForFight "$1" 		# Check for fight current scenario
    if (($? == 0)); then		# no fight was
	case "$1" in
	    H ) if (( CHAR_HEALTH < 100 )); then
		    CHAR_HEALTH=100
		    echo "You slept well in your own bed. Health restored to 100."
		else
		    echo "You slept well in your own bed, and woke up to a beautiful day."
		fi
		;;
	    x ) RollForHealing 5  "The terrors of the mountains kept you awake all night.." ;;
	    . ) RollForHealing 10 "The dangers of the roads gave you little sleep if any.." ;;
	    T ) RollForHealing 15 "The vices of town life kept you up all night.." ;;
	    @ ) RollForHealing 5  "Possibly dangerous wood owls kept you awake all night.." ;;
	    C ) RollForHealing 35 "Rowdy castle soldiers on a drinking binge kept you awake.." ;;
	esac
	NewTurn 		# Increase turn if there was no fight
    fi
    unset PLAYER_RESTING # Reset flag
    Sleep 2
}   # Return to NewSector()

# THE GAME LOOP

#-----------------------------------------------------------------------
# RollForEvent()
# Arguments: $DICE_SIZE(int), $EVENT(string)
# Used: Rest(), CheckForFight()
#-----------------------------------------------------------------------
RollForEvent() {
#    echo -e "Rolling for $2: D${DICE_SIZE} <= $1\nD${DICE_SIZE}: $DICE"
    # Sleep 1.5
    # (( DICE <= $1 )) && return 0 || return 1
    if (( DICE <= $1 )); then
	Echo "${CLEAR_LINE}Rolling for $2:" "[D${DICE_SIZE} $DICE <= $1]"
	echo 			# empty line
	Sleep 1.5
	return 0
    else
	Echo "${CLEAR_LINE}Rolling for $2:" "[D${DICE_SIZE} $DICE > $1]"
	echo 			# empty line
	Sleep 1.5
	return 1
    fi
    
}

#-----------------------------------------------------------------------
# CheckBiaminDependencies()
# Checks needed programs
# Used: CoreRuntime.sh, ParseCLIarguments()
#-----------------------------------------------------------------------
CheckBiaminDependencies() {
    declare -a CRITICAL NONCRITICAL
    local PROGRAM
    echo "Checking dependencies..."

    # Check BASH version (we don't need it now, but will need after 2.0 #kstn) 
    # (( "${BASH_VERSINFO[0]}" < 4)) && Die "Biamin requires BASH version >= 4 to run (atm $BASH_VERSION)"
    
    # CRITICAL
    for PROGRAM in "tput" "awk" "bc" "sed" "printf" "date" # "critical program 1" "critical program 2"
    do
	IsInstalled "$PROGRAM" || CRITICAL+=("$PROGRAM")
    done
    # NONCRITICAL
    for PROGRAM in "curl" "wget" # "non-critical program 1" "non-critical program 2"
    do
	IsInstalled "$PROGRAM" || NONCRITICAL+=("$PROGRAM")
    done

    if [[ "${CRITICAL[*]}" || "${NONCRITICAL[*]}" ]]; then
	echo -e "\nIn order to play 'Back in a Minute', please install:"
	for ((i = 0; ; i++)); do
	    [[ "${CRITICAL[i]}" ]] || break
	    echo -e "\tRequired:\t${CRITICAL[i]}";
	done

	for ((i = 0; ; i++)); do
	    [[ "${NONCRITICAL[i]}" ]] || break
	    echo -e "\tOptional:\t${NONCRITICAL[i]}";
	done

	[[ "${CRITICAL[*]}" ]] && Die || read -sn 1
    fi

    # Check screen size (80x24 minimum)
    (( $(tput cols) > 79 && $(tput lines) > 23)) || Die "Biamin requires at least a 24x80 screen to run on (atm $(tput lines)x$(tput cols))."
    # TODO update old saves

    unset CRITICAL NONCRITICAL PROGRAM
}

#-----------------------------------------------------------------------
# ColorConfig()
# Define colors and escape sequences
# Arguments: $COLOR (int)
#-----------------------------------------------------------------------
ColorConfig() {
    case "$1" in
	1 ) echo "Enabling color for maps!" ;;
	0 ) echo "Enabling old black-and-white version!" ;;
	* ) echo -en "\nWe need to configure terminal colors for the map!
Please note that a colored symbol is easier to see on the world map.
Back in a minute was designed for white text on black background.
Does \033[1;33mthis text appear yellow\033[0m without any funny characters?
Do you want color? [Y/N]: "
	    case $(Read) in
		n | N ) COLOR=0 ; echo -e "\nDisabling color! Edit $GAMEDIR/config to change this setting.";;
		* )     COLOR=1 ; echo -e "\nEnabling color!" ;;
	    esac
	    # BUG! Falls in OpenBSD. TODO replace to awk. #kstn
	    sed -i"~" "/^COLOR:/s/^.*$/COLOR: $COLOR/g" "$GAMEDIR/config" # MacOS fix http://stackoverflow.com/questions/7573368/in-place-edits-with-sed-on-os-x
	    Sleep 2;;
    esac
    if ((COLOR == 1)) ; then
	declare -gr YELLOW='\033[1;33m' # Used in MapNav() and GX_Map()
	declare -gr RESET='\033[0;39m'  # -g global, usual declare declares local variable
    fi
    # Define escape sequences
    # TODO replace to tput or similar
    declare -gr CLEAR_LINE="\e[1K\e[80D" # \e[1K - erase to the start of line \e[80D - move cursor 80 columns backward
}
#                           END FUNCTIONS                              #
#                                                                      #
#                                                                      #
########################################################################

########################################################################
#                            Parse Console Args                        #
#                                                                      #

#-----------------------------------------------------------------------
# CLI_CreateCustomMapTemplate()
# Map template generator (CLI arg function)
#-----------------------------------------------------------------------
CLI_CreateCustomMapTemplate() {
    echo -n "Create custom map template? [Y/N]: "
    case $(Read) in
	y | Y) echo -e "\nCreating custom map template.." ;;
	*)     echo -e "\nNot doing anything! Quitting.." ;
	       Exit 0 ;;
    esac

    cat <<"EOT" > "${GAMEDIR}/CUSTOM_MAP.template"
NAME: Despriptive name of map goes here
CREATOR: Name of the map creator
DESCRIPTION: Short and not exceeding 50 chars
START LOCATION: Where person'll start?
MAP:
       A | B | C | D | E | F | G | H | I | J | K | L | M | N | O | P | Q | R
   #=========================================================================#
 1 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
 2 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
 3 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
 4 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
 5 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
 6 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
 7 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
 8 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
 9 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
10 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
11 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
12 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
13 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
14 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
15 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
   #=========================================================================#
          LEGEND: x = Mountain, . = Road, T = Town, @ = Forest         N
                  H = Home (Heal Your Wounds) C = Oldburg Castle     W + E
                                                                       S
EOT
    echo "Custom map template created in $GAMEDIR/CUSTOM_MAP.template"
    echo ""
    echo "1. Change all 'Z' symbols in map area with any of these:  x . T @ H C"
    echo "   See the LEGEND in rename_to_CUSTOM.map file for details."
    echo "   Home default is $START_LOCATION. Change line 16 of CONFIG or enter new HOME at runtime."
    echo "2. Spacing must be accurate, so don't touch whitespace or add new lines."
    echo "3. When you are done, simply rename your map file to FILENAME.map"
    echo "Please submit bugs and feedback at <$WEBURL>"
    Exit 0
}

#-----------------------------------------------------------------------
# CLI_Announce()
# Simply outputs a 160 char text you can cut & paste to social media.
# TODO: Once date is decoupled from system date (with CREATION and
# DATE), create new message. E.g.  $CHAR died $DATE having fought
# $BATTLES ($KILLS victoriously) etc...
#-----------------------------------------------------------------------
CLI_Announce() {
    # Die if $HIGHSCORE is empty
    [[ ! -s "$HIGHSCORE" ]] && Die "Sorry, can't do that just yet!\nThe highscore list is unfortunately empty right now."

    echo "TOP 10 BACK IN A MINUTE HIGHSCORES"
    HighscoreRead
    ReadLine "\nSelect the highscore (1-10) you'd like to display or CTRL+C to cancel: "
    local SCORE_TO_PRINT="$REPLY"

    # Check $SCORE_TO_PRINT
    IsInt "$SCORE_TO_PRINT"                             || Die "\n${SCORE_TO_PRINT} is not int. Quitting.."
    ((SCORE_TO_PRINT < 1 || SCORE_TO_PRINT > 10 ))      && Die "\nOut of range. Please select an entry between 1-10. Quitting.."
    [[ "$(sed -n "${SCORE_TO_PRINT}"p "$HIGHSCORE")" ]] || Die "\nThere is no $(Ordial $SCORE_TO_PRINT) line in HIGHSCORE file. Quitting.."

    ANNOUNCE_ADJECTIVES=("honorable" "fearless" "courageos" "brave" "legendary" "heroic")
    ADJECTIVE=${ANNOUNCE_ADJECTIVES[RANDOM%6]}

    IFS=";" read -r highEXP highCHAR highRACE highBATTLES highKILLS highITEMS highDATE highMONTH highYEAR <<< $(sed -n "${SCORE_TO_PRINT}"p "$HIGHSCORE")
    HIGH_RACES=("" "Human" "Elf" "Dwarf" "Hobbit") # ${HIGH_RACES[0]} is dummy
    highRACE=${HIGH_RACES["$highRACE"]}

    (( highBATTLES == 1 )) && highBATTLES+=" battle" || highBATTLES+=" battles"
    (( highITEMS == 1 ))   && highITEMS+=" item"     || highITEMS+=" items"

    ANNOUNCEMENT="$(Capitalize "$highCHAR") fought $highBATTLES, $highKILLS victoriously, won $highEXP EXP and $highITEMS. This $ADJECTIVE $highRACE was finally slain the $highDATE of $highMONTH in the $highYEAR Cycle."
    GX_HighScore

    echo "ADVENTURE SUMMARY to copy and paste to your social media of choice:"
    echo -e "\n$ANNOUNCEMENT\n" | fmt
    echo "$HR"
    (( $(Strlen "$ANNOUNCEMENT") > 160)) && echo "Warning! String longer than 160 chars ($(Strlen "$ANNOUNCEMENT"))!"
    Exit 0
}

#-----------------------------------------------------------------------
# CLI_CheckUpdate()
# Update function
#-----------------------------------------------------------------------
CLI_CheckUpdate() {
    # Removes stranded repo files before proceeding..
    STRANDED_REPO_FILES=$(find "$GAMEDIR"/repo.* | wc -l)
    (( STRANDED_REPO_FILES > 0 )) && rm -f "$GAMEDIR/repo.*"
    REPO_SRC="$REPO/raw/biamin.sh"
    GX_BiaminTitle
    echo "$HR"
    echo "Retrieving $REPO_SRC .." | sed 's/https:\/\///g'
    REPO=$( mktemp $GAMEDIR/repo.XXXXXX )
    if [[ $(which wget 2>/dev/null) ]]; then # Try wget, automatic redirect
	wget -q -O "$REPO" "$REPO_SRC" || Die "DOWNLOAD ERROR! No internet with wget"
    elif [[ $(which curl 2>/dev/null) ]]; then # Try curl, -L - for redirect
	curl -s -L -o "$REPO" "$REPO_SRC" || Die  "DOWNLOAD ERROR! No internet with curl"
    else
	Die "DOWNLOAD ERROR! No curl or wget available"
    fi
    REPOVERSION=$( sed -n -r '/^VERSION=/s/^VERSION="([^"]*)".*$/\1/p' "$REPO" )
    echo "Your current Back in a Minute game is version $VERSION"
    CompareVersions $VERSION $REPOVERSION
    case "$?" in
	0)  echo "This is the latest version ($VERSION) of Back in a Minute!" ; rm -f "$REPO";;
	1)  echo "Your version ($VERSION) is newer than $REPOVERSION" ; rm -f "$REPO";;
	2)  echo "Newer version $REPOVERSION is available!"
	    echo "Updating will NOT destroy character sheets, highscore or current config."
 	    echo "Update to Biamin version $REPOVERSION? [Y/N] "
	    case $(Read) in
		y | Y ) echo -e "\nUpdating Back in a Minute from $VERSION to $REPOVERSION .."
			BIAMIN_RUNTIME=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
			BIAMIN_RUNTIME+="/"
			BIAMIN_RUNTIME+=$( basename "${BASH_SOURCE[0]}")
			mv "$BIAMIN_RUNTIME" "${BIAMIN_RUNTIME}.bak" # backup current file
			mv "$REPO" "$BIAMIN_RUNTIME"
			chmod +x "$BIAMIN_RUNTIME" || Die "PERMISSION ERROR! Couldn't make biamin executable"
			echo "Run 'sh $BIAMIN_RUNTIME --install' to add launcher!"
			echo "Current file moved to ${BIAMIN_RUNTIME}.bak"
			;;
		* ) echo -e "\nNot updating! Removing temporary file ..";
		    rm -f "$REPO" ;;
	    esac
	    ;;
    esac
    echo "Done. Thanks for playing :)"
    Exit 0
}

#-----------------------------------------------------------------------
# CreateBiaminLauncher()
# Add alias for biamin in $HOME/.bashrc
#-----------------------------------------------------------------------
CLI_CreateBiaminLauncher() {
    grep -q 'biamin' "$HOME/.bashrc" && Die "Found existing launcher in $HOME/.bashrc.. skipping!"
    BIAMIN_RUNTIME=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
    echo -en "This will add $BIAMIN_RUNTIME/biamin to your .bashrc\nInstall Biamin Launcher? [Y/N]: "
    case "$(Read)" in
	y | Y ) echo -e "\n# Back in a Minute Game Launcher (just run 'biamin')\nalias biamin='$BIAMIN_RUNTIME/biamin.sh'" >> "$HOME/.bashrc";
	        echo -e "\nDone. Run 'source \$HOME/.bashrc' to test 'biamin' command." ;;
	*     ) echo -e "\nDon't worry, not changing anything!";;
    esac
    Exit 0
}

CLI_Help() {
    echo "Run BACK IN A MINUTE with '-p', '--play' or 'p' argument to play!"
    echo "For usage: run biamin --usage"
    echo "Current dir for game files: $GAMEDIR/"
    echo "Change at runtime or on line 10 in the CONFIGURATION of the script."
    echo -e "\nReport bugs to: <http://sigg3.net/biamin/bugs>"
	echo "Home page: <http://sigg3.net/biamin/>"
  # echo "General help using GNU software: <http://www.gnu.org/gethelp/>" # TODO create a youtube + pic tutorial
    Exit 0
}

CLI_Version() {
    echo "BACK IN A MINUTE VERSION $VERSION Copyright (C) 2014 Sigg3.net"
    echo "Game SHELL CODE released under GNU GPL version 3 (GPLv3)."
    echo "This is free software: you are free to change and redistribute it."
    echo "There is NO WARRANTY, to the extent permitted by law."
    echo "For details see: <http://www.gnu.org/licenses/gpl-3.0>"
    echo "Game ARTWORK released under Creative Commons CC BY-NC-SA 4.0."
    echo "You are free to copy, distribute, transmit and adapt the work."
    echo "For details see: <http://creativecommons.org/licenses/by-nc-sa/4.0/>"
    echo "Game created by Sigg3. Submit bugs & feedback at <$WEBURL>"
    Exit 0
}

CLI_Usage() {
    echo "Usage: biamin or ./biamin.sh"
    echo "  (NO ARGUMENTS)      display this usage text and exit"
    echo "  -p --play or p      PLAY the game \"Back in a minute\""
    echo "  -a --announce       DISPLAY an adventure summary for social media and exit"
    echo "  -i --install        ADD biamin.sh to your .bashrc file"
    echo "     --map            CREATE custom map template with instructions and exit"
    echo "     --help           display help text and exit"
    echo "     --update         check for updates"
    echo "     --usage          display this usage text and exit"
    echo "  -v --version        display version and licensing info and exit"
    Exit 0
}


#-----------------------------------------------------------------------
# CLI_ParseArguments()
# Parse CLI arguments if any
#-----------------------------------------------------------------------
CLI_ParseArguments() {
    [[ ! "$@" ]] && CLI_Usage 	# emulation '(NO ARGUMENTS)      display this usage text and exit'
                                # Sigge, do we need it? It's not typical for unix-way. #kstn
    while [[ "$@" ]]; do
	case "$1" in
	    -a | --announce ) CLI_Announce ;;
	    -i | --install  ) CLI_CreateBiaminLauncher ;;
	    --map           ) CLI_CreateCustomMapTemplate ;;
	    -h | --help     ) CLI_Help ;;
	    -p | --play | p ) if [[ "$2" ]] && ! grep -Eq '^-' <<< "$2" ; then # if next argument is not key
	    		      	  shift  		                       # remove $1 from $@ (array of biamin.sh arguments)
	    		      	  CHAR="$1"                                    # long names as "Corum Jhaelen Irsei" should be double or single quoted
	    		      fi
			      echo "Launching Back in a Minute.." ;;
	    -v | --version  ) CLI_Version ;;
	    --update        ) CLI_CheckUpdate ;;
	    --usage         ) CLI_Usage ;;
	    -d | --debug    ) DEBUG=1;;                                        # set DEBUG mode 
	    -l | --log      ) if [[ "$2" ]] && ! grep -Eq '^-' <<< "$2" ; then # if next argument is not key
	    			  shift                                        # remove $1 from $@ (array of biamin.sh arguments)
	    			  exec 2<>"$1"                                 # redirect STDERR to $1
	    		      else
				  exec 2<>"/tmp/biamin_log_$(date "+%s")"      # or redirect STDERR to default log file
			      fi
 			      set -x                                           # set BASH's debugger 
			      ;;
	    *               ) echo "$0: unrecognized option '$1'";
			      echo "$0: use the --help or --usage options for more information";
			      Exit 0;;
	esac
	shift
    done 
}

#                                                                      #
#                                                                      #
########################################################################
########################################################################
#          Small functions which are used throughout the game          #
#                                                                      #

Die()         { echo -e "$0: $1" >&2 && Exit 1 ; }                                  # Display $1 (to STDERR) and exit script.
Sleep()       { read -s -n 1 -t "$1" ; }                                            # Works like usual sleep but can be abortet by hitting key
Capitalize()  { awk '{ print substr(toupper($0), 1,1) substr($0, 2); }' <<< "$*" ;} # Capitalize $1.
Toupper()     { awk '{ print toupper($0); }' <<< "$*" ; }                           # Convert $* to uppercase.
Strlen()      { awk '{ print length($0); }' <<< "$*" ; }                            # Return lenght of string $*.
MvAddStr()    { tput cup "$1" "$2"; printf "%s" "$3"; }                             # Move cursor to $1 $2 and print $3.
IsInt()       { grep -Eq '^[0-9]+$' <<< "$1" && return 0 || return 1; }             # Checks if $1 is int.
IsInstalled() { [[ $(which "$1" 2>/dev/null) ]] && return 0 || return 1 ; }         # Checks if $1(string) installed
Float()       {  bc <<< "scale=2; ${@}" ; }                                         # Float math. Usage var=$(Float "${CHAR_GOLD} * 2.25")

#-----------------------------------------------------------------------
# Exit()
# Makes cursor visible, than exit
# Arguments: (optional) $EXIT_CODE(int [0-255])
#-----------------------------------------------------------------------
Exit() {
    tput cnorm			      # Make cursor visible (to prevent leaving player without cursor)
    [[ "$1" ]] && exit "$1" || exit 0 # If $EXIT_CODE then 'exit $EXIT_CODE' else 'exit 0'
}

#-----------------------------------------------------------------------
# Read()
# Flush 512 symbols readed before and read one symbol
#-----------------------------------------------------------------------
Read() {
    read -s -t 0.01 -n 512 	# Flush 512 symbols in in buffer
    read -s -n 1		# Read only one symbol (to default variable, $REPLY)
    echo "$REPLY"		# And echo it
}

#-----------------------------------------------------------------------
# ReadLine()
# Flush 512 symbols readed before, makes cursor visible and read one
# line, than makes cursor unvisible
# NB to get answer you need to use $REPLY variable !!!
# Arguments: (optional) $PROMPT
#-----------------------------------------------------------------------
ReadLine() {
    [[ "$1" ]] && echo -en "$1" # Display prompt if any (like read -p, but to STDOUT and with '\n', '\t', colors, etc)
    read -s -t 0.01 -n 512 	# Flush 512 symbols in in buffer
    tput cnorm			# Make cursor visible
    read		        # Read one line (to default variable, $REPLY)
    tput civis			# Make cursor unvisible
}

#-----------------------------------------------------------------------
# Ordial()
# Add postfix to $1 (NUMBER)
# Arguments: $1(int)
#-----------------------------------------------------------------------
Ordial() {
    grep -Eq '^([0-9]*[^1])?1$'  <<< "$1" && echo "${1}st" && return 0
    grep -Eq '^([0-9]*[^1])?2$'  <<< "$1" && echo "${1}nd" && return 0
    grep -Eq '^([0-9]*[^1])?3$'  <<< "$1" && echo "${1}rd" && return 0
    grep -Eq '^[0-9]+$' <<< "$1" && echo "${1}th" && return 0
    Die "${FUNCNAME}: Bad ARG >>>$1<<<"
}

#-----------------------------------------------------------------------
# MakePrompt()
# Make centered to 79px promt from $@ (WITHOUT '\n' at the end of
# string!). Arguments should be separated by ';'
# Arguments: $PROMPT(string)
#-----------------------------------------------------------------------
MakePrompt() {
    awk '   BEGIN { FS =";" }
        {   MAXLEN = 79;
            COUNT = NF;
            for ( i=1; i<= NF; i++ ) { STRLEN += length($i); }
            if ( STRLEN > MAXLEN ) { exit 1 ; }
            SPACES = MAXLEN - STRLEN;
            REMAINDER = SPACES % (NF + 1 ) ;
            SPACER = (SPACES - REMAINDER ) / (NF + 1) ;
            if ( REMAINDER % 2  == 1 ) { REMAINDER -= 1 ; }
            SPACES_IN = REMAINDER / 2 ;
            while (SPACES_IN-- > 0 ) { INTRO = INTRO " "; }
            while (SPACER-- > 0 ) { SEPARATOR = SEPARATOR " " }
            STR = INTRO;
            for ( i=1; i<=NF; i++ ) { STR = STR SEPARATOR $i; }
            STR = STR SEPARATOR INTRO }
            END { printf STR; }' <<< "$@" || Die "${FUNCNAME}: Too long promt >>>$*<<<"
}

#-----------------------------------------------------------------------
# CompareVersions()
# Compare versions $1 and $2. Versions should be [0-9]+.[0-9]+.[0-9]+. ...
# Return : 0 if $1 == $2,
#          1 if $1 > than $2,
#          2 if $2 < than $1
# Arguments: $VERSION1, $VERSION2
# Used: CLI_CheckUpdate()
#-----------------------------------------------------------------------
CompareVersions() {
    [[ "$1" == "$2" ]] && return 0
    IFS="\." read -a VER1 <<< "$1"
    IFS="\." read -a VER2 <<< "$2"
    for ((i=0; ; i++)); do         # until break
	[[ ! "${VER1[$i]}" ]] && { RETVAL=2; break; }
	[[ ! "${VER2[$i]}" ]] && { RETVAL=1; break; }
	(( ${VER1[$i]} > ${VER2[$i]} )) && { RETVAL=1; break; }
	(( ${VER1[$i]} < ${VER2[$i]} )) && { RETVAL=2; break; }
    done
    unset VER1 VER2
    return $RETVAL
}

#-----------------------------------------------------------------------
# PressAnyKey()
# Make centered prompt $1 (or default) and read anykey
# Arguments: (optional) $PROMPT(string)
#-----------------------------------------------------------------------
PressAnyKey() {
    if [[ "$1" ]]; then
	MakePrompt "$1"
    else
	MakePrompt 'Press (A)ny key to continue..'
    fi
    read -s -t 0.01 -n 512 	# Flush 512 symbols in in buffer
    read -sn 1
}

#-----------------------------------------------------------------------
# ReseedRandom()
# Reseed random numbers generator by date or to $1 if it.
# Used: CoreRuntime.sh
# Arguments: (optional) $SEED(int)
#-----------------------------------------------------------------------
# TODO:
#  ? Make separate file with system-depended things
#  ? Use /dev/random or /dev/urandom
#-----------------------------------------------------------------------
# Suggestion from: http://tldp.org/LDP/abs/html/randomvar.html
# RANDOM=$(head -1 /dev/urandom | od -N 1 | awk '{ print $2 }'| sed s/^0*//)
#-----------------------------------------------------------------------
ReseedRandom() {
    if [[ "$1" ]]; then
	RANDOM="${1}"
    else
	case "$OSTYPE" in
	    openbsd* ) RANDOM=$(date '+%S') ;;
	    *)         RANDOM=$(date '+%N') ;;
	esac
    fi
}

#-----------------------------------------------------------------------
# Echo() - test, EchoRight etc
#-----------------------------------------------------------------------
Echo() {
    # TODO check for total lenght < 79 !!!
    echo -en "$1"
    tput hpa $(( 78 - $(Strlen "$2") )) # Move cursor to column #1
    echo -en "$2"
}

#                                                                      #
#                                                                      #
########################################################################
########################################################################
#                             Menu system                              #
#                                                                      #

#-----------------------------------------------------------------------
# LoadGame()
# Display chars in $GAMEDIR and load one
# Used: MainMenu()
#-----------------------------------------------------------------------
LoadGame() {
    local SHEETS FILES i=0 LIMIT=9 OFFSET=0 NUM=0 a # Declare all needed local variables
    # xargs ls -t - sort by date, last played char'll be the first in array
    for loadSHEET in $(find "$GAMEDIR/" -name '*.sheet') ; do # Find all sheets and add to array if any
	((++i))
	FILES[$i]="$loadSHEET"
   	SHEETS[$i]=$(awk '{ # Character can consist from two and more words, not only "Corum" but "Corum Jhaelen Irsei" for instance
                   if (/^CHARACTER:/)  { RLENGTH = match($0,/: /); CHARACTER = substr($0, RLENGTH+2); }
                   if (/^RACE:/)       { if ($2 == 1 ) { RACE="Human"; }
               		                 if ($2 == 2 ) { RACE="Elf"; }
             		                 if ($2 == 3 ) { RACE="Dwarf"; }
            		                 if ($2 == 4 ) { RACE="Hobbit";} }
                   if (/^LOCATION:/)   { LOCATION = $2 }
                   if (/^HEALTH:/)     { HEALTH = $2 }
                   if (/^ITEMS:/)      { ITEMS = $2 }
                   if (/^EXPERIENCE:/) { EXPERIENCE = $2 } }
                 END {
                 print "\"" CHARACTER "\" the " RACE " (" HEALTH " HP, " EXPERIENCE " EXP, " ITEMS " items, sector " LOCATION ")"
                 }' "$loadSHEET")
    done
    GX_LoadGame 		# Just one time!
    tput sc
    if [[ ! "${SHEETS[@]}" ]] ; then # If no one sheet was found
    	echo " Sorry! No character sheets in $GAMEDIR/"
    	PressAnyKey " Press any key to return to (M)ain menu and try (P)lay" # St. Anykey - patron of cyberneticists :)
    	return 1   # BiaminSetup() will not be run after LoadGame()
    fi
    while (true) ; do
	tput rc 		# Restore cursor position
	tput ed			# Clear to the end of screen
    	for (( a=1; a <= LIMIT ; a++)); do [[ ${SHEETS[((a + OFFSET))]} ]] && echo "${a}. ${SHEETS[((a + OFFSET))]}" || break ; done
    	(( i > LIMIT)) && echo -en "\n You have more than $LIMIT characters. Use (P)revious or (N)ext to list," # Don't show it if there are chars < LIMIT
    	echo -en "\n Enter NUMBER of character to load or any letter to return to (M)ain Menu: "
    	read -sn 1 NUM # TODO replace to read -p after debug
    	case "$NUM" in
    	    n | N ) ((OFFSET + LIMIT < i)) && ((OFFSET += LIMIT)) ;; # Next part of list
    	    p | P ) ((OFFSET > 0))         && ((OFFSET -= LIMIT)) ;; # Previous part of list
    	    [1-9] ) NUM=$((NUM + OFFSET)); break;;                   # Set NUM = selected charsheet num
    	    *     ) break;; # NUM == 0 to prevent fall in [[ ! ${FILES[$NUM]} ]] if user press ESC, KEY_UP etc. ${FILES[0]} is always empty
    	esac
     done
    echo "" # TODO empty line - fix it later
    [[ ! "${SHEETS[$NUM]}" ]] && return 1 # BiaminSetup() will not be run after LoadGame()
    CHAR=$(awk '{if (/^CHARACTER:/) { RLENGTH = match($0,/: /); print substr($0, RLENGTH+2);}}' "${FILES[$NUM]}" );
}   # return to MainMenu()


#-----------------------------------------------------------------------
# HighscoreRead()
# Read and show 10 highscore entries or from $HIGHSCORE file
# Used: HighScore(), MainMenu(), CLI_Announce() and Death()
#-----------------------------------------------------------------------
HighscoreRead() { 
    sort -g -r "$HIGHSCORE" -o "$HIGHSCORE"
    local i=1 HIGHSCORE_TMP=" #;Hero;EXP;Wins;Items;Entered History\n"
    # Read values from highscore file (BashFAQ/001)
    while IFS=";" read -r highEXP highCHAR highRACE highBATTLES highKILLS highITEMS highDATE highMONTH highYEAR; do
	(( i > 10 )) && break
	case "$highRACE" in
	    1 ) highRACE="Human" ;;
	    2 ) highRACE="Elf" ;;
	    3 ) highRACE="Dwarf" ;;
	    4 ) highRACE="Hobbit" ;;
	esac
	HIGHSCORE_TMP+=" $i.;$highCHAR the $highRACE;$highEXP;$highKILLS/$highBATTLES;$highITEMS/8;$highMONTH $highDATE ($highYEAR)\n"
	((i++))
    done < "$HIGHSCORE"
    echo -e "$HIGHSCORE_TMP" | column -t -s ";" # Nice tabbed output!
}

#----------------------------------------------------------------------
# PrepareLicense()
# Gets licenses and concatenates into "LICENSE" in $GAMEDIR
# TODO: add option to use wget if systen hasn't curl (Debian for
# instance) -kstn
# TODO: I'm not sure. I was told to use curl because it has greater
# compatibility than wget..? - s3
#-----------------------------------------------------------------------
PrepareLicense() {
    echo " Download GNU GPL Version 3 ..."
    GPL=$(curl -s "$REPO/raw/licenses/GPL" || "" ) # TODO test these
#   GPL=$(curl -s "http://www.gnu.org/licenses/gpl-3.0.txt" || "") # I did not know we could do that :)
    echo " Download CC BY-NC-SA 4.0 ..."
	CC=$(curl -s "$REPO/raw/licenses/CC" || "" )   # TODO test these
#   CC=$(curl -s "http://creativecommons.org/licenses/by-nc-sa/4.0/legalcode.txt" || "")
	# TODO Check md5sums of files :
	# d32239bcb673463ab874e80d47fae504  GPL
	# 6991e89af15ce0d1037ddd018f05029e  CC
    if [[ $GPL && $CC ]] ; then
	echo -e "\t\t   BACK IN A MINUTE BASH CODE LICENSE:\t\t\t(Q)uit\n
$HR
$GPL
\n$HR\n\n\t\t   BACK IN A MINUTE ARTWORK LICENSE:\n\n
$CC"  > "$GAMEDIR/LICENSE"
	Die "Licenses downloaded and concatenated!"
    else
	Die "Couldn't download license files :( Do you have Internet access?"
    fi
}

#-----------------------------------------------------------------------
# License()
# Displays license if present or runs PrepareLicense && then display it..
# Used: Credits()
#-----------------------------------------------------------------------
License() {
    GX_BiaminTitle
    if [[ ! -f "$GAMEDIR/LICENSE" ]]; then
	ReadLine "\n License file currently missing in $GAMEDIR/ !\n To DL licenses, about 60kB, type YES (requires internet access): "
	case "$REPLY" in
	    YES ) PrepareLicense ;;
	    *    )   echo -e "
Code License:\t<http://www.gnu.org/licenses/gpl-3.0.txt>
Art License:\t<http://creativecommons.org/licenses/by-nc-sa/4.0/legalcode.txt>
More info:\t<${WEBURL}about#license>
Press any key to go back to main menu!";
		     read -sn 1;
		     return 0;;
	esac
    fi
    [[ "$PAGER" ]] && "$PAGER" "$GAMEDIR/LICENSE" || { echo -e "\n License file available at $GAMEDIR/LICENSE" ; PressAnyKey ;} # ShowLicense()
}   # Return to Credits()

#-----------------------------------------------------------------------
# CleanUp() {
# Used : MainMenu(), NewSector(),
#-----------------------------------------------------------------------
CleanUp() {
    GX_BiaminTitle
    echo -e "\n$HR"
    if ((FIGHTMODE)); then #  -20 HP -20 EXP Penalty for exiting CTRL+C during battle!
	((CHAR_HEALTH -= 20))
    	((CHAR_EXP -= 20))
    	echo "PENALTY for CTRL+Chickening out during battle:"
	Echo "HEALTH: $CHAR_HEALTH    EXPERIENCE: $CHAR_EXP" "[-20 HEALTH -20 EXP]"
    fi
    [[ "$CHAR" ]] && SaveCurrentSheet # Don't try to save if we've nobody to save :)
    echo -e "\nLeaving the realm of magic behind ....\nPlease submit bugs and feedback at <$WEBURL>"
    Exit 0
}

#-----------------------------------------------------------------------
# HighScore()
# Show 10 highscore entries or empty prompt if Highscore list is empty
# Used: MainMenu(), Death();
#-----------------------------------------------------------------------
HighScore() {
    GX_HighScore  
    echo ""
    # Show 10 highscore entries or die if Highscore list is empty
    [[ -s "$HIGHSCORE" ]] && HighscoreRead || echo -e " The highscore list is unfortunately empty right now.\n You have to play some to get some!"
    echo ""  # empty line TODO fix it
    PressAnyKey 'Press the any key to go to (M)ain menu'
}

#-----------------------------------------------------------------------
# MainMenu()
# Defines $CHAR or show misc options
#-----------------------------------------------------------------------
MainMenu() {
    while [[ ! "$CHAR" ]] ; do # Until $CHAR is defined
	GX_Banner
	MakePrompt '(P)lay;(L)oad game;(H)ighscore;(C)redits;(Q)uit'
	case $(Read) in
	    [pP] ) ReadLine "${CLEAR_LINE} Enter character name (case sensitive): ";
 		   CHAR="$REPLY" ;;
	    [lL] ) LoadGame ;;
	    [hH] ) HighScore;;
	    [cC] ) GX_Credits ; # Credits
		   MakePrompt '(H)owTo;(L)icense;(M)ain menu';
		   case $(Read) in
		       [Ll] ) License ;;
		       [Hh] ) GX_HowTo ;;
		   esac ;;
	    [qQ] ) CleanUp ;;
	esac
done
}

#                                                                      #
#                                                                      #
########################################################################

########################################################################
#                             BiaminSetup                              #
#                    Load charsheet or make new char                   #

#-----------------------------------------------------------------------
# $RACES
# All game races and their abilities table. Sum of all race abilities
# equal 12
#-----------------------------------------------------------------------
declare -r -a RACES=(
    "Race   Healing Strength Accuracy Flee Offset_Gold Offset_Tobacco" # Dummy - we haven't RACE == 0
    "human  3       3        3        3    12           8"
    "elf    4       3        4        1     8          12"
    "dwarf  2       5        3        2    14           6"
    "hobbit 4       1        4        3     6          14"
)
declare -r MAX_RACES=4 		                                       # Count of game races

#-----------------------------------------------------------------------
# $INITIAL_VALUE_*
# Initial Value of Currencies - declared as constants, in one place
# for easier changing afterwards
# Default 0.15: 0.05 is very stable economy, 0.5 is very unstable.
# IDEA If we add a (S)ettings page in (M)ain menu, this could be
# user-configurable.
#-----------------------------------------------------------------------
declare -r INITIAL_VALUE_GOLD=1      # Initial Value of Gold
declare -r INITIAL_VALUE_TOBACCO=1   # Initial Value of Tobacco
declare -r INITIAL_VALUE_CHANGE=0.15 # Initial Market fluctuation key

#-----------------------------------------------------------------------
# BiaminSetup_SetRaceAbilities()
# Load race abilities from $RACES
# Arguments: $CHAR_RACE (int)
#-----------------------------------------------------------------------
BiaminSetup_SetRaceAbilities() {
    read -r CHAR_RACE_STR HEALING STRENGTH ACCURACY FLEE OFFSET_GOLD OFFSET_TOBACCO <<< ${RACES[$1]}
}

#-----------------------------------------------------------------------
# BiaminSetup_SetItemsAbilities
# Load bonuses from magic items (items defined in GameItems.sh)
# Arguments: $CHAR_ITEMS (int)
#-----------------------------------------------------------------------
BiaminSetup_SetItemsAbilities() {
    HaveItem "$EMERALD_OF_NARCOLEPSY" && ((HEALING++))
    HaveItem "$FAST_MAGIC_BOOTS"      && ((FLEE++))
    HaveItem "$TWO_HANDED_BROADSWORD" && ((STRENGTH++))
    HaveItem "$STEADY_HAND_BREW"      && ((ACCURACY++))
}

#-----------------------------------------------------------------------
# BiaminSetup_UpdateOldSaves()
# Sequence for updating older charsheets to later additions (compatibility)
# Arguments: $CHARSHEET(string)
# Used: BiaminSetup_LoadCharsheet()
#-----------------------------------------------------------------------
BiaminSetup_UpdateOldSaves() {
    grep -Eq '^HOME:' "$1"        || echo "HOME: $START_LOCATION" >> $1
    grep -Eq '^BBSMSG:' "$1"      || echo "BBSMSG: 0" >> $1
    grep -Eq '^STARVATION:' "$1"  || echo "STARVATION: 0" >> $1
    # Time
    grep -Eq '^TURN:' "$1"        || echo "TURN: $(TurnFromDate)" >> $1
    # Almanac
    grep -Eq '^INV_ALMANAC:' "$1" || echo "INV_ALMANAC: 0" >> $1
    # TODO use  OFFSET_{GOLD,TOBACCO}
    grep -Eq '^GOLD:' "$1"        || echo "GOLD: 10" >> $1
    grep -Eq '^TOBACCO:' "$1"     || echo "TOBACCO: 10" >> $1
    grep -Eq '^FOOD:' "$1"        || echo "FOOD: 10" >> $1
    grep -Eq '^VAL_GOLD:' "$1"    || echo "VAL_GOLD: $INITIAL_VALUE_GOLD" >> $1
    grep -Eq '^VAL_TOBACCO:' "$1" || echo "VAL_TOBACCO: $INITIAL_VALUE_TOBACCO" >> $1
    grep -Eq '^VAL_CHANGE:' "$1"  || echo "VAL_CHANGE: $INITIAL_VALUE_CHANGE" >> $1
}

#-----------------------------------------------------------------------
# BiaminSetup_SanityCheck()
# Checks if $1 in GPS format ([A-R][1-15])
# Arguments: $CHAR_LOC(string)
# Used: BiaminSetup_LoadCharsheet()
#-----------------------------------------------------------------------
BiaminSetup_SanityCheck() {
    local CHAR_LOC_LEN CHAR_LOC_X CHAR_LOC_Y
    read CHAR_LOC_LEN CHAR_LOC_X CHAR_LOC_Y <<< $(awk '{print length($0) " " substr($0,0,1) " " substr($0,2)}' <<< "$1")
    echo -n "Sanity check.."
    (( CHAR_LOC_LEN < 1 )) && Die "\n Error! Too less characters in $CHAR_LOC\n Start location is 2-3 alphanumeric chars [A-R][1-15], e.g. C2 or P13"
    (( CHAR_LOC_LEN > 3 )) && Die "\n Error! Too many characters in $CHAR_LOC\n Start location is 2-3 alphanumeric chars [A-R][1-15], e.g. C2 or P13"
    [[ "$CHAR_LOC_X" == [A-R] ]] &&  echo -n ".." || Die "\n Error! Start location X-Axis $CHAR_LOC_X must be a CAPITAL alphanumeric A-R letter!"
    case "$CHAR_LOC_Y" in
	1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 ) echo ".. Done!" ;;
	* ) Die "\n Error! Start location Y-Axis $CHAR_LOC_Y is too big or too small!";;
    esac
    # End of SANITY check, everything okay!
    CHAR_GPS="$1"
    CHAR_HOME="$1"
}

BiaminSetup_LoadCharsheet() {
    echo -en " Welcome back, $CHAR!\n Loading character sheet ..." # -n for 80x24, DO NOT REMOVE IT #kstn
    BiaminSetup_UpdateOldSaves "$CHARSHEET"
    local CHAR_TMP=$(awk '
                  {
                   if (/^CHARACTER:/)  { RLENGTH = match($0,/: /);
                  	                 CHARACTER = substr($0, RLENGTH+2); }
                   if (/^RACE:/)       { RACE= $2 }
                   if (/^BATTLES:/)    { BATTLES = $2 }
                   if (/^EXPERIENCE:/) { EXPERIENCE = $2 }
                   if (/^LOCATION:/)   { LOCATION = $2 }
                   if (/^HEALTH:/)     { HEALTH = $2 }
                   if (/^ITEMS:/)      { ITEMS = $2 }
                   if (/^KILLS:/)      { KILLS = $2 }
                   if (/^HOME:/)       { HOME = $2 }
                   if (/^GOLD:/)       { GOLD = $2 }
                   if (/^TOBACCO:/)    { TOBACCO = $2 }
                   if (/^FOOD:/)       { FOOD = $2 }
                   if (/^BBSMSG:/)     { BBSMSG = $2 }
                   if (/^VAL_GOLD:/)   { VAL_GOLD = $2 }
                   if (/^VAL_TOBACCO:/){ VAL_TOBACCO = $2 }
                   if (/^VAL_CHANGE:/) { VAL_CHANGE = $2 }
                   if (/^STARVATION:/) { STARVATION = $2 }
                   if (/^TURN:/)        { TURN= $2 }
                   if (/^INV_ALMANAC:/) { INV_ALMANAC = $2 }
                  }
                 END {
                 print CHARACTER ";" RACE ";" BATTLES ";" EXPERIENCE ";" LOCATION ";" HEALTH ";" ITEMS ";" KILLS ";" HOME ";" GOLD ";" TOBACCO ";" FOOD ";" BBSMSG ";" VAL_GOLD ";" VAL_TOBACCO ";" VAL_CHANGE ";" STARVATION ";" TURN ";" INV_ALMANAC ";"
                 }' $CHARSHEET )
    IFS=";" read -r CHAR CHAR_RACE CHAR_BATTLES CHAR_EXP CHAR_GPS CHAR_HEALTH CHAR_ITEMS CHAR_KILLS CHAR_HOME CHAR_GOLD CHAR_TOBACCO CHAR_FOOD BBSMSG VAL_GOLD VAL_TOBACCO VAL_CHANGE STARVATION TURN INV_ALMANAC <<< "$CHAR_TMP"
    # If character is dead, don't fool around..
    (( CHAR_HEALTH <= 0 )) && Die "\nWhoops!\n $CHAR's health is $CHAR_HEALTH!\nThis game does not support necromancy, sorry!"
}

#-----------------------------------------------------------------------
# BiaminSetup_MakeBaseChar()
# Set default initial values for CHAR characterisitics
#
# Main idea is to exclude BiaminSetup_UpdateOldSaves() but make basic
# char with default settings (gold, values, food, etc) and then
# BiaminSetup_LoadCharsheet() or BiaminSetup_MakeNewChar()
#-----------------------------------------------------------------------
BiaminSetup_MakeBaseChar() {
    # CHARACTER: $CHAR
    # RACE: $CHAR_RACE
    CHAR_BATTLES=0
    CHAR_EXP=0
    CHAR_GPS="$START_LOCATION"
    CHAR_HEALTH=100
    CHAR_ITEMS=0
    CHAR_KILLS=0
    CHAR_HOME="$START_LOCATION"
    # GOLD: $CHAR_GOLD
    # TOBACCO: $CHAR_TOBACCO
    CHAR_FOOD=$( bc <<< "$(RollDice2 11) + 4" ) # Determine initial food stock (D16 + 4) - player has 5 food minimum
    BBSMSG=0
    VAL_GOLD="$INITIAL_VALUE_GOLD" 	 # Initial Value of Currencies
    VAL_TOBACCO="$INITIAL_VALUE_TOBACCO" # Initial Value of Currencies
    VAL_CHANGE="$INITIAL_VALUE_CHANGE"   # Market fluctuation key
    STARVATION=0
    TURN=$(TurnFromDate)	# Count turn from current date
    INV_ALMANAC=0 		# Locked by-default
}

BiaminSetup_MakeNewChar() {
    echo " $CHAR is a new character!"
    GX_Races
    echo -n " Select character race (1-4): "
    CHAR_RACE=$(Read)
    [[ "$CHAR_RACE" != [1-$MAX_RACES] ]] && CHAR_RACE=1 # fix user's input
    BiaminSetup_SetRaceAbilities "$CHAR_RACE"
    echo "You chose to be a $(Toupper $CHAR_RACE_STR)"

    # IDEA v.3 Select Gender (M/F) ?
    # Most importantly for spoken strings, but may also have other effects.

    # Determine material wealth
    CHAR_GOLD=$(RollDice2 $OFFSET_GOLD)
    CHAR_TOBACCO=$(RollDice2 $OFFSET_TOBACCO)

    # If there IS a CUSTOM.map file, ask where the player would like to start
    # TODO move it to LoadCustomMap()
    if [[ "$CUSTOM_MAP" ]] ; then
	START_LOCATION=$(awk '{ if (/^START LOCATION:/) { print $2; exit; } print "'$START_LOCATION'"; }' <<< "$CUSTOM_MAP" )
	ReadLine " HOME location for custom maps (ENTER for default $START_LOCATION): "
	CHAR_LOC="$REPLY"
	[[ ! -z "$CHAR_LOC" ]] && BiaminSetup_SanityCheck "$CHAR_LOC" 	# Use user input as start location.. but first SANITY CHECK
    fi
    echo " Creating fresh character sheet for $CHAR ..."
    SaveCurrentSheet
}

#-----------------------------------------------------------------------
# BiaminSetup()
# Gets char name and load charsheet or make new char
# Used: CoreRuntime.sh
# TODO: Argumens: $CHAR(string)
#-----------------------------------------------------------------------
BiaminSetup() {
    BiaminSetup_MakeBaseChar	                                                        # Make default char
    CHARSHEET="$GAMEDIR/$(echo "$CHAR" | tr '[:upper:]' '[:lower:]' | tr -d " ").sheet" # Set CHARSHEET variable to gamedir/char.sheet (lowercase)
    if [[ -f "$CHARSHEET" ]] ; then
	BiaminSetup_LoadCharsheet
	BiaminSetup_SetRaceAbilities  "$CHAR_RACE"
	BiaminSetup_SetItemsAbilities "$CHAR_ITEMS"                                     # We need set item's abilities only for loaded chars
	((DISABLE_CHEATS == 1 && CHAR_HEALTH >= 150)) && CHAR_HEALTH=150                # If Cheating is disabled (in CONFIGURATION) restrict health to 150
    else
	BiaminSetup_MakeNewChar
    fi
    Sleep 2

}

#                                                                      #
#                                                                      #
########################################################################

########################################################################
#                                                                      #
#                        2. RUNTIME BLOCK                              #
#                   All running code goes here!                        #

# Make place for game (BEFORE CLI opts! Mostly because of Higscore and
# CLI_CreateCustomMapTemplate())

if [[ ! -d "$GAMEDIR" ]] ; then                                           # Check whether gamedir exists...
    echo -e "Game directory default is $GAMEDIR/\nYou can change this in $CONFIG. Creating directory ..."
    mkdir -p "$GAMEDIR/" || Die "ERROR! You do not have write permissions for $GAMEDIR ..."
fi

if [[ ! -f "$CONFIG" ]] ; then                                            # Check whether $CONFIG exists...
    echo "Creating ${CONFIG} ..."
    echo -e "GAMEDIR: ${GAMEDIR}\nCOLOR: NA" > "$CONFIG"
fi

[[ -f "$HIGHSCORE" ]] || touch "$HIGHSCORE";                              # Check whether $HIGHSCORE exists...
grep -q 'd41d8cd98f00b204e9800998ecf8427e' "$HIGHSCORE" && > "$HIGHSCORE" # Backwards compatibility: replaces old-style empty HS...

if [[ ! "$PAGER" ]] ; then                                                # Define PAGER (for ShowLicense() ) # Not defined by-default in some systems.
    for PAGER in less more ; do PAGER=$(which "$PAGER" 2>/dev/null); [[ "$PAGER" ]] && break; done
fi

CLI_ParseArguments "$@"			  # Parse CLI args if any
echo "Putting on the traveller's boots.." # OK lets play!

# Load variables from $GAMEDIR/config. Need if player wants to keep
# his saves not in ~/.biamin . NB variables should not be empty !

read -r GAMEDIR COLOR <<< $(awk '{ if (/^GAMEDIR:/)  { GAMEDIR= $2 }
                                   if (/^COLOR:/)    { COLOR = $2  } }
                            END { print GAMEDIR, COLOR ;}' "$CONFIG" )

CheckBiaminDependencies		   # Check all needed programs and screen size
ColorConfig "$COLOR"               # Color configuration
ReseedRandom			   # Reseed random numbers generator
trap CleanUp SIGHUP SIGINT SIGTERM # Direct termination signals to CleanUp
tput civis			   # Make annoying cursor invisible
################################# Main game part ###############################
[[ "$CHAR" ]] || MainMenu          # Run main menu (Define $CHAR) if game wasn't run as biamin -p <charname>
BiaminSetup                        # Load or make new char
Intro	                           # Set world
NewSector                          # And run main game loop
############################## Main game part ends #############################
Exit 0                             # This should never happen:
                                   # .. but why be 'tardy when you can be tidy?
