#!/usr/bin/bash
# Back In A Minute created by Sigg3.net (C) 2014
# Code is GNU GPLv3 & ASCII art is CC BY-NC-SA 4.0
VERSION="1.9" # 12 items on TODO. Change to 2.0 when list is x'd out
WEBURL="http://sigg3.net/biamin/"

########################################################################
# BEGIN CONFIGURATION                                                  #
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

# Horizontal ruler used almost everywhere in the game
HR="- ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ "

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
    read -sn 1
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

    ### BACKUP - delete it after testing
    # echo "$HR"
    # local SPACE="                       " && echo "$SPACE Press (A)ny key to continue" 
    # local COUNTDOWN=60 && local CDOTS=1 && local DOTS && tput sc # Sorry, had to try it:P
    # while (( COUNTDOWN >= 0 )) ; do
    # 	(( CDOTS == 1 )) && DOTS=".. " || DOTS="..."
    # 	MvAddStr 16 51 "$DOTS $SPACE"
    # 	read -sn 1 -t 1 && break || ((COUNTDOWN--))
    # 	(( CDOTS == 1 )) && CDOTS=2 || CDOTS=1
    # done
    # tput rc
    # unset COUNTDOWN

    local COUNTDOWN="$1"
    tput civis
    echo "$HR"
    echo -n "                         Press (A)ny key to continue.."
    tput sc    
    # while (( COUNTDOWN-- > 0 )) ; do # TEST. Should work
    while ((COUNTDOWN--)); do
    tput rc
    	((COUNTDOWN % 2)) && echo -n "." || echo -n " "
    	read -sn 1 -t 1 && break 
    done
    tput cnorm
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


#-----------------------------------------------------------------------
# GX_Calendar()
# Used: DisplayCharsheet()
# TODO: The Idea is simply put to have a calendar on the right side
# and some info about the current month on the left (or vice-versa)
#-----------------------------------------------------------------------
GX_Calendar() {
    clear
    echo "CALENDAR placeholder"
    echo "$HR"
    PressAnyKey
}

#-----------------------------------------------------------------------
# GX_Moon()
# Arguments: $MOON(int[0-7]) (Count of moon phases_
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
	0 ) echo "It is dark, the Moon is" && tput cup 8 33 && echo "Young" ;;
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



