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
	if (( FIGHTMODE == 1 )) ; then
	MvAddStr 3 9 "YOU WERE DEFEATED"
	MvAddStr 5 9 "The smell of dirt and"
	MvAddStr 6 9 "blood will be the last"
	MvAddStr 7 9 "thing you know."	
	else
    MvAddStr 3 9 "YOU STARVED TO DEATH"
	MvAddStr 5 9 "Only death triumphs"
	MvAddStr 6 9 "over hunger."
	fi
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

#GX_Starvation() {
#    clear
#    cat <<"EOT"
#
#
#                                        ///`~ ,~---..._            
#         YOU STARVED TO DEATH    ~~--- \\\\ ',l        `~,.   ~ ~ --  ---  -- --
#                                        _`~--;~,)_     ,',~`.      ,          
#         Only death triumphs     ,-    ;_`-,'_/  ;`~~-;,'    \              o 
#         over hunger.            `.`.    `~.'  _; ;    7 \   /                 
#                               -   `.`.       `-~'    /  <\  \____ _          `
#                                     `.`._,           `----\______\_`--        
#                                  ,   ;,~('         -         .     `--`    . 
#                                          `c              
#EOT
#    echo "$HR"
#}

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
                                                    / ,                | \ |
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

