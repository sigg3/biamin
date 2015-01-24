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
	*)                   Die "Bug in GX_DEATH() with arg >>>$1<<<" ;;
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
	* ) Die "Bug in GX_Moon() with ARG >>>$1<<<" ;;
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