GX_Marketplace_Merchant() { # Used in Marketplace_Merchant() (Goatee == dashing, not hipster)
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

GX_Marketplace_Beggar() { # Used in Marketplace_Beggar()
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
                                                    / ,                : \ |
                                                 _ /__    ,-~~.        ;   |
                                               ,'_||_;`._;     `-__ _ ,'\  |
                                                                         \_|
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
	echo "" # Empty line 
	read -n 1 -p "Enter NUMBER of map to load or any letter to play (D)efault map: " NUM 2>&1 
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
	*)
	    Die "Bug in GX_Item() with item >>>$1<<<"
	    ;;
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
	"chthulu" ) cat <<"EOT"
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
	"orc" ) cat <<"EOT"
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
	"varg" ) cat <<"EOT"

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
	"mage" ) cat <<"EOT"
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
	"goblin" ) cat <<"EOT"
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
	"bandit" ) cat <<"EOT"
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
	"boar" ) cat <<"EOT"
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
	"dragon" ) cat <<"EOT"
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
	"bear" ) cat <<"EOT"
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
	"imp" ) cat <<"EOT"


                                                         __,__,         
                                                     ,-. \   (__,       
         AN YMPE SWOOPS DOWN!                       ;- 7) )     (           
                                                    `~.  \/  _ _ (      
         The imp is a common                    ,,~._,-.  ,^y Y Y 
         nuisance for travellers.                 ``-~_?  l             
                                                     (_  ,'             
         Luckily, they are easily defeated.           _;((              


EOT
	    ;;
	*)
	    Die "Bug in GX_Monster() with enemy >>>$1<<<"
	    ;;
    esac
    echo "$HR"
}
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
#                             GX_DiceGame                              #
#                   GX for MiniGameDice (cc-version)                   #

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

#                                                                      #
#                                                                      #
########################################################################

#-----------------------------------------------------------------------
# Read()
# Flush 512 symbols readed before and read one symbol
#-----------------------------------------------------------------------    
Read() {
    # read -s -t 0.001 -n 512
    # read -s -n 1 VAR
    # echo "$VAR"
    read -s -t 0 -n 512 	# Flush 512 symbols in in buffer
    read -s -n 1		# Read only one symbol (to default variable, $REPLY)
    echo "$REPLY"		# And echo it
}

#-----------------------------------------------------------------------
# Sleep()
# Works like usual sleep but can be abortet by hitting key
# Arguments: $SECONDS(int)
#-----------------------------------------------------------------------    
Sleep() {
    read -n 1 -t "$1"
}

########################################################################
#                             BiaminSetup                              #
#                    Load charsheet or make new char                   #

# Set abilities according to race (each equal to 12) + string var used frequently
RACES=(
    "Race   Healing Strength Accuracy Flee Offset_Gold Offset_Tobacco" # Dummy - we haven't RACE == 0
    "human  3       3        3        3     2          -3"
    "elf    4       3        4        1    -3           2" 
    "dwarf  2       5        3        2     2          -3"
    "hobbit 4       1        4        3    -3           2"
)

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
# Load bonuses from magic items (items defined in Items.sh)
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
    grep -Eq '^GOLD:' "$1"        || echo "GOLD: 10" >> $1
    grep -Eq '^TOBACCO:' "$1"     || echo "TOBACCO: 10" >> $1
    grep -Eq '^FOOD:' "$1"        || echo "FOOD: 10" >> $1
    grep -Eq '^BBSMSG:' "$1"      || echo "BBSMSG: 0" >> $1
    grep -Eq '^STARVATION:' "$1"  || echo "STARVATION: 0" >> $1
    # TODO use  OFFSET_{GOLD,TOBACCO} 
    grep -Eq '^VAL_GOLD:' "$1"    || echo "VAL_GOLD: 1" >> $1
    grep -Eq '^VAL_TOBACCO:' "$1" || echo "VAL_TOBACCO: 1" >> $1
    grep -Eq '^VAL_CHANGE:' "$1"  || echo "VAL_CHANGE: 0.25" >> $1
    # Time 
    grep -Eq '^TURN:' "$1"        || echo "TURN: $(TurnFromDate)" >> $1
    # Almanac
    grep -Eq '^INV_ALMANAC:' "$1" || echo "INV_ALMANAC: 0" >> $1
}

#-----------------------------------------------------------------------
# BiaminSetup_SanityCheck()
# Checks if $1 in GPS format ([A-R][1-15])
# Arguments: $CHAR_LOC(string)
# Used: BiaminSetup_LoadCharsheet()
#-----------------------------------------------------------------------
BiaminSetup_SanityCheck(){
    local CHAR_LOC_LEN CHAR_LOC_X CHAR_LOC_Y
    read CHAR_LOC_LEN CHAR_LOC_X CHAR_LOC_Y <<< $(awk '{print length($0) " " substr($0,0,1) " " substr($0,2)}' <<< "$1")
    echo -n "Sanity check.."
    (( CHAR_LOC_LEN < 1 )) && Die "\n Error! Too less characters in $CHAR_LOC\n Start location is 2-3 alphanumeric chars [A-R][1-15], e.g. C2 or P13"
    (( CHAR_LOC_LEN > 3 )) && Die "\n Error! Too many characters in $CHAR_LOC\n Start location is 2-3 alphanumeric chars [A-R][1-15], e.g. C2 or P13"
    case "$CHAR_LOC_X" in
	A | B | C | D | E | F | G | H | I | J | K | L | M | N | O | P | Q | R ) echo -n ".." ;;
	* ) Die "\n Error! Start location X-Axis $CHAR_LOC_X must be a CAPITAL alphanumeric A-R letter!" ;;
    esac
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
    unset CHAR_TMP
    # If character is dead, don't fool around..
    (( CHAR_HEALTH <= 0 )) && Die "\nWhoops!\n $CHAR's health is $CHAR_HEALTH!\nThis game does not support necromancy, sorry!"
}

#-----------------------------------------------------------------------
# BiaminSetup_MakeBaseChar()
# Sketch. Main idea is to exclude BiaminSetup_UpdateOldSaves() but
# make basic char with default settings (gold, values, food, etc) and
# then BiaminSetup_LoadCharsheet() or BiaminSetup_MakeNewChar()
#-----------------------------------------------------------------------
BiaminSetup_MakeBaseChar() {
# CHARACTER: $CHAR
# RACE: $CHAR_RACE
    CHAR_BATTLES=0
# EXPERIENCE: $CHAR_EXP
    CHAR_GPS="$START_LOCATION"
    CHAR_HEALTH=100
    CHAR_ITEMS=0
    CHAR_KILLS=0
    CHAR_HOME="$START_LOCATION"
# GOLD: $CHAR_GOLD
# TOBACCO: $CHAR_TOBACCO
    CHAR_FOOD=$( bc <<< "$(RollDice2 16) + 4" ) # Determine initial food stock (D16 + 4) - player has 5 food minimum
    BBSMSG=0
    VAL_GOLD=1 	                # Initial Value of Currencies
    VAL_TOBACCO=1	        # Initial Value of Currencies
    VAL_CHANGE=0.25	        # Market fluctuation key
    STARVATION=0
    TURN=$(TurnFromDate)	# Count turn from current date
    INV_ALMANAC=0 		# Locked by-default
}

BiaminSetup_MakeNewChar() {
	echo " $CHAR is a new character!"
	CHAR_BATTLES=0
	CHAR_EXP=0
	CHAR_HEALTH=100
	CHAR_ITEMS=0
	CHAR_KILLS=0
	BBSMSG=0
	STARVATION=0;
	TURN=$(TurnFromDate) # Player starts from translated _real date_. Afterwards, turns increment.
	INV_ALMANAC=0
	GX_Races
	read -sn 1 -p " Select character race (1-4): " CHAR_RACE 2>&1

	# IDEA - why not difference all 4 races by various tobacco/gold offsets ? #kstn
	#            gold            tobacco                                      # Good idea, implement it
	#             \/                /\                                        # as long as u detail the math
	# dwarves |  most         | the smallest                                  # below :) - Sigge
	# man     |  more         | smaller
	# elves   |  smaller      | more
	# hobbits |  the smallest | most
	#             
	case "$CHAR_RACE" in
	    2 ) echo "You chose to be an ELF"                 && OFFSET_GOLD=-3 && OFFSET_TOBACCO=2 ;;
	    3 ) echo "You chose to be a DWARF"                && OFFSET_GOLD=2 && OFFSET_TOBACCO=-3 ;;
	    4 ) echo "You chose to be a HOBBIT"               && OFFSET_GOLD=-3 && OFFSET_TOBACCO=2 ;;
	    * ) CHAR_RACE=1 && echo "You chose to be a HUMAN" && OFFSET_GOLD=2 && OFFSET_TOBACCO=-3 ;;
	esac

	# WEALTH formula = D20 + (D6 * CLASS OFFSET)
	CHAR_GOLD=$(    bc <<< "var = ( $(RollDice2 20) + ($OFFSET_GOLD    * $(RollDice2 6)) ); if (var > 0) var else 0" )
	CHAR_TOBACCO=$( bc <<< "var = ( $(RollDice2 20) + ($OFFSET_TOBACCO * $(RollDice2 6)) ); if (var > 0) var else 0" )

	# Determine initial food stock (D16 + 4) - player has 5 food minimum
	CHAR_FOOD=$( bc <<< "$(RollDice2 16) + 4" )
	
	# Set initial Value of Currencies
	VAL_GOLD=1        # Default 1
	VAL_TOBACCO=1     # Default 1
	
	# Set economic (in)stability
	VAL_CHANGE=0.15   # Default 0.15: 0.05 is very stable economy, 0.5 is very unstable.
	                  # IDEA If we add a (S)ettings page in (M)ain menu, this could be user-configurable.
	
	# Add location info
	CHAR_GPS="$START_LOCATION"
	CHAR_HOME="$START_LOCATION"
	# If there IS a CUSTOM.map file, ask where the player would like to start
	# TODO move it to LoadCustomMap()
	if [[ "$CUSTOM_MAP" ]] ; then
	    START_LOCATION=$(awk '{ if (/^START LOCATION:/) { print $2; exit; } print "'$START_LOCATION'"; }' <<< "$CUSTOM_MAP" )
	    read -p " HOME location for custom maps (ENTER for default $START_LOCATION): " CHAR_LOC 2>&1
	    [[ ! -z "$CHAR_LOC" ]] && BiaminSetup_SanityCheck "$CHAR_LOC" 	# Use user input as start location.. but first SANITY CHECK
	fi
	echo " Creating fresh character sheet for $CHAR ..."
	SaveCurrentSheet
}

#-----------------------------------------------------------------------
# BiaminSetup()
# Gets char name and load charsheet or make new char
# Used: runtime.sh
# TODO: Argumens: $CHAR(string)
#-----------------------------------------------------------------------
BiaminSetup() { 
    # Set CHARSHEET variable to gamedir/char.sheet (lowercase)
    CHARSHEET="$GAMEDIR/$(echo "$CHAR" | tr '[:upper:]' '[:lower:]' | tr -d " ").sheet"
    if [[ -f "$CHARSHEET" ]] ; then
	BiaminSetup_LoadCharsheet
    else
	BiaminSetup_MakeNewChar
    fi
    sleep 2
    BiaminSetup_SetRaceAbilities  "$CHAR_RACE"
    BiaminSetup_SetItemsAbilities "$CHAR_ITEMS"
    # If Cheating is disabled (in CONFIGURATION) restrict health to 150
    (( DISABLE_CHEATS == 1 )) && (( CHAR_HEALTH >= 150 )) && CHAR_HEALTH=150
}
#                                                                      #
#                                                                      #
########################################################################

########################################################################
#                              Fight mode                              #
#                      (secondary loop for fights)                     #

#-----------------------------------------------------------------------
# CheckForFight()
# Calls FightMode if player is attacked at current scenario or returns 0
# Arguments : $SCENARIO (char)
# Used : NewSector(), Rest()
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
    # Main idea is that Enemy hasn't fixed $EN_FLEE_EXP and $PL_FLEE_EXP but they are counts from main $EN_DEFEATED_EXP #kstn
    case "$ENEMY" in
	bandit )  EN_STRENGTH=1 ; EN_ACCURACY=4 ; EN_FLEE=7 ; EN_HEALTH=30  ; EN_FLEE_THRESHOLD=18 ; EN_DEFEATED_EXP=20   ;; 
	imp )     EN_STRENGTH=2 ; EN_ACCURACY=3 ; EN_FLEE=3 ; EN_HEALTH=20  ; EN_FLEE_THRESHOLD=10 ; EN_DEFEATED_EXP=10   ;; # TODO: test and confirm these
	goblin )  EN_STRENGTH=3 ; EN_ACCURACY=3 ; EN_FLEE=5 ; EN_HEALTH=30  ; EN_FLEE_THRESHOLD=15 ; EN_DEFEATED_EXP=30   ;; 
	boar )    EN_STRENGTH=4 ; EN_ACCURACY=2 ; EN_FLEE=3 ; EN_HEALTH=60  ; EN_FLEE_THRESHOLD=35 ; EN_DEFEATED_EXP=40   ;;
	orc )     EN_STRENGTH=4 ; EN_ACCURACY=4 ; EN_FLEE=4 ; EN_HEALTH=80  ; EN_FLEE_THRESHOLD=40 ; EN_DEFEATED_EXP=50   ;; 
	varg )    EN_STRENGTH=4 ; EN_ACCURACY=3 ; EN_FLEE=3 ; EN_HEALTH=80  ; EN_FLEE_THRESHOLD=60 ; EN_DEFEATED_EXP=100  ;;
	mage )    EN_STRENGTH=5 ; EN_ACCURACY=3 ; EN_FLEE=4 ; EN_HEALTH=90  ; EN_FLEE_THRESHOLD=45 ; EN_DEFEATED_EXP=150  ;;
	dragon )  EN_STRENGTH=5 ; EN_ACCURACY=4 ; EN_FLEE=2 ; EN_HEALTH=150 ; EN_FLEE_THRESHOLD=50 ; EN_DEFEATED_EXP=180  ;;
	chthulu ) EN_STRENGTH=6 ; EN_ACCURACY=5 ; EN_FLEE=1 ; EN_HEALTH=500 ; EN_FLEE_THRESHOLD=35 ; EN_DEFEATED_EXP=1000 ;;
	bear )    EN_STRENGTH=6 ; EN_ACCURACY=2 ; EN_FLEE=4 ; EN_HEALTH=160 ; EN_FLEE_THRESHOLD=25 ; EN_DEFEATED_EXP=60   ;; # TODO: test and confirm these
    esac
    # Temporary - after it'll be count in function ChecForExp()
    PL_FLEE_EXP=$((EN_DEFEATED_EXP / 4))       # - Exp player get if he manage to flee from enemy
    EN_FLEE_EXP=$((EN_DEFEATED_EXP / 2))       # - Exp player get if enemy manage to flee from him
    #
    ########################################################################

    ENEMY_NAME=$(Capitalize "$ENEMY") # Capitalize "enemy" to "Enemy" for FightMode_FightTable()
    
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
    GX_Monster "$ENEMY"
    sleep 1 # Pause to admire monster :) # TODO playtest, not sure if this is helping..
    if (( EN_ACCURACY > ACCURACY )) || ((PLAYER_RESTING)) ; then
	NEXT_TURN="en"
	# IDEA: different promts for different enemies ???
	(( PLAYER_RESTING == 1 )) && echo -e "You're awoken by an intruder, the $ENEMY attacks!" || echo "The $ENEMY has initiative"
    else
	NEXT_TURN="pl"
	echo -e "$CHAR has the initiative!\n"
	read -sn 1 -p "          Press (F) to Flee (P) to Pickpocket or (A)ny key to fight" FLEE_OPT 2>&1
	GX_Monster "$ENEMY" 
	# Firstly check for pickpocketing
	if [[ "$FLEE_OPT" == "p" || "$FLEE_OPT" == "P" ]]; then 
	    # TODO check this test
	    if (( $(RollDice2 6) > ACCURACY )) && (( $(RollDice2 6) < EN_ACCURACY )) ; then # 1st and 2nd check for pickpocket		    
		echo "You were unable to pickpocket from the ${ENEMY}!"           # Pickpocket falls
		NEXT_TURN="en"
	    else 
		echo -en "\nYou successfully stole the ${ENEMY}'s pouch, "        # "steal success" take loot
		case $(bc <<< "($EN_GOLD + $EN_TOBACCO) > 0") in                  # bc return 1 if true, 0 if false
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
	    RollDice 6
	    if (( DICE <= FLEE )) ; then
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
# FightMode_FightTable()
# Display enemy's GX, player and enemy abilities
# Used: FightMode()
#-----------------------------------------------------------------------
FightMode_FightTable() {  
    GX_Monster "$ENEMY"
    printf "%-12.12s\t\tHEALTH: %s\tStrength: %s\tAccuracy: %s\n" "$SHORTNAME" "$CHAR_HEALTH" "$STRENGTH" "$ACCURACY"
    printf "%-12.12s\t\tHEALTH: %s\tStrength: %s\tAccuracy: %s\n\n" "$ENEMY_NAME" "$EN_HEALTH" "$EN_STRENGTH" "$EN_ACCURACY"
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
    read -sn 1 -p "It's your turn, press any key to (R)oll or (F) to Flee" "FIGHT_PROMPT" 2>&1
    RollDice 6
    FightMode_FightTable
    echo -n "ROLL D6: $DICE "
    case "$FIGHT_PROMPT" in
	f | F ) # Player tries to flee!
	    RollDice 6 	# ????? Do we need it ??? #kstn
	    FightMode_FightFormula 6 le F
	    unset FIGHT_PROMPT
	    if (( DICE <= FLEE )); then # first check for flee
		(( DICE == FLEE )) && echo -n "$DICE =" || echo -n "$DICE <"
		echo -n " $FLEE ) You try to flee the battle .."
		sleep 2
		FightMode_FightTable
		RollDice 6
		FightMode_FightFormula 6 le eA
		if (( DICE <= EN_ACCURACY )); then # second check for flee
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
		echo -e "\tAccuracy [D6 $DICE <= $ACCURACY] Your weapon hits the target!"
		read -sn 1 -p "Press the R key to (R)oll for damage" "FIGHT_PROMPT" 2>&1
		RollDice 6
		echo -en "\nROLL D6: $DICE"
		DAMAGE=$(( DICE * STRENGTH ))
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
	RollDice 20
	if (( DICE < EN_FLEE )); then
	    echo -e "ROLL D20: ${DICE}\tThe $ENEMY uses an opportunity to flee!"
	    LUCK=1
	    unset FIGHTMODE
	    sleep 2
	    return 0 # bugfix: Fled enemy continue fighting..
	fi		
	FightMode_FightTable # If enemy didn't manage to run
    fi  # Enemy does not lose turn for trying for flee
    echo "It's the ${ENEMY}'s turn"
    sleep 2
    RollDice 6
    if (( DICE <= EN_ACCURACY )); then
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
	    Death # And CleanUp
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
	2)  # PLAYER died but saved by guardian angel or 1000 EXP
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
# Check how many GOLD, TOBACCO and EXP for pickpocketing player will
# get for this battle
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
	    echo "$CHAR gained $EN_PICKPOCKET_EXP Experience Points for successfully pickpocketing the ${ENEMY}!" ;
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
    if ((LUCK == 0)); then                       # Only if $ENEMY was slain
	if (( $(bc <<< "$EN_FOOD > 0") )); then	 #  and have some FOOD
	    echo "You scavenge $EN_FOOD food from the ${ENEMY}'s body"
	    CHAR_FOOD=$(bc <<< "$CHAR_FOOD + $EN_FOOD")
	fi
    fi
}

#-----------------------------------------------------------------------
# FightMode()
# Main fight loop.
#-----------------------------------------------------------------------
FightMode() {	# Used in NewSector() and Rest()
    FightMode_ResetFlags	# Reset all FightMode flags to default
    FightMode_DefineEnemy       # Define enemy for this battle
    FightMode_AddBonuses        # Set adjustments for items
    FightMode_DefineInitiative  # DETERMINE INITIATIVE (will usually be enemy)
    FightMode_RemoveBonuses     # Remove adjustments for items
    ############################ Main fight loop ###########################
    while ((FIGHTMODE)); do                                                     # If player didn't manage to run
	FightMode_FightTable                                                    # Display enemy GX, player and enemy abilities
	[[ "$NEXT_TURN" == "pl" ]] && FightMode_CharTurn || FightMode_EnemyTurn # Define which turn is and make it
	((CHAR_HEALTH <= 0)) || ((EN_HEALTH <= 0)) && unset FIGHTMODE           # Exit loop if player or enemy is dead
	[[ "$NEXT_TURN" == "pl" ]] && NEXT_TURN="en" || NEXT_TURN="pl"          #  or change initiative and next turn
	sleep 2			                                                #  after pause
    done
    ########################################################################
    FightMode_CheckForDeath	               # Check if player is alive
    FightMode_FightTable	               # Display enemy GX last time
    FightMode_CheckForExp "$LUCK"	       # 
    FightMode_CheckForPickpocket "$PICKPOCKET" # 
    FightMode_CheckForLoot	               # 
    SaveCurrentSheet
    sleep 6
    DisplayCharsheet
    [ -n PLAYER_RESTING ] && (( PLAYER_RESTING == 1 )) && DICE=111 # Bugfix: Don't roll for heal if pl was attacked.
}
#                                                                      #
#                                                                      #
########################################################################

########################################################################
#                           Game items                                 #
#                                                                      #

#-----------------------------------------------------------------------
# Items variables
# Used: ItemWasFound(), GX_Item(), FightMode_AddBonuses(),
#  FightMode_RemoveBonuses(), BiaminSetup_SetItemsAbilities()
#-----------------------------------------------------------------------
GIFT_OF_SIGHT=0
EMERALD_OF_NARCOLEPSY=1
GUARDIAN_ANGEL=2
FAST_MAGIC_BOOTS=3
QUICK_RABBIT_REACTION=4
FLASK_OF_TERRIBLE_ODOUR=5
TWO_HANDED_BROADSWORD=6
STEADY_HAND_BREW=7

MAX_ITEMS=8 # Maximum count of items

#-----------------------------------------------------------------------
# HaveItem()
# Check if player have this item
# Arguments: $ITEM(int)
#-----------------------------------------------------------------------
HaveItem() { (( $CHAR_ITEMS > $1 )) && return 0 || return 1; }

#-----------------------------------------------------------------------
# CheckHotzones()
# Check if this GPS is in the items array ($HOTZONES[])
# Arguments: $GPS(string [A-R][1-15])
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
HotzonesDistribute() { # 
    local ITEMS_2_SCATTER=$(( MAX_ITEMS - $1 ))               # Scatter only absent items 
    HOTZONE=()                                                # Reset HOTZONE
    while ((ITEMS_2_SCATTER > 0 )) ; do			      # If player already have all items, ITEMS_2_SCATTER'll be 0
	local ITEM=$(XYtoGPS $(RollDice2 18) $(RollDice2 15)) # Create random item GPS
	[[ "$ITEM" == "$CHAR_GPS" ]] && continue              # Reroll if HOTZONE == CHAR_GPS
	CheckHotzones "$ITEM" && continue                     # Reroll if "$ITEM" is already in ${HOTZONE[@]}
	((ITEMS_2_SCATTER--))                                 # Decrease ITEMS_2_SCATTER (because array starts from ${HOTZONE[0]} #kstn)
	HOTZONE["$ITEMS_2_SCATTER"]="$ITEM"                   # Init ${HOTZONE[ITEMS_2_SCATTER]},
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
CheckForItem() { (( $1 < MAX_ITEMS )) && CheckHotzones $1 && ItemWasFound ; }

#                                                                      #
#                                                                      #
########################################################################

########################################################################
#                      All char-related functions                      #
#                                                                      #







#                                                                      #
#                                                                      #
########################################################################

########################################################################
#                          Dice game in tavern                         #
#                                                                      #

#-----------------------------------------------------------------------
# $DICE_GAME_CHANCES
# Chances (%) of any player picking the resulting number
# Fixed, so declared as array
# Player can't dice 0 or 1 so ${DICE_GAME_CHANCES[0]} and
# ${DICE_GAME_CHANCES[1]} are dummy
#-----------------------------------------------------------------------
#               dice1+dice2    = 0        1      2 3 4 5  6  7  8  9  10 11 12 
declare -r -a DICE_GAME_CHANCES=("dummy" "dummy" 3 6 9 12 14 17 14 12 9  6  3)

#-----------------------------------------------------------------------
# $DICE_GAME_WINNINGS
# % of POT (initial DGAME_WINNINGS) to be paid out given DGAME_RESULT (odds)
# Fixed, so declared as array
# Player can't dice 0 or 1 so ${DICE_GAME_WINNINGS[0]} and
# ${DICE_GAME_WINNINGS[1]} are dummy
#-----------------------------------------------------------------------
#                dice1+dice2    =  0       1       2   3  4  5  6  7  8  9  10 11 12
declare -r -a DICE_GAME_WINNINGS=("dummy" "dummy" 100 85 70 55 40 25 40 55 70 85 100)

#-----------------------------------------------------------------------
# MiniGame_Dice()
# Small dice based minigame.
# Used: Tavern()
#-----------------------------------------------------------------------
MiniGame_Dice() { 
	DGAME_PLAYERS=$((RANDOM%6)) # How many players currently at the table (0-5 players)
	GX_DiceGame_Table
	case "$DGAME_PLAYERS" in # Ask whether player wants to join
	    0 ) read -sn1 -p "There's no one at the table. May be you should come back later?" 2>&1 && return 0 ;; # leave
	    1 ) read -sn1 -p "There's a gambler wanting to roll dice for $DGAME_STAKES Gold a piece. Want to [J]oin?" JOIN_DICE_GAME 2>&1 ;;
	    * ) read -sn1 -p "There are $DGAME_PLAYERS players rolling dice for $DGAME_STAKES Gold a piece. Want to [J]oin?" JOIN_DICE_GAME 2>&1 ;;	    
	esac
	case "$JOIN_DICE_GAME" in
	    j | J | y | Y ) ;;                                  # Game on! Do nothing.
	    * ) echo -e "\nToo high stakes for you, $CHAR_RACE_STR?" ; sleep 2; return 0;; # Leave.
	esac	
	DGAME_STAKES=$( bc <<< "$(RollDice2 6) * $VAL_CHANGE" ) # Determine stake size (min 0.25, max 1.5)	
	if (( $(bc <<< "$CHAR_GOLD <= $DGAME_STAKES") )); then  # Check if player can afford it
	    read -sn1 -p "No one plays with a poor, Goldless $CHAR_RACE_STR! Come back when you've got it.." 2>&1
	    return 0 # leave
	fi

	GAME_ROUND=1
	CHAR_GOLD=$(bc <<< "$CHAR_GOLD - $DGAME_STAKES" )
	echo -e "\nYou put down $DGAME_STAKES Gold and pull out a chair .. [ -$DGAME_STAKES Gold ]" && sleep 3
		
	DGAME_POT=$( bc <<< "$DGAME_STAKES * ( $DGAME_PLAYERS + 1 )" ) # Determine starting pot size
	
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

	    DGAME_COMP=${DICE_GAME_CHANCES[$DGAME_GUESS]} # Determine if we're sharing the bet based on odds percentage.. 

	    # Run that through a loop of players num and % dice..
	    DGAME_COMPETITION=0
	    for ((i=0; i < DGAME_PLAYERS; i++)); do
		(( $(RollDice2 100) <= DGAME_COMP )) && (( DGAME_COMPETITION++ )) # Sharing!
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
	    DGAME_WINNINGS=$( bc <<< "$DGAME_POT * ${DICE_GAME_WINNINGS[$DGAME_RESULT]}" )

	    if (( DGAME_GUESS == DGAME_RESULT )) ; then # You won
   		DGAME_POT=$( bc <<< "$DGAME_POT - $DGAME_WINNINGS" )  # Adjust winnings to odds
		DGAME_WINNINGS=$( bc <<< "$DGAME_WINNINGS / ( $DGAME_COMPETITION + 1 )" ) # no competition = winnings/1
		echo "You rolled $DGAME_RESULT and won $DGAME_WINNINGS Gold! [ +$DGAME_WINNINGS Gold ]"
		CHAR_GOLD=$( bc <<< "$CHAR_GOLD + $DGAME_WINNINGS" )
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

########################################################################
#                               Almanac                                #
#                                                                      #


# GAME ACTION: USE INV_ALMANAC (MOON info, NOTES, MAIN info)
Almanac_Moon() { # Used in Almanac()
    GX_CharSheet 2 # Display GX Header with ALMANAC header
    # Substitute "NOTES" with MOON string in banner
    tput sc
    case "$MOON" in
	"Full Moon" | "New Moon" | "Old Moon" )                    MvAddStr 6 27 " ${MOON^^} "                  ;;
	"First Quarter" | "Third Quarter")                         MvAddStr 6 16 "THE MOON IS IN THE ${MOON^^}" ;;
	"Waning Gibbous" | "Growing Gibbous" | "Waning Crescent" ) MvAddStr 6 25 "${MOON^^}"                    ;;
	"Growing Crescent" )                                       MvAddStr 6 24 "${MOON^^}"                    ;;
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

    # TODO Add Left-aligned text "box" (without borders)
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

Almanac_Notes() {
    GX_CharSheet 2 # Display GX banner with ALMANAC header
    tput sc
    MvAddStr 6 28 "N O T E S" # add"NOTES" subheader
    tput rc
    [ -z "$CHAR_NOTES" ] && echo -e " In the back of your almanac, there is a page reserved for Your Notes.\n There is only room for 10 lines, but you may erase obsolete information.\n"

    # TODO
    # Add creation of mktemp CHAR.notes file that is referenced in $CHARSHEET
    # OR add NOTE0-NOTE9 in .sheet file.
    # Add opportunity to list (default action in Almanac_Notes), (A)dd or (E)rase notes.
    # Notes are "named" by numbers 0-9.
    # Notes may not exceed arbitrary ASCII-friendly length.
    # Notes must be superficially "cleaned" OR we can simply "list" them with cat <<"EOT".
    # 	Just deny user to input EOT :)
    echo "$HR"
    read -n 1 ### debug
} # Return to Almanac()



#-----------------------------------------------------------------------
# Almanac()
# Almanac (calendar).
# Used: DisplayCharsheet()
# TODO: FIX_DATE !!!
# TODO: The Almanac must be "unlocked" in gameplay, e.g. bought from Merchant. This is random (20% chance he has one)
# TODO: when INV_ALMANAC=1 add NOTES 0-9 in charsheet.
#-----------------------------------------------------------------------
Almanac() { 
    GX_CharSheet 2 # Display GX banner with ALMANAC header
    # Add DATE string subheader
    ((WEEKDAY_NUM == 0)) && local ALMANAC_SUB="Ringday $DAY of $MONTH" || local ALMANAC_SUB="$(WeekdayString $WEEKDAY_NUM) $DAY of $MONTH"
    tput sc
    MvAddStr 6 $((32 - ( $(Strlen "$ALMANAC_SUB") / 2) )) "$ALMANAC_SUB" # centered sub
    tput rc

    # Calculate which day the first of the month is
    # Source: en.wikipedia.org/wiki/Determination_of_the_day_of_the_week
    case "$MONTH_NUM" in # month table (without leap years) # add _REMAINDER to DateFromTurn()
	1 | 10 )     local FIMON=0 ;;
	2 | 3 | 11 ) local FIMON=3 ;;
	4 | 7 )      local FIMON=6 ;;
	5 )          local FIMON=1 ;;
	6 )          local FIMON=4 ;;
	8 )          local FIMON=2 ;;
	9 | 12 )     local FIMON=5 ;;
    esac

    case $(bc <<< "$YEAR % 100") in # last 2 of year
	00 | 06 | 17 | 23 | 28 | 34 | 45 | 51 | 56 | 62 | 73 | 79 | 84 | 90 )      local FIYEA=0 ;;
	01 | 07 | 12 | 18 | 29 | 35 | 40 | 46 | 57 | 63 | 68 | 74 | 85 | 91 | 96 ) local FIYEA=1 ;;
	02 | 13 | 19 | 24 | 30 | 41 | 47 | 52 | 58 | 69 | 75 | 80 | 86 | 97 )      local FIYEA=2 ;;
	03 | 08 | 14 | 25 | 31 | 36 | 42 | 53 | 59 | 64 | 70 | 81 | 87 | 92 | 98 ) local FIYEA=3 ;;
	09 | 15 | 20 | 26 | 37 | 43 | 48 | 54 | 65 | 71 | 76 | 82 | 93 | 99 )      local FIYEA=4 ;;
	04 | 10 | 21 | 27 | 32 | 38 | 49 | 55 | 60 | 66 | 77 | 83 | 88 | 94 )      local FIYEA=5 ;;
	05 | 11 | 16 | 22 | 33 | 39 | 44 | 50 | 61 | 67 | 72 | 78 | 89 | 95 )      local FIYEA=6 ;;
    esac

    case "$CENTURY" in # centuries
         90 | 400 |  800 | 1200 | 1600 | 2000 ) local FICEN=6 ;; # way too big :P
	100 | 500 |  900 | 1300 | 1700 )        local FICEN=4 ;; # TODO: Trim it
	200 | 600 | 1000 | 1400 | 1800 )        local FICEN=2 ;; # This table
	300 | 700 | 1100 | 1500 | 1900 )        local FICEN=0 ;; # is currently

    esac

    # LEGEND: d+m+y+(y/4)+c mod 7
    # If the result is 0, the date was a Ringday (Sunday), 1 Moonday (Monday) etc.
    FIRSTDAY=$(bc <<< "(1 + $FIMON + $FIYEA + ($FIYEA/4) + $FICEN) % 7")
    # DRAW CALENDAR
    cat <<"EOT"
                                                     ringday
           Mo Be Mi Ba Me Wa Ri              washday    o    moonday  
                                                     o . . o
                                         melethday  o . x . o  brenday
                                                     o . . o
                                             braigday   o   midweek
                                                       .^.

EOT

    # DRAWING CALENDAR
    #    local WEEKDAY_NUM=$FIRSTDAY
    local MONTH_LENGTH=$(MonthLength "$MONTH_NUM")
    local ARRAY=()
    local COUNT=0    

    SPACES=$(( (FIRSTDAY + 6) % 7 ))
    while ((SPACES--)); do 
	ARRAY[((COUNT))]+="   ";
    done

    for i in $(seq 1 "$MONTH_LENGTH") ; do
	ARRAY[((COUNT))]+=$(printf '%2s ' $i;)
	[[ $(awk '{print length;}' <<< "${ARRAY[$COUNT]}") -eq 21 ]] && ((COUNT++));
    done

    tput sc
    COUNT=0
    local YPOS=11
    while (true) ; do
	tput cup $YPOS 11 
	printf "%s\n" "${ARRAY[$COUNT]}";
	[[ ${ARRAY[((++COUNT))]} ]] || break
	(( YPOS++ ))
    done
    tput rc
    # DONE DRAVING CALENDAR


     # Add MONTH HEADER to CALENDAR
     tput sc
     case $(Strlen $(MonthString "$MONTH_NUM")) in
	 18 | 17 ) MvAddStr 9 13 "${MONTH^}" ;;
	 13      ) MvAddStr 9 14 "${MONTH^}" ;;
	 12 | 11 ) MvAddStr 9 15 "${MONTH^}" ;;
	 10 | 9  ) MvAddStr 9 16 "${MONTH^}" ;;
	 8       ) MvAddStr 9 17 "${MONTH^}" ;;
     esac 
     tput rc

     # Magnify WEEKDAY in HEPTOGRAM
     tput sc
     case $(WeekdayString "$WEEKDAY_NUM") in
	 "Ringday (Holiday)" ) tput cup 9 53 ;;
	 "Moonday" )   tput cup 10 61        ;;
	 "Brenday" )   tput cup 12 63        ;;
	 "Midweek" )   tput cup 14 60        ;;
	 "Braigday" )  tput cup 14 45        ;;
	 "Melethday" ) tput cup 12 41        ;;
	 "Washday" )   tput cup 10 45        ;;
     esac
     ((WEEKDAY_NUM == 0))  && echo "RINGDAY" || echo "$(Toupper $(WeekdayString "$WEEKDAY_NUM"))"
     tput rc

     # Add MOON PHASE to HEPTOGRAM (bottom)
     tput sc
     case "$MOON" in
	 "Old Moon" | "New Moon" | "Full Moon" )                      MvAddStr 16 52 "$(Toupper $MOON)" ;;
	 "First Quarter" | "Third Quarter" | "Waning Gibbous" )       MvAddStr 16 50 "$(Toupper $MOON)" ;;
	 "Growing Gibbous" | "Waning Crescent" | "Growing Crescent" ) MvAddStr 16 49 "$(Toupper $MOON)" ;;
     esac
     tput rc

     local TRIVIA_HEADER="$(WeekdayString "$WEEKDAY_NUM") - $(WeekdayTriviaShort "$WEEKDAY_NUM")" # Add DEFAULT Trivia header

     # Add PARTICULAR Trivia body
     # Database of significant constellations of dates, months and phases

     # CUSTOM Powerful combinations (may overrule the above AND have gameplay consequences)
     case "$DAY+$MONTH_REMINDER+$MOON" in
	 "12+12+Full Moon" ) local TRIVIA1="Very holy" && local TRIVIA2="Yes, indeed. [+1 LUCK]" ;;
     esac
     # TODO IDEA These powerful combos can adjust things like luck, animal attacks etc.
     # TODO make custom trivia a separate function instead..

     if [ -z "$TRIVIA1" ] && [ -z "$TRIVIA2" ] ; then
	 case "$(WeekdayString $WEEKDAY_NUM)+$MOON" in
	     "Moonday+Full Moon" ) local TRIVIA1="A Full Moon on Moon's day is considered a powerful combination." ;;
	     "Moonday+Waning Crescent" ) local TRIVIA1="An aging Crescent on Moon's Day makes evil magic more powerful." ;;
	     "Brenday+New Moon" )  local TRIVIA1="New Moon on Brenia's day means your courage will be needed." ;;
	     "Midweek+Old Moon" )  local TRIVIA1="An old moon midweek is the cause of imbalance. Show great care." ;;
	     "Ringday (Holiday)+New Moon" ) local TRIVIA1="New Moon on Ringday is a blessed combination. Be joyeful!" ;;
	     * ) local TRIVIA1=$(WeekdayTriviaLong "$WEEKDAY_NUM") ;;                     # display default info about the day
	 esac

	 # CUSTOM Month and Moon combinations (TRIVIA2)
	 case "$(MonthString $MONTH_NUM)+$MOON" in
	     "Harvest Month+Growing Crescent" ) local TRIVIA2="A Growing Crescent in Harvest Month foretells a Good harvest!" ;;
	     "Ringorin+Old Moon" ) local TRIVIA2="An Old Moon in Ringorin means the ancestors are watching. Tread Careful." ;;
	     "Ringorin+New Moon" ) local TRIVIA2="A New Moon in Ringorin is a good omen for the future if the aim is true." ;;
	     "Marrsuckur+Waning Crescent" ) local TRIVIA2="A crescent declining during Marrow-sucker sometimes foretell Starvation." ;;
	     * ) local TRIVIA2="$(MonthString $MONTH_NUM) - $(MonthTrivia $MONTH_NUM)" ;; # display default info about the month
	 esac
     fi

     # Output Trivia (mind the space before sentences)
     echo -e " $TRIVIA_HEADER\n $TRIVIA1\n\n $TRIVIA2"
     echo "$HR"
     read -sn 1 -p "$(MakePrompt '(R)eturn')" # TODO change/update when features are ready
# TODO v. 3
#    read -sn 1 -p "$(MakePrompt '(M)oon phase;(N)otes;(R)eturn')" ALM_OPT 2>&1
#    case "$ALM_OPT" in
#	 M | m ) Almanac_Moon ;;
#	 N | n ) Almanac_Notes ;;
#     esac
#    unset ALM_OPT
 } # Return to DisplayCharsheet()


#                                                                      #
#                                                                      #
########################################################################

########################################################################
#                             GX_Bulletin                              #
#                                                                      #



## WORLD EVENT functions

WorldPriceFixing() { # Used in WorldChangeEconomy() and Intro()
    local VAL_FOOD=1 # Why constant? Player eats .25/day, so it's always true that 1 FOOD = 4 turns.
    # Warning! Old-style echo used on purpose here. Otherwise bc gives "illegal char" due to \n CRs 
    # O_o. Are you sure that all is right with your encoding settings? #kstn
    # No I'm not sure. Please test and report :)
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

########################################################################
#                        Town (secondary loop)                         #
#                                                                      #

# Quick tip: use echo "_____________DEBUG whatever______________" >2 # DEBUG
# To output debug data to debugger (and not to stdout).


#-----------------------------------------------------------------------
# CheckForGold()
# Check if char have $PRICE Gold and divide it from $CHAR_GOLD or
#  return $FAILURE_VESSAGE
# Arguments: $PRICE(int), $FAILURE_VESSAGE(string)
# Used: Tavern()
#-----------------------------------------------------------------------
CheckForGold()   {
    if (( $(bc <<< "$CHAR_GOLD < $1") )); then
	echo -e "${CLEAR_LINE}${2}"               # Idea: If we're going to use these in grocer, merchant ++future functions then perhaps it should ONLY be logical (return 1 or 0).
	return 1                                  # I think it will make the code easier to read later on, see the difference between:
    else                                      # CheckForGold 3 "You don't have enough gold, silly dwarf"
	CHAR_GOLD=$(bc <<< "$CHAR_GOLD - $1")     # # vs
	return 0                                  # CheckForGold 3 && Continue_transaction || echo "You don't have enough gold, silly dwarf!"
    fi                                        #
}                                             # The first one looks as if the silly dwarf doesn't have enough gold from the get go..?
# On the other hand, a "purchasing function" might be called for, so we don't duplicate so much work.

#-----------------------------------------------------------------------
# CheckForTobacco()
# Check if char have $PRICE Tobacco and divide it from $CHAR_TOBACCO or
#  return $FAILURE_VESSAGE
# Arguments: $PRICE(int), $FAILURE_VESSAGE(string)
# Used: Tavern()
#-----------------------------------------------------------------------
CheckForTobacco() {
    if (( $(bc <<< "$CHAR_TOBACCO < $1") )); then
	echo -e "${CLEAR_LINE}${2}"
	return 1
    else
	CHAR_TOBACCO=$(bc <<< "$CHAR_TOBACCO - $1")
	return 0
    fi
}

#-----------------------------------------------------------------------
# Tavern_Rest()
# Successful rest in Tavern (Tavern gained +30 HEALTH - Town*2 )
# Used: Tavern()
#-----------------------------------------------------------------------
TavernRest() {
    GX_Rest
    echo -n "You got some much needed rest .."
    if (( CHAR_HEALTH < 150 )); then
	(( CHAR_HEALTH += 30 ))			   # Add Town_Health * 2
	(( CHAR_HEALTH > 150 )) && CHAR_HEALTH=150 # And restrict if to 150
	echo " and your HEALTH is $CHAR_HEALTH now"
    fi
    NewTurn
}

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
	    r | R) 
		echo -en "${CLEAR_LINE}      rent for 1 (G)old      rent for 1 (T)obacco      (A)ny key to Exit"
		case $(Read) in
		    g | G ) CheckForGold 1    "You don't have enough Gold to rent a room in the Tavern"    && TavernRest ;;
		    t | T ) CheckForTobacco 1 "You don't have enough Tobacco to rent a room in the Tavern" && TavernRest ;;
		esac 
		sleep 1 ;;
 	    p | P ) MiniGame_Dice ;;
	    * ) break ;; # Leave tavern
	esac
    done
} 



#-----------------------------------------------------------------------
# Marketplace()                                                  Town.sh
# Used: GoIntoTown()
#-----------------------------------------------------------------------
Marketplace() { 
    # The PRICE of a unit (food, ale) is always 1. #??? #kstn
    while (true); do
	GX_Marketplace
	MakePrompt '(G)rocer;(M)erchant;(B)eggar;(L)eave;(Q)uit'
	case $(Read) in
	    b | B) Marketplace_Beggar;;
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
	MvAddStr 6 4 "$MERCHANT_ITEM, it can be yours"
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
	case "$DICE" in                                                              # Merchant WANTS to buy and only reluctantly sells:
		1 ) MERCHANT_FxG=$( bc <<< "scale=2;$MERCHANT_FxG+$MERCHANT_MARGIN" )    # Food (player's cost in gold purchasing food)
		MERCHANT_GxF=$( bc <<< "scale=2;$MERCHANT_GxF-$MERCHANT_MARGIN" )        # Food (player's discount in food purchasing gold) 
		MERCHANT_FxT=$( bc <<< "scale=2;$MERCHANT_FxT+$MERCHANT_MARGIN" )
		MERCHANT_TxF=$( bc <<< "scale=2;$MERCHANT_TxF-$MERCHANT_MARGIN" ) ;;
		2 ) MERCHANT_TxG=$( bc <<< "scale=2;$MERCHANT_TxG+$MERCHANT_MARGIN" )    # Tobacco (player's cost in gold purchasing tobacco)
		MERCHANT_GxT=$( bc <<< "scale=2;$MERCHANT_GxT-$MERCHANT_MARGIN" )        # Tobacco (player's discount in tobacco purchasing gold) 
		MERCHANT_TxF=$( bc <<< "scale=2;$MERCHANT_TxF+$MERCHANT_MARGIN" )
		MERCHANT_FxT=$( bc <<< "scale=2;$MERCHANT_FxT-$MERCHANT_MARGIN" ) ;;
		3 ) MERCHANT_GxF=$( bc <<< "scale=2;$MERCHANT_GxF+$MERCHANT_MARGIN" )    # Gold (player's cost in food purchasing gold)
		MERCHANT_FxG=$( bc <<< "scale=2;$MERCHANT_FxG-$MERCHANT_MARGIN" )        # Gold (player's discount in gold purchasing food)
		MERCHANT_GxT=$( bc <<< "scale=2;$MERCHANT_GxT+$MERCHANT_MARGIN" )
		MERCHANT_TxG=$( bc <<< "scale=2;$MERCHANT_TxG-$MERCHANT_MARGIN" )
		MERCHANT_GxI=$( bc <<< "scale=2;$MERCHANT_GxI+$MERCHANT_MARGIN" )        # You can only buy/sell items with gold
		MERCHANT_IxG=$( bc <<< "scale=2;$MERCHANT_IxG-$MERCHANT_MARGIN" ) ;;
	esac
	
	# Set any value equal or below 0 to defaults
	# Ugly yet POSIX compliant code from mywiki.wooledge.org/BashFAQ/022
	case $(bc <<< "scale=2;$MERCHANT_FxG - 0.00" ) in # TODO simplify/loop this instead..?
	    0 | -*) MERCHANT_FxG=$PRICE_FxG ;;
	esac
	case $(bc <<< "scale=2;$MERCHANT_GxF - 0.00" ) in
	    0 | -*) MERCHANT_GxF=$PRICE_GxF ;;
	esac
	case $(bc <<< "scale=2;$MERCHANT_FxT - 0.00" ) in
	    0 | -*) MERCHANT_FxT=$PRICE_FxT ;;
	esac
	case $(bc <<< "scale=2;$MERCHANT_TxF - 0.00" ) in
	    0 | -*) MERCHANT_TxF=$PRICE_TxF  ;;
	esac
	case $(bc <<< "scale=2;$MERCHANT_GxT - 0.00" ) in
	    0 | -*) MERCHANT_GxT=$PRICE_GxT ;;
	esac
	case $(bc <<< "scale=2;$MERCHANT_TxG - 0.00" ) in
	    0 | -*) MERCHANT_TxG=$PRICE_TxG  ;;
	esac
	case $(bc <<< "scale=2;$MERCHANT_GxI - 0.00" ) in
	    0 | -*) MERCHANT_GxI=$PRICE_GxI ;;
	esac
	case $(bc <<< "scale=2;$MERCHANT_IxG - 0.00" ) in
	    0 | -*) MERCHANT_IxG=$PRICE_IxG ;;
	esac

	# Merchant sells this item (but will buy e.g. fur, tusks etc.)
	RollDice 8
	case "$DICE" in
	    1 ) MERCHANT_ITEM="Health Potion (5 HP)"  ;; # TODO
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
	local QUANTITY && local COST_GOLD && local COST_TOBACCO && local COST_FOOD && local COST_ITEM && local TRANSACTION_STATUS && local BARGAIN_TYPE
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
	    echo "        DEBUG       Summary AFTER transaction" >2
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
		    MERCHANT_CONFIRMATION+=" $QUANTITY $MERCHANDISE for [ "
		    case "$PAYMENT" in
			"Tobacco" ) MERCHANT_CONFIRMATION+="$COST_TOBACCO Tobacco "
				        (( BARGAIN_TYPE == 1 )) && MERCHANT_CONFIRMATION+="-$COST_TOBACCO" || MERCHANT_CONFIRMATION+="+$COST_TOBACCO" ;;
			"Food" )    MERCHANT_CONFIRMATION_1+="$COST_FOOD Food "
				        (( BARGAIN_TYPE == 1 )) && MERCHANT_CONFIRMATION+="-$COST_FOOD"    || MERCHANT_CONFIRMATION+="+$COST_FOOD" ;;
			"Gold" )    MERCHANT_CONFIRMATION_1+="$COST_GOLD Gold "
				        (( BARGAIN_TYPE == 1 )) && MERCHANT_CONFIRMATION+="-$COST_GOLD"    || MERCHANT_CONFIRMATION+="+$COST_GOLD" ;;
			# Item ) # TODO v. 3 (selling pelts n stuff)
		    esac
		    MERCHANT_CONFIRMATION+="${PAYMENT^^} & [ "
			(( BARGAIN_TYPE == 1 )) && MERCHANT_CONFIRMATION+="+ $QUANTITY "
		    (( BARGAIN_TYPE == 2 )) && MERCHANT_CONFIRMATION+="- $QUANTITY "
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
		echo -n "$MERCHANT_CONFIRMATION  " && read -sn 1 -t 6
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
	    [ -n "$MERCHANT_CONFIRMATION_1" ] && unset MERCHANT_CONFIRMATION_1
	    [ -n "$MERCHANT_CONFIRMATION_2" ] && unset MERCHANT_CONFIRMATION_2
	    
	    (( TRANSACTION_STATUS != 0 )) && PressAnyKey # Return to zero
	    (( TRANSACTION_STATUS == 3 )) && break       # Leave loop if we're not interested

	fi
    done
} # Return to Marketplace

#-----------------------------------------------------------------------
# Marketplace_Grocer()
# Used: GoIntoTown()
# IDEA:
# ? Add stealing from market??? 
#   Good idea, but we'd have to arrange a fight and new enemy type (shopkeep)..
#   Or he call the police (the guards?) and they throw player from town? (kstn)
#-----------------------------------------------------------------------
Marketplace_Grocer() { 
    # The PRICE of units are set in WorldPriceFixing()
    while (true); do
	GX_Marketplace_Grocer
	tput sc                                      # save cursor position
	MvAddStr 10 4 "1 FOOD costs $PRICE_FxG Gold" # move to y=10, x=4 ( upper left corner is 0 0 )
	MvAddStr 11 4  "or $PRICE_FxT Tobacco.\""    # move to y=11, x=4 ( upper left corner is 0 0 )
	tput rc                                      # restore cursor position
	echo " Welcome to my shoppe, stranger! We have the right prices for you .." # Will be in GX_..
	echo " You currently have $CHAR_GOLD Gold, $CHAR_TOBACCO Tobacco and $CHAR_FOOD Food in your inventory"
	MakePrompt 'Trade for (G)old;Trade for (T)obacco;(L)eave'
	case $(Read) in
	    g | G )
		GX_Marketplace_Grocer
		read -p " How many food items do you want to buy? " QUANTITY 2>&1
		# TODO check for QUANTITY - if falls if QUANTITY != [0-9]+
		# TODO Perhaps this could help: stackoverflow.com/questions/806906/how-do-i-test-if-a-variable-is-a-number-in-bash
		local COST=$( bc <<< "$PRICE_FxG * $QUANTITY" )
		if (( $(bc <<< "$CHAR_GOLD > $COST") )); then
		    CHAR_GOLD=$(bc <<< "$CHAR_GOLD - $COST")
		    CHAR_FOOD=$(bc <<< "${CHAR_FOOD} + ${QUANTITY}")
		    echo " You bought $QUANTITY food for $COST Gold, and you have $CHAR_FOOD Food in your inventory"
		else
		    echo " You don't have enough Gold to buy $QUANTITY food yet. Try a little less!"
		fi
		read -n 1		
		;;
	    t | T )
		GX_Marketplace_Grocer
		read -p " How much food you want to buy? " QUANTITY 2>&1
		# TODO check for QUANTITY - if falls if QUANTITY != [0-9]+
		local COST=$( bc <<< "${PRICE_FxT} * $QUANTITY" )
		if (( $(bc <<< "$CHAR_TOBACCO > $COST") )); then
		    CHAR_TOBACCO=$(bc <<< "$CHAR_TOBACCO - $COST")
		    CHAR_FOOD=$(bc <<< "${CHAR_FOOD} + ${QUANTITY}")
		    echo " You traded $COST Tobacco for $QUANTITY food, and have $CHAR_FOOD Food in your inventory"
		else
		    echo " You don't have enough Tobacco to trade for $QUANTITY food yet. Try a little less!"
		fi
		read -n 1		
		;;
	    *) break;
	esac
    done
    unset PRICE_IN_GOLD PRICE_IN_TOBACCO
} # Return to GoIntoTown()


#-----------------------------------------------------------------------
# Marketplace_Beggar()                                           Town.sh
# Used: GoIntoTown()
#-----------------------------------------------------------------------
Marketplace_Beggar() {
	GX_Marketplace_Beggar
	local B_Y=4                # Setup default greeting
	local BEGGAR_MSG=("" "Traveller from afar" "Forest Child" "Mountain Warrior" "Master Hobbit") # [0] is dummy
    if [ -z "$BEGGAR" ] || [ "$BEGGAR" != "$CHAR_GPS" ] ; then 	# "Name" this beggar as GPS location
	BEGGAR="$CHAR_GPS"
	tput sc && MvAddStr $B_Y 4 "Kind ${BEGGAR_MSG[$CHAR_RACE]} .."
	# Add mercy plea dependent on race (for $DEITY) vs. history/religion.
#	(( M_Y++ ))                            #lllllllllllllllllllllllllllllllllllll#
#	local MERCHANT_MSG=( "" "" "" "" "" "" "Please, " "to provide the Finest Merchandise" "in the Realm, and at the best"
#			     "possible prices! I buy everything" "and sell only the best, 'tis true!" "" "What are you looking for?" )  && (( M_Y++ )) # [0-5,11] are dummies
#	while (( M_Y <= 12 )) ; do # Output default greeting
#	    MvAddStr $M_Y 4 "${MERCHANT_MSG[$M_Y]}"
#	    (( M_Y++ ))
#	done
	tput rc
	else
	tput sc && MvAddStr $B_Y 4 "Hello again, ${BEGGAR_MSG[$CHAR_RACE]} .."
	tput rc
	fi
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
    awk '{
          print index("ABCDEFGHIJKLMNOPQR", substr($0, 1 ,1));
          print substr($0, 2);
         }' <<< "$1"
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
    read -r MAP_X MAP_Y <<< $(GPStoXY "$CHAR_GPS") # Fixes LOCATION in CHAR_GPS "A1" to a place on the MapNav "X1,Y1"
    if [[ "$1" == "m" || "$1" == "M" ]] ; then	# If player want to see the map
	GX_Map
	# If COLOR==0, YELLOW and RESET =="" so string'll be without any colors
	echo -e " ${YELLOW}o ${CHAR}${RESET} is currently in $CHAR_GPS ($PLACE)\n$HR" # PLACE var defined in GX_Place()
	read -sn 1 -p " I want to go  (W) North  (A) West  (S)outh  (D) East  (Q)uit :  " DEST 2>&1
    else  # The player did NOT toggle map, just moved without looking from NewSector()..
	DEST="$1"
	GX_Place "$SCENARIO"    # Shows the _current_ scenario scene, not the destination's.
    fi

    case "$DEST" in # Fix for 80x24. Dirty but better than nothing #kstn
	w | W | n | N ) echo -n "You go North"; # Going North (Reversed: Y-1)
	    (( MAP_Y != 1  )) && (( MAP_Y-- )) || echo -en "${CLEAR_LINE}You wanted to visit Santa, but walked in a circle.." ;;
	d | D | e | E ) echo -n "You go East" # Going East (X+1)
	    (( MAP_X != 18 )) && (( MAP_X++ )) || echo -en "${CLEAR_LINE}You tried to go East of the map, but walked in a circle.." ;;
	s | S ) echo -n "You go South" # Going South (Reversed: Y+1)
	    (( MAP_Y != 15 )) && (( MAP_Y++ )) || echo -en "${CLEAR_LINE}You tried to go someplace warm, but walked in a circle.." ;; 
	a | A ) echo -n "You go West" # Going West (X-1)
	    (( MAP_X != 1  )) && (( MAP_X-- )) || echo -en "${CLEAR_LINE}You tried to go West of the map, but walked in a circle.." ;;
	q | Q ) CleanUp ;; # Save and exit
	* ) echo -n "Loitering.."
    esac
    CHAR_GPS=$(XYtoGPS "$MAP_X" "$MAP_Y") # Translate MAP_X numeric back to A-R
    sleep 1.5 # Merged with sleep from 'case "$DEST"' section
}

#-----------------------------------------------------------------------
# NewSector_GetScenario()
# Get scenario char at current GPS
# Arguments: $CHAR_GPS(string[A-R][1-15])
#-----------------------------------------------------------------------
NewSector_GetScenario() {
    read -r MAP_X MAP_Y <<< $(GPStoXY "$1") # Fixes LOCATION in CHAR_GPS "A1" to a place on the MapNav "X1,Y1"
    awk '{ if ( NR == '$((MAP_Y+2))') { print $'$((MAP_X+2))'; }}' <<< "$MAP" # MAP_Y+2 MAP_X+2 - padding for borders
}

#-----------------------------------------------------------------------
# NewTurn()
# Increase turn and get date
# Used: NewSector(), TavernRest()
#-----------------------------------------------------------------------
NewTurn() {
    ((TURN++)) # Nev turn, new date
    DateFromTurn # Get year, month, day, weekday
}
    
#-----------------------------------------------------------------------
# NewSector()
# Main game loop
# Used in runtime section
#-----------------------------------------------------------------------
NewSector() { 
    while (true); do  # While (player-is-alive) :) 
	NewTurn
	CheckForItem "$CHAR_GPS" # Look for treasure @ current GPS location  - Checks current section for treasure
	SCENARIO=$(NewSector_GetScenario "$CHAR_GPS") # Get scenario char at current GPS
	GX_Place "$SCENARIO"	
	if [[ "$NODICE" ]] ; then # Do not attack player at the first turn of after finding item
	    unset NODICE 
	else
	    CheckForFight "$SCENARIO" # Defined in FightMode.sh
	    GX_Place "$SCENARIO"
	fi

	CheckForStarvation         # Food check
	CheckForWorldChangeEconomy # Change economy if success

	while (true); do # GAME ACTIONS MENU BAR
	    GX_Place "$SCENARIO"
	    case "$SCENARIO" in # Determine promt
		T | C ) echo -n "     (C)haracter    (R)est    (G)o into Town    (M)ap and Travel    (Q)uit" ;;
		H )     echo -n "     (C)haracter     (B)ulletin     (R)est     (M)ap and Travel     (Q)uit" ;;
		* )     echo -n "        (C)haracter        (R)est        (M)ap and Travel        (Q)uit"    ;;
	    esac
	    local ACTION=$(Read)	# Read only one symbol
	    case "$ACTION" in
		c | C ) DisplayCharsheet ;;
		r | R ) Rest "$SCENARIO";;      # Player may be attacked during the rest :)
		q | Q ) CleanUp ;;              # Leaving the realm of magic behind ....
		b | B ) [[ "$SCENARIO" -eq "H" ]] && GX_Bulletin "$BBSMSG" ;;
		g | G ) [[ "$SCENARIO" -eq "T" || "$SCENARIO" -eq "C" ]] && GoIntoTown ;;
		* ) MapNav "$ACTION"; break ;;	# Go to Map then move or move directly (if not WASD, then loitering :)
	    esac
	done
    done
}

#                                                                      #
#                                                                      #
########################################################################

########################################################################
#                                                                      #
#                          1. FUNCTIONS                                #
#                    All program functions go here!                    #

Die() { echo -e "$1" && exit 1 ;}

Capitalize() { awk '{ print substr(toupper($0), 1,1) substr($0, 2); }' <<< "$*" ;} # Capitalize $1

Toupper() { awk '{ print toupper($0); }' <<< "$*" ;} # Convert $* to uppercase

Strlen() { awk '{print length($0);}' <<< "$*" ;} # Return lenght of string $*. "Strlen" is traditional name :)

MvAddStr() { tput cup "$1" "$2"; printf "%s" "$3"; } # move cursor to $1 $2 and print $3. "mvaddstr" is name similar function from ncurses.h

#-----------------------------------------------------------------------
# Ordial()
# Add postfix to $1 (NUMBER)
# Arguments: $1(int)
#-----------------------------------------------------------------------
Ordial() { 
    grep -Eq '[^1]?1$'  <<< "$1" && echo "${1}st" && return 0
    grep -Eq '[^1]?2$'  <<< "$1" && echo "${1}nd" && return 0
    grep -Eq '[^1]?3$'  <<< "$1" && echo "${1}rd" && return 0
    grep -Eq '^[0-9]+$' <<< "$1" && echo "${1}th" && return 0
    Die "Bug in Ordial with ARG $1"
}

#-----------------------------------------------------------------------
# MakePrompt()
# Make centered to 79px promt from $@. Arguments should be separated by ';'
# Arguments: $PROMPT(string)
#-----------------------------------------------------------------------
MakePrompt() { 
    awk '   BEGIN { FS =";" }
        {
            MAXLEN = 79;
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
            STR = STR SEPARATOR INTRO
        }
        END { printf STR; }' <<< "$@" || Die "Too long promt >>>$*<<<"
    #BACKUP END { print STR; }' <<< "$@" || Die "Too long promt >>>$*<<<"
}

# PRE-CLEANUP tidying function for buggy custom maps
# Used in MapCreate(), GX_Place(), NewSector()
CustomMapError() { 
    local ERROR_MAP=$1
    clear
    echo "Whoops! There is an error with your map file!
Either it contains unknown characters or it uses incorrect whitespace.
Recognized characters are: x . T @ H C
Please run game with --map argument to create a new template as a guide.

What to do?
1) rename $ERROR_MAP to ${ERROR_MAP}.error or
2) delete template file CUSTOM.map (deletion is irrevocable)."
    read -n 1 -p "Please select 1 or 2: " MAP_CLEAN_OPTS 2>&1
    case "$MAP_CLEAN_OPTS" in
	1 ) mv "${ERROR_MAP}" "${ERROR_MAP}.error" ;
	    echo -e "\nCustom map file moved to ${ERROR_MAP}.error" ;;
	2 ) rm -f "${ERROR_MAP}" ;
	    echo -e "\nCustom map deleted!" ;;
	* ) Die "\nBad option! Quitting.." ;;
    esac
    sleep 4
}


#-----------------------------------------------------------------------
# SaveCurrentSheet()
# Saves current game values to CHARSHEET file (overwriting)
#-----------------------------------------------------------------------
SaveCurrentSheet() { 
    echo "CHARACTER: $CHAR
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
    SHORTNAME=$(Capitalize "$CHAR")  # Create capitalized FIGHT CHAR name

# TEST - should not needed now    
#    (( TURN == 0 )) && TodaysDate    # Fetch today's date in Warhammer calendar (Used in DisplayCharsheet() and FightMode() )

    MapCreate                        # Create session map in $MAP  
    HotzonesDistribute "$CHAR_ITEMS" # Place items randomly in map
    WORLDCHANGE_COUNTDOWN=0          # WorldChange Counter (0 or negative value allow changes)    
    WorldPriceFixing                 # Set all prices
    GX_Intro 60                      # With countdown 60 seconds
    NODICE=1                         # Do not roll on first section after loading/starting a game in NewSector()
}

################### GAME SYSTEM #################

#-----------------------------------------------------------------------
# Reseed RANDOM. Needed only once at start, so moved to separate section
case "$OSTYPE" in
    openbsd* ) RANDOM=$(date '+%S') ;;
    *)         RANDOM=$(date '+%N') ;;
esac

# TODO:
#  ? Move it to runtime section
#  ? Make separate file with system-depended things
#  ? Use /dev/random or /dev/urandom
#-----------------------------------------------------------------------
# SEED=$(head -1 /dev/urandom | od -N 1 | awk '{ print $2 }'| sed s/^0*//)
# RANDOM=$SEED
# Suggestion from: http://tldp.org/LDP/abs/html/randomvar.html
#-----------------------------------------------------------------------

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

    case "$INV_ALMANAC" in		# Define prompt
	1) MakePrompt '(D)isplay Race Info;(A)lmanac;(C)ontinue;(Q)uit'  ;; # Player has    Almanac
	*) MakePrompt '(D)isplay Race Info;(A)ny key to continue;(Q)uit' ;; # Player hasn't Almanac
    esac
    case $(Read) in
	d | D ) GX_Races && PressAnyKey ;;
	a | A ) ((INV_ALMANAC)) && Almanac ;;
	q | Q ) CleanUp ;;
    esac
}

#-----------------------------------------------------------------------
# Death()
# Used: FightMode()
# TODO: also should be used in check-for-starvation
#-----------------------------------------------------------------------
Death() { 
    GX_Death
    echo " The $BIAMIN_DATE_STR:"
    echo " In such a short life, this sorry $CHAR_RACE_STR gained $CHAR_EXP Experience Points."
    local COUNTDOWN=20
    while (( COUNTDOWN > 0 )); do
	echo -en "${CLEAR_LINE} We honor $CHAR with $COUNTDOWN secs silence." 
    	read -sn 1 -t 1 && break || ((COUNTDOWN--))
    done
    unset COUNTDOWN 
    #echo "$CHAR_EXP;$CHAR;$CHAR_RACE;$CHAR_BATTLES;$CHAR_KILLS;$CHAR_ITEMS;$TODAYS_DATE;$TODAYS_MONTH;$TODAYS_YEAR" >> "$HIGHSCORE"
    echo "$CHAR_EXP;$CHAR;$CHAR_RACE;$CHAR_BATTLES;$CHAR_KILLS;$CHAR_ITEMS;$DAY;$MONTH;$(Ordial $YEAR)" >> "$HIGHSCORE"
    rm -f "$CHARSHEET" # A sense of loss is important for gameplay:)
    unset CHARSHEET CHAR CHAR_RACE CHAR_HEALTH CHAR_EXP CHAR_GPS SCENARIO CHAR_BATTLES CHAR_KILLS CHAR_ITEMS # Zombie fix     # Do we need it ????
    # TODO: add showing Highscore list here
    CleanUp
}

# GAME ACTION: REST
RollForHealing() { # Used in Rest()
    RollDice 6
    echo -e "Rolling for healing: D6 <= $HEALING\nROLL D6: $DICE"
    # TODO!!! Check it - ( (( CHAR_HEALTH += $1 )) && echo "You slept well and gained $1 Health." ) - shouldn't that be not () but {} ??? #kstn
    ((DICE > HEALING)) && echo "$2" || ( (( CHAR_HEALTH += $1 )) && echo "You slept well and gained $1 Health." )
    ((TURN++))
    sleep 2
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
    case "$1" in
	H ) if (( CHAR_HEALTH < 100 )); then
		CHAR_HEALTH=100
		echo "You slept well in your own bed. Health restored to 100."
	    else
		echo "You slept well in your own bed, and woke up to a beautiful day."
	    fi
	    ((TURN++))
	    ;;
	x ) RollForEvent 60 "fight" && FightMode || [ -n $DICE ] && [[ $DICE != 111 ]] && RollForHealing 5  "The terrors of the mountains kept you awake all night.." ;; # TODO I need to clean this up..
	. ) RollForEvent 30 "fight" && FightMode || [ -n $DICE ] && [[ $DICE != 111 ]] && RollForHealing 10 "The dangers of the roads gave you little sleep if any.." ;;
	T ) RollForEvent 15 "fight" && FightMode || [ -n $DICE ] && [[ $DICE != 111 ]] && RollForHealing 15 "The vices of town life kept you up all night.." ;;
	@ ) RollForEvent 35 "fight" && FightMode || [ -n $DICE ] && [[ $DICE != 111 ]] && RollForHealing 5  "Possibly dangerous wood owls kept you awake all night.." ;;
	C ) RollForEvent 5  "fight" && FightMode || [ -n $DICE ] && [[ $DICE != 111 ]] && RollForHealing 35 "Rowdy castle soldiers on a drinking binge kept you awake.." ;;
    esac
    unset PLAYER_RESTING # Reset flag
    sleep 2
}   # Return to NewSector()

# THE GAME LOOP


#-----------------------------------------------------------------------
# RollForEvent()
# Arguments: $DICE_SIZE(int), $EVENT(string)
# Used: Rest(), CheckForFight()
#-----------------------------------------------------------------------
RollForEvent() {     
    echo -e "Rolling for $2: D${DICE_SIZE} <= $1\nD${DICE_SIZE}: $DICE" 
    sleep 1.5
    (( DICE <= $1 )) && return 0 || return 1
}   # Return to NewSector() or Rest()

#-----------------------------------------------------------------------
# CheckForStarvation()
# Food check 
# Used: NewSector() and should be used also in Rest()
# TODO: may be it shold be renamed to smth more understandable? #kstn
# TODO: add it to Rest() after finishing
# TODO: not check for food at the 1st turn ???
# TODO: Tavern also should reset STARVATION and restore starvation penalties if any
#-----------------------------------------------------------------------
CheckForStarvation(){ 
    if (( $(bc <<< "${CHAR_FOOD} > 0") )) ; then
	CHAR_FOOD=$( bc <<< "${CHAR_FOOD} - 0.25" )
	echo "You eat .25 food from your stock: $CHAR_FOOD remaining .." 
	if (( STARVATION > 0 )) ; then
	    if (( STARVATION >= 8 )) ; then # Restore lost ability after overcoming starvation
		case "$CHAR_RACE" in
		    1 | 3 ) (( STRENGTH++ )) && echo "+1 STRENGTH: You restore your body to healthy condition (Strength: $STRENGTH)" ;; 
		    2 | 4 ) (( ACCURACY++ )) && echo "+1 ACCURACY: You restore your body to healthy condition (Accuracy: $ACCURACY)" ;; 
		esac		    
	    fi
	    STARVATION=0
	fi
    else
	case $(( ++STARVATION )) in # ++STARVATION THEN check
	    1 ) echo "You're starving on the ${STARVATION}st day and feeling hungry .." ;;
	    2 ) echo "You're starving on the ${STARVATION}nd day and feeling famished .." ;;
	    3 ) echo "You're starving on the ${STARVATION}rd day and feeling weak .." ;;
	    * ) echo "You're starving on the ${STARVATION}th day, feeling weaker and weaker .." ;;
	esac

	(( CHAR_HEALTH -= 5 ))
	echo "-5 HEALTH: Your body is suffering from starvation .. (Health: $HEALTH)" # Light Starvation penalty - decrease 5HP/turn	    
	
	if (( STARVATION == 8 )); then # Extreme Starvation penalty
	    case "$CHAR_RACE" in
		1 | 3 ) (( STRENGTH-- )) && echo "-1 STRENGTH: You're slowly starving to death .. (Strength: $STRENGTH)" ;; 
		2 | 4 ) (( ACCURACY-- )) && echo "-1 ACCURACY: You're slowly starving to death .. (Accuracy: $ACCURACY)" ;;
	    esac
	fi
	((HEALTH <= 0)) && echo "You have starved to death" && sleep 2 && Death
    fi
    sleep 1.5 ### DEBUG
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
	    sleep 2;;
    esac
    if ((COLOR == 1)) ; then
	YELLOW='\033[1;33m' # Used in MapNav() and GX_Map()
	RESET='\033[0m'
    fi
    # Define escape sequences
    # TODO replace to tput or similar
    CLEAR_LINE="\e[1K\e[80D" # \e[1K - erase to the start of line \e[80D - move cursor 80 columns backward
}
#                           END FUNCTIONS                              #
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

# Declare global calendar variables (used in DateFromTurn() and Almanac())
YEAR_LENGHT=360     # How many days are in year?
YEAR_MONTHES=12     # How many monthes are in year?
MONTH_LENGTH=30     # How many days are in month?
MOON_PHASE_LENGTH=4                   # How many days one Moon Phase lenghts
MOON_CYCLE=$((MOON_PHASE_LENGTH * 8)) # How many days are in moon month? (8 phases * $MOON_PHASE_LENGTH) ATM == 32.

# Moon Phases names
MOON_STR=("New Moon" "Growing Crescent" "First Quarter" "Growing Gibbous" "Full Moon" "Waning Gibbous" "Third Quarter" "Waning Crescent")

MONTH_STR=(
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
#-----------------------------------------------------------------------
MonthString()      { echo ${MONTH_STR[((  $1 * 2      ))]} ;} # Return month $1 name
MonthTrivia()      { echo ${MONTH_STR[(( ($1 * 2) + 1 ))]} ;} # Return month $1 trivia

WEEK_LENGTH=7 # How many days are in week?
WEEKDAY_STR=(
    # Weekday    # Short trivia                       # Long trivia
    "Ringday (Holiday)" "Day of Festivities and Rest" "Men and Halflings celebrate Ringday as the end and beginning of the week."   
    "Moonday"   "Mor's Day (Day of the Moon)"         "Elves and Dwarves once celebrated Moon Day as the holiest. Some still do."   
    "Brenday"   "Brenia's Day (God of Courage)"       "Visit the Temple on Brenia's Day to honor those who perished in warfare."    
    "Midweek"   "Middle of the Week (Day of Balance)" "In some places, Midweek Eve is celebrated with village dances and ale."      
    "Braigday"  "Braig's Day (God of Wilderness)"     "Historically, a day of hunting. Nobility still hunt every Braig's Day."      
    "Melethday" "Melethril's Day (God of Love)"       "Commonly considered Lovers' Day, it is also a day of mischief and trickery." 
    "Washday"   "Final Workday of the Week"           "Folk name for Lanthir's Day, the God of Water, Springs and Waterfalls."      
)

#-----------------------------------------------------------------------
# Weekday*()
# Returns $WEEKDAY name, short and long trivia. 
# Arguments: $WEEKDAY(int [0-6])
# TODO: add check for $1 size
#-----------------------------------------------------------------------
WeekdayString()      { echo ${WEEKDAY_STR[((  $1 * 3      ))]} ;} # Return weekday $1 name 
WeekdayTriviaShort() { echo ${WEEKDAY_STR[(( ($1 * 3) + 1 ))]} ;} # Return weekday $1 short trivia
WeekdayTriviaLong()  { echo ${WEEKDAY_STR[(( ($1 * 3) + 2 ))]} ;} # Return weekday $1 long trivia

#-----------------------------------------------------------------------
# TurnFromDate()
# Get $TURN from current (real) date
# IDEA: rename to Creation() ?
#-----------------------------------------------------------------------
TurnFromDate() { 
    local YEAR MONTH DAY
    read -r "YEAR" "MONTH" "DAY" <<< "$(date '+%-y %-m %-d')"
    bc <<< "($YEAR * $YEAR_LENGHT) + ($MONTH_LENGTH * $MONTH) + $DAY"
}

#-----------------------------------------------------------------------
# DateFromTurn()
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
    	read -sn 1 -p " Press any key to return to (M)ain menu and try (P)lay" 2>&1 # St. Anykey - patron of cyberneticists :)
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

HighscoreRead() { # Used in Announce() and HighScore()
    sort -g -r "$HIGHSCORE" -o "$HIGHSCORE"
    local HIGHSCORE_TMP=" #;Hero;EXP;Wins;Items;Entered History\n;"
    local i=1
    # Read values from highscore file (BashFAQ/001)
    while IFS=";" read -r highEXP highCHAR highRACE highBATTLES highKILLS highITEMS highDATE highMONTH highYEAR; do
	(( i > 10 )) && break	
	case "$highRACE" in
	    1 ) highRACE="Human" ;;
	    2 ) highRACE="Elf" ;;
	    3 ) highRACE="Dwarf" ;;
	    4 ) highRACE="Hobbit" ;;
	esac
	if [[ "$highMONTH" ]] ; then # fix for "Witching Day", etc
	    HIGHSCORE_TMP+=" $i.;$highCHAR the $highRACE;$highEXP;$highKILLS/$highBATTLES;$highITEMS/8;$highMONTH $highDATE ($highYEAR)\n"
	else
	    HIGHSCORE_TMP+=" $i.;$highCHAR the $highRACE;$highEXP;$highKILLS/$highBATTLES;$highITEMS/8;the $highDATE ($highYEAR)\n"
	fi
	((i++))
    done < "$HIGHSCORE"
    echo -e "$HIGHSCORE_TMP" | column -t -s ";" # Nice tabbed output!
    unset HIGHSCORE_TMP
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
    GPL=$(curl -s "http://www.gnu.org/licenses/gpl-3.0.txt" || "") # I did not know we could do that :)
    echo " Download CC BY-NC-SA 4.0 ..."
    CC=$(curl -s "http://creativecommons.org/licenses/by-nc-sa/4.0/legalcode.txt" || "")
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
	echo -e "\n License file currently missing in $GAMEDIR/ !"
	read -p " To DL licenses, about 60kB, type YES (requires internet access): " "DL_LICENSE_OPT" 2>&1
	case "$DL_LICENSE_OPT" in
	    YES ) PrepareLicense ;;
	    * )   echo -e "
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


CleanUp() { # Used in MainMenu(), NewSector(),
    GX_BiaminTitle
    echo -e "\n$HR"
    if [ -n "$FIGHTMODE" ] && (( FIGHTMODE == 1 )); then #  -20 HP -20 EXP Penalty for exiting CTRL+C during battle!
		((CHAR_HEALTH -= 20))
    	((CHAR_EXP -=20))
    	echo -e "PENALTY for CTRL+Chickening out during battle: -20 HP -20 EXP\nHEALTH: $CHAR_HEALTH\tEXPERIENCE: $CHAR_EXP"
    fi
    [[ "$CHAR" ]] && SaveCurrentSheet # Don't try to save if we've nobody to save :)
    echo -e "\nLeaving the realm of magic behind ....\nPlease submit bugs and feedback at <$WEBURL>"
    exit 0
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
	    p | P ) echo -en "${CLEAR_LINE} Enter character name (case sensitive): ";
 		    read CHAR 2>&1 ;;
	    l | L ) LoadGame ;;
	    h | H ) GX_HighScore ; # HighScore
		    echo "";
		    # Show 10 highscore entries or die if Highscore list is empty
		    [[ -s "$HIGHSCORE" ]] && HighscoreRead || echo -e " The highscore list is unfortunately empty right now.\n You have to play some to get some!";
		    echo "" ; # empty line TODO fix it
		    PressAnyKey 'Press the any key to go to (M)ain menu';;
	    c | C ) GX_Credits ; # Credits
		    MakePrompt '(H)owTo;(L)icense;(M)ain menu'; 
		    case $(Read) in
			L | l ) License ;;
			H | h ) GX_HowTo ;;
		    esac ;;
	    q | Q ) CleanUp ;;
	esac
done
}

#                                                                      #
#                                                                      #
########################################################################

########################################################################
#                            Parse Console Args                        #
#                                                                      #

#-----------------------------------------------------------------------
# MapCreateCustom()
# Map template generator (CLI arg function)
#-----------------------------------------------------------------------
MapCreateCustom() { 
    echo -n "Create custom map template? [Y/N]: "
    case $(Read) in
	y | Y) echo -e "\nCreating custom map template.." ;;
	*)     echo -e "\nNot doing anything! Quitting.." ; exit 0 ;;
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
    exit 0
}

#-----------------------------------------------------------------------
# Announce()
# Simply outputs a 160 char text you can cut & paste to social media.
# TODO: Once date is decoupled from system date (with CREATION and
# DATE), create new message. E.g.  $CHAR died $DATE having fought
# $BATTLES ($KILLS victoriously) etc...
#-----------------------------------------------------------------------
Announce() {
    # Die if $HIGHSCORE is empty
    [[ ! -s "$HIGHSCORE" ]] && Die "Sorry, can't do that just yet!\nThe highscore list is unfortunately empty right now."

    echo "TOP 10 BACK IN A MINUTE HIGHSCORES"
    HighscoreRead
    echo -en "\nSelect the highscore (1-10) you'd like to display or CTRL+C to cancel: "
    read SCORE_TO_PRINT

    ((SCORE_TO_PRINT < 1)) && ((SCORE_TO_PRINT > 10 )) && Die "\nOut of range. Please select an entry between 1-10. Quitting.."

    ANNOUNCE_ADJECTIVES=("honorable" "fearless" "courageos" "brave" "legendary" "heroic")
    ADJECTIVE=${ANNOUNCE_ADJECTIVES[RANDOM%6]}

    ANNOUNCEMENT_TMP=$(sed -n "${SCORE_TO_PRINT}"p "$HIGHSCORE")
    IFS=";" read -r highEXP highCHAR highRACE highBATTLES highKILLS highITEMS highDATE highMONTH highYEAR <<< "$ANNOUNCEMENT_TMP"

    HIGH_RACES=("Human" "Elf" "Dwarf" "Hobbit")
    highRACE=${HIGH_RACES["$highRACE"]}
    
    (( highBATTLES == 1 )) && highBATTLES+=" battle" || highBATTLES+=" battles"
    (( highITEMS == 1 ))   && highITEMS+=" item"     || highITEMS+=" items"

    highCHAR=$(Capitalize "$highCHAR") # Capitalize
    
    if [[ "$highMONTH" ]] ; then # fix for "Witching Day", etc
	ANNOUNCEMENT="$highCHAR fought $highBATTLES, $highKILLS victoriously, won $highEXP EXP and $highITEMS. This $ADJECTIVE $highRACE was finally slain the $highDATE of $highMONTH in the $highYEAR Cycle."
    else
	ANNOUNCEMENT="$highCHAR fought $highBATTLES, $highKILLS victoriously, won $highEXP EXP and $highITEMS. This $ADJECTIVE $highRACE was finally slain at the $highDATE in the $highYEAR Cycle."
    fi
    ANNOUNCEMENT_LENGHT=$(Strlen "$ANNOUNCEMENT" ) 
    GX_HighScore

    echo "ADVENTURE SUMMARY to copy and paste to your social media of choice:"
    echo -e "\n$ANNOUNCEMENT\n" | fmt
    echo "$HR"

    ((ANNOUNCEMENT_LENGHT > 160)) && echo "Warning! String longer than 160 chars ($ANNOUNCEMENT_LENGHT)!"
    exit 0
}

#-----------------------------------------------------------------------
# CLIarguments_CheckUpdate()
# Update function
#-----------------------------------------------------------------------
CLIarguments_CheckUpdate() {
    # Removes stranded repo files before proceeding..
    STRANDED_REPO_FILES=$(find "$GAMEDIR"/repo.* | wc -l)
    (( STRANDED_REPO_FILES > 0 )) && rm -f "$GAMEDIR/repo.*"
    REPO_SRC="https://gitorious.org/back-in-a-minute/code/raw/biamin.sh"
    GX_BiaminTitle
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

    # Compare versions $1 and $2. Versions should be [0-9]+.[0-9]+.[0-9]+. ...
    # Return 0 if $1 == $2, 1 if $1 > than $2, 2 if $2 < than $1
    if [[ "$VERSION" == "$REPOVERSION" ]] ; then
	RETVAL=0  
    else
	IFS="\." read -a VER1 <<< "$VERSION"
	IFS="\." read -a VER2 <<< "$REPOVERSION"
	for ((i=0; ; i++)); do # until break
	    [[ ! "${VER1[$i]}" ]] && { RETVAL=2; break; }
	    [[ ! "${VER2[$i]}" ]] && { RETVAL=1; break; }
	    (( ${VER1[$i]} > ${VER2[$i]} )) && { RETVAL=1; break; }
	    (( ${VER1[$i]} < ${VER2[$i]} )) && { RETVAL=2; break; }
	done
	unset VER1 VER2
    fi
    case "$RETVAL" in
	0)  echo "This is the latest version ($VERSION) of Back in a Minute!" ; rm -f "$REPO";;
	1)  echo "Your version ($VERSION) is newer than $REPOVERSION" ; rm -f "$REPO";;
	2)  echo "Newer version $REPOVERSION is available!"
	    echo "Updating will NOT destroy character sheets, highscore or current config."
 	    echo "Update to Biamin version $REPOVERSION? [Y/N] "
	    case $(Read) in
		y | Y ) echo -e "\nUpdating Back in a Minute from $VERSION to $REPOVERSION .."
			# TODO make it less ugly
			BIAMIN_RUNTIME=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ) # TODO $0 is a powerful beast, but will sometimes fail.
			BIAMIN_RUNTIME+="/"
			BIAMIN_RUNTIME+=$( basename "${BASH_SOURCE[0]}")
			mv "$BIAMIN_RUNTIME" "${BIAMIN_RUNTIME}.bak" # backup current file
			mv "$REPO" "$BIAMIN_RUNTIME"
			chmod +x "$BIAMIN_RUNTIME" || Die "PERMISSION ERROR! Couldnt make biamin executable"
			echo "Run 'sh $BIAMIN_RUNTIME --install' to add launcher!" 
			echo "Current file moved to ${BIAMIN_RUNTIME}.bak"
			;;
		* ) echo -e "\nNot updating! Removing temporary file ..";
		    rm -f "$REPO" ;;
	    esac
	    ;;
    esac
    echo "Done. Thanks for playing :)"
    exit 0
}

#-----------------------------------------------------------------------
# CreateBiaminLauncher()
# Add alias for biamin in $HOME/.bashrc
#-----------------------------------------------------------------------
CreateBiaminLauncher() {
    grep -q 'biamin' "$HOME/.bashrc" && Die "Found existing launcher in $HOME/.bashrc.. skipping!" 
    BIAMIN_RUNTIME=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ) # TODO $0 is a powerful beast, but will sometimes fail..
    echo "This will add $BIAMIN_RUNTIME/biamin to your .bashrc"
    read -n 1 -p "Install Biamin Launcher? [Y/N]: " LAUNCHER 2>&1
    case "$LAUNCHER" in
	y | Y ) echo -e "\n# Back in a Minute Game Launcher (just run 'biamin')\nalias biamin='$BIAMIN_RUNTIME/biamin.sh'" >> "$HOME/.bashrc";
	        echo -e "\nDone. Run 'source \$HOME/.bashrc' to test 'biamin' command." ;;
	* ) echo -e "\nDon't worry, not changing anything!";;
    esac
    exit 0
}

#-----------------------------------------------------------------------
# ParseCLIarguments()
# Parse CLI arguments if any
#-----------------------------------------------------------------------
ParseCLIarguments() {    
    case "$1" in
	-a | --announce ) Announce ;;
	-i | --install )  CreateBiaminLauncher ;;
	--map )           MapCreateCustom ;;
	-h | --help )
	    echo "Run BACK IN A MINUTE with '-p', '--play' or 'p' argument to play!"
	    echo "For usage: run biamin --usage"
	    echo "Current dir for game files: $GAMEDIR/"
	    echo "Change at runtime or on line 10 in the CONFIGURATION of the script."
	    exit 0;;
	-p | --play | p )
	    shift ; 		     # remove $1 from $*
	    [[ "$*" ]] && CHAR="$*"; # for long names as "Corum Jhaelen Irsei" for instance
	    echo "Launching Back in a Minute.." ;;
	-v | --version )
	    echo "BACK IN A MINUTE VERSION $VERSION Copyright (C) 2014 Sigg3.net"
	    echo "Game SHELL CODE released under GNU GPL version 3 (GPLv3)."
	    echo "This is free software: you are free to change and redistribute it."
	    echo "There is NO WARRANTY, to the extent permitted by law."
	    echo "For details see: <http://www.gnu.org/licenses/gpl-3.0>"
	    echo "Game ARTWORK released under Creative Commons CC BY-NC-SA 4.0."
	    echo "You are free to copy, distribute, transmit and adapt the work."
	    echo "For details see: <http://creativecommons.org/licenses/by-nc-sa/4.0/>"
	    echo "Game created by Sigg3. Submit bugs & feedback at <$WEBURL>"
	    exit 0 ;;
	--update ) CLIarguments_CheckUpdate ;;
	--usage | * )
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
	    exit 0;;
    esac
}

#                                                                      #
#                                                                      #
########################################################################

########################################################################
#                                                                      #
#                        2. RUNTIME BLOCK                              #
#                   All running code goes here!                        #

# Make place for game (BEFORE CLI opts! Mostly because of Higscore and MapCreateCustom())
if [[ ! -d "$GAMEDIR" ]] ; then # Check whether gamedir exists...
    echo -e "Game directory default is $GAMEDIR/\nYou can change this in $CONFIG. Creating directory ..."
    mkdir -p "$GAMEDIR/" || Die "ERROR! You do not have write permissions for $GAMEDIR ..."
fi

if [[ ! -f "$CONFIG" ]] ; then # Check whether $CONFIG exists...
    echo "Creating ${CONFIG} ..."
    echo -e "GAMEDIR: ${GAMEDIR}\nCOLOR: NA" > "$CONFIG"
fi

[[ -f "$HIGHSCORE" ]] || touch "$HIGHSCORE"; # Check whether $HIGHSCORE exists...
grep -q 'd41d8cd98f00b204e9800998ecf8427e' "$HIGHSCORE" && > "$HIGHSCORE" # Backwards compatibility: replaces old-style empty HS...

if [[ ! "$PAGER" ]] ; then # Define PAGER (for ShowLicense() )
    for PAGER in less more ; do PAGER=$(which "$PAGER" 2>/dev/null); [[ "$PAGER" ]] && break; done
fi

ParseCLIarguments "$@"			  # Parse CLI args if any
echo "Putting on the traveller's boots.." # OK lets play!

# Load variables from $GAMEDIR/config. Need if player wants to keep his saves not in ~/.biamin . NB variables should not be empty !
read -r GAMEDIR COLOR <<< $(awk '{ if (/^GAMEDIR:/)  { GAMEDIR= $2 }
                                   if (/^COLOR:/)    { COLOR = $2  } }
                            END { print GAMEDIR, COLOR ;}' "$CONFIG" )

ColorConfig "$COLOR"               # Color configuration
trap CleanUp SIGHUP SIGINT SIGTERM # Direct termination signals to CleanUp
################################# Main game part ###############################
[[ "$CHAR" ]] || MainMenu  # Run main menu (Define $CHAR) if game wasn't run as biamin -p <charname>
BiaminSetup                # Load or make new char
Intro	                   # Set world
NewSector                  # And run main game loop
############################## Main game part ends #############################
exit 0                     # This should never happen:
                           # .. but why be 'tardy when you can be tidy?
