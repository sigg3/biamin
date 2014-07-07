#!/bin/bash
# Back In A Minute created by Sigg3.net (C) 2014
# Code is GNU GPLv3 & ASCII art is CC BY-NC-SA 4.0
VERSION="1.8" # 12 items on TODO. Change to 2.0 when list is x'd out
WEBURL="http://sigg3.net/biamin/"

########################################################################
# BEGIN CONFIGURATION                                                  #
# Default dir for config, change at runtime (no trailing slash!)       #
GAMEDIR="$HOME/.biamin"                                                #
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

# Centered "Press Any Key to continue" string
PressAnyKey() {
	read -sn 1 -p "                        Press (A)ny key to continue.."
}

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
EOF
    read -sn 1 -p "                    Press any key to return to (M)ain Menu"
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

GX_CharSheet() {
    clear
    cat <<"EOT"
 
                               /T\                           /""""""""\ 
      o-+----------------------------------------------+-o  /  _ ++ _  \
        |/                                            \|   |  / \  / \  \
        |  C  H  A  R  A  C  T  E  R     S  H E  E  T  |   | | , | |, | |
        |                                              |   | |   |_|  | |
        |\             s t a t i s t i c s            /|    \|   ...; |; 
      o-+----------------------------------------------+-o    \______/

EOT
    echo "$HR"
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
    echo "$HR" && PressAnyKey
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

GX_Castle() {
    clear
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
    echo "$HR"
}

GX_Town() {
    clear
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
    echo "$HR"
}

GX_Forest() {
    clear
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
    echo "$HR"
}

GX_Mountains() {
    clear
    cat <<"EOT"


                                           ^^      /\  /\_/\/\
         YOU'RE TRAVELLING IN           ^^     _  /~~\/~~\~~~~\   
         THE MOUNTAINS                        / \/    \/\      \
                                             /  /    ./  \ /\   \/\ 
         The calls of the wilderness  ............:;'/    \     /  
         turn your blood to ice        '::::::::::; /     




EOT
    echo "$HR"
}

GX_Home() {
    clear
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
    echo "$HR"
}

GX_Road() {
    clear
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
    echo "$HR"
}

GX_Rest() {
    clear
    cat <<"EOT"


                                                          _.._    
                               *         Z Z Z   *       -'-. '.             *
                                                             \  \          
         YOU TRY TO GET                                .      | |
         SOME MUCH NEEDED REST    *                    ;.___.'  /     *    
                                    Z Z    *            '.__ _.'          * 
                            *                                               



EOT
    echo "$HR"
}

GX_Monster_chthulu() {
    clear
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
    echo "$HR"
}

GX_Monster_orc() {
    clear
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
    echo "$HR"
}

GX_Monster_varg() {
    clear
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
    echo "$HR"
}

GX_Monster_mage() {
    clear
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
    echo "$HR"
}

GX_Monster_goblin() {
    clear
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
    echo "$HR"
}

GX_Monster_bandit() {
    clear
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
    echo "$HR"
}

GX_Monster_boar() {
    clear
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
    echo "$HR"
}

GX_Monster_dragon() {
    clear
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
    echo "$HR"
}

GX_Item0() {
    clear
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
    echo "$HR"
}

GX_Item1() {
    clear
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
    echo "$HR"
}

GX_Item2() {
    clear
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
    echo "$HR"
}

GX_Item3() {
    clear
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
    echo "$HR"
}

GX_Item4() {
    clear
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
    echo "$HR"
}

GX_Item5() {
    clear
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
    echo "$HR"
}
GX_Item6() {
    clear
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
    echo "$HR"
}

GX_Item7() {
    clear
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
    echo "$HR"
}

GX_Bulletin() { # Requires $BBSMSG as arg, default val=0
# Bulletin Header
clear
cat <<"EOT"
                 ___                                     ____  
                (___) _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ (____)  
                 | T-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-T ||     
EOT

# Display custom message (BBSMSG)
case $1 in
 1 ) # Wild Fire Threatens Tobacco (serious)
	cat <<"EOT"
 ^^              | | WILD FIRE THREATENS TOBACCO SUPPLY! | || 
    ^^           | |                                     | ||   ____________
        ___      | | Many Travellers have told of Wild   | ||  /           /\
     _ (   )_    | | Forest Fires that may threaten the  | || /           /||\
   (  )      )   | | steady Supply of Tobacco to the     | ||/___________/ ||_\
 (__   ) (  ) )  | | Markets of the Realm. Rumours say   | ||  ||          || 
(     __)  ___)  | | Harvest in Jeopardy & prices soar!  | || _||__________|| 
EOT
 ;;
 2 ) # Hobbits on Strike
	cat <<"EOT"
 ^^              | |        TOBACCO TOO CHEAP!           | ||
    ^^           | |                                     | ||   ____________
        ___      | | Traders Beware! Since last Harvest  | ||  /           /\
     _ (   )_    | | many Halflings of great Repute have | || /           /||\
   (  )      )   | | returned to Other Produce than Leaf | ||/___________/ ||_\
 (__   ) (  ) )  | | Villages report malcontent of low   | ||  ||          || 
(     __)  ___)  | | Tobacco Prices, refusing to sell.   | || _||__________|| 
EOT
 ;;
 3 ) # Tobacco Overproduction (serious)
	cat <<"EOT"
 ^^              | |  GREATEST TOBACCO HARVEST IN AGES!  | ||   
    ^^           | |                                     | ||   ____________
        ___      | | Our Harvest may well prove to be ye | ||  /           /\
     _ (   )_    | | Most Abundant in many Cycles, and   | || /           /||\
   (  )      )   | | Hobbit Masters of Several Good Towns| ||/___________/ ||_\
 (__   ) (  ) )  | | report with Joye an Increase in     | ||  ||          || 
(     __)  ___)  | | Produce.           - The Hobbits    | || _||__________|| 
EOT
 ;;
 4 ) # Tobacco Import Increases
	cat <<"EOT"
 ^^              | |      ROYALE IMPORT OF TOBACCOS      | || 
    ^^           | |                                     | ||   ____________
        ___      | | Facing a National Tobacco Famine ye | ||  /           /\
     _ (   )_    | | King orders large-scale Leaf Import | || /           /||\
   (  )      )   | | to satisfy His subjects. Several    | ||/___________/ ||_\
 (__   ) (  ) )  | | Honorable Traders have volunteered  | ||  ||          || 
(     __)  ___)  | | to Aide in the Import of Tobacco    | || _||__________|| 
EOT
 ;;
 5 ) # Gold Increases due to War (serious)
	cat <<"EOT"
 ^^              | |      KING DEMANDS GOLD FOR WAR      | ||   
    ^^           | |                                     | ||   ____________
        ___      | | By Royal Decree, A Treaty with The  | ||  /           /\
     _ (   )_    | | Kingdom of Kastian was Broken by ye | || /           /||\
   (  )      )   | | attack on Royal Emissaries in Acte  | ||/___________/ ||_\
 (__   ) (  ) )  | | of Shame. Our King requires Gold to | ||  ||          || 
(     __)  ___)  | | Summon an Army and Go to War! ~{K}~ | || _||__________|| 
EOT
 ;;
 6 ) # Gold Required for New Fashion
	cat <<"EOT"
 ^^              | |        GOLDEN FASHION SPREADS       | ||  
    ^^           | |                                     | ||   ____________
        ___      | | The Rich Habits of ye Royal Court   | ||  /           /\
     _ (   )_    | | spreads to the Kingdom's Nobility.  | || /           /||\
   (  )      )   | | The Price of Gold heightens as the  | ||/___________/ ||_\
 (__   ) (  ) )  | | Ladies of the Court dress in Gowns  | ||  ||          || 
(     __)  ___)  | | made in the Finest of Gold Fabrics! | || _||__________|| 
EOT
 ;;
 7 ) # Discovery of New Promising Gold Field (serious)
	cat <<"EOT"
 ^^              | |      NEW GOLDE VEIN PROMISING       | || 
    ^^           | |                                     | ||   ____________
        ___      | | A new Vein of Gold discovered in ye | ||  /           /\
     _ (   )_    | | Royal Gold Mines promises a Flood   | || /           /||\
   (  )      )   | | of Golde to the Kingdom's Markets.  | ||/___________/ ||_\
 (__   ) (  ) )  | | Dwarven Advisors to ye King Himself | ||  ||          || 
(     __)  ___)  | | assure future Finds to be Great!    | || _||__________|| 
EOT
 ;;
 8 ) # Discovery of Artificial Gold Prices (them Dwarves!)
	cat <<"EOT"
 ^^              | |    GOLD PRICE MAY BE ARTEFICIAL     | ||
    ^^           | |                                     | ||   ____________
        ___      | | A Gentleman in The King's Court has | ||  /           /\
     _ (   )_    | | reveal'd ye Price of Gold strangely | || /           /||\
   (  )      )   | | Highe, as a Result of fraudelent    | ||/___________/ ||_\
 (__   ) (  ) )  | | Reports by Dwarven Mines. Ye Dwarfs | ||  ||          || 
(     __)  ___)  | | remain quiet about such Speculation | || _||__________|| 
EOT
 ;;
 9 ) # Rumors of alchemy success
	cat <<"EOT"
 ^^              | |       ALCHEMISTS PROMISE GOLD       | ||
    ^^           | |                                     | ||   ____________
        ___      | |   Zosimos ye Alchemist recently     | ||  /           /\
     _ (   )_    | | baffl'd the Royal Court proclaiming | || /           /||\
   (  )      )   | | Endeavours to create Gold would be  | ||/___________/ ||_\
 (__   ) (  ) )  | | sucessful by Year's End. Dwarven    | ||  ||          || 
(     __)  ___)  | | Sceptical about Artificial Golde.   | || _||__________|| 
EOT
 ;;
 10 ) # Water Pipe Fashion
	cat <<"EOT"
 ^^              | |     WATER PUFFING MORE HEALTHY      | ||
    ^^           | |                                     | ||   ____________
        ___      | | Ye Eastern Watr Pipes for Tobaccos  | ||  /           /\
     _ (   )_    | | of Different Flavors Altogether are | || /           /||\
   (  )      )   | | sayd to be Ailing for Sore Throats, | ||/___________/ ||_\
 (__   ) (  ) )  | | Restoring Health. The Royale Courts | ||  ||          || 
(     __)  ___)  | | report Increase in Strawberry Tabac | || _||__________|| 
EOT
 ;;
 11 ) # King Buying Tracts of land, gold inflate (serious)
	cat <<"EOT"
 ^^              | |     KING TO PURCHASE MORE LAND      | ||
    ^^           | |                                     | ||   ____________
        ___      | | By Royale Decree, to come to Our    | ||  /           /\
     _ (   )_    | | Esteem'd Neighbourdom Clausthall's  | || /           /||\
   (  )      )   | | Aid ye King hath decree'd to Buy    | ||/___________/ ||_\
 (__   ) (  ) )  | | huge Tracts of Land from ye House   | ||  ||          || 
(     __)  ___)  | | of Clausthaler. Gold demanded! ~{K}~| || _||__________|| 
EOT
 ;;
 12 ) # Tobacco pest proven to be false (serious)
	cat <<"EOT"
 ^^              | |    RUMORS OF TOBACCO PEST FALSE     | ||
    ^^           | |                                     | ||   ____________
        ___      | | Rumors of a Tobacco Pestilence that | ||  /           /\
     _ (   )_    | | destroys Entire Crops of Tabac have | || /           /||\
   (  )      )   | | proven false! Several Halfling Towns| ||/___________/ ||_\
 (__   ) (  ) )  | | expect Increase in Production due   | ||  ||          || 
(     __)  ___)  | | Favourable Weather and plenty Sun.  | || _||__________|| 
EOT
 ;;
 * ) # Default story on the board (no economic changes here)
	cat <<"EOT"
 ^^              | |      WIZARD CRAVE DRAGON (DEAD)     | ||
    ^^           | |                                     | ||   ____________
        ___      | | An Honorable Wizard in Royal School | ||  /           /\
     _ (   )_    | | of Magic and Astronomy, promises a  | || /           /||\
   (  )      )   | | Rewarde to be pay'd in Golde for ye | ||/___________/ ||_\
 (__   ) (  ) )  | | Delivery of a Dragon to ye Schoole, | ||  ||          || 
(     __)  ___)  | | preferably deceased, for study.     | || _||__________|| 
 (_____)T^T      | | REWARD SET TO: 500 GOLD             | || 1 T  T  T  T  T!
EOT
 ;;
esac

# Add generic consequence string
case $1 in
 1 | 2 | 10 ) echo " (_____)T^T      | | TOBACCO RAISED TO: $VAL_TOBACCO_STR             | || 1 T  T  T  T  T!" ;; 
 3 | 4 | 12 ) echo " (_____)T^T      | | TOBACCO LOWERED TO: $VAL_TOBACCO_STR            | || 1 T  T  T  T  T!" ;; 
 5 | 6 | 11 ) echo " (_____)T^T      | | GOLD RAISED TO: $VAL_GOLD_STR                | || 1 T  T  T  T  T!" ;; 
 7 | 8 | 9 )  echo " (_____)T^T      | | GOLD LOWERED TO: $VAL_GOLD_STR               | || 1 T  T  T  T  T!" ;; 
esac

# Display footer
cat <<"EOT"
   |^|  |^|      | l___________,____________,____________j || 1_ 1 _| __  1_ !
-  |^|  |^|     -| ||  -       &            &       -    | || 1   __  1  1  _1_
  '""" '"""'     | ||        ,-6------------6-.          | || 1  1  1  1   | `-'
  -           -  | ||       :   Y e  N e w s   :         | || '""'""'""""'"|___|
                 | ||       `-.................'         | || .       -        
       -         1 ll         -                          1 ll               -
            -~'"'""""'""~-                       --~""'"'"""""'~-
EOT
echo "$HR"
PressAnyKey
} # End of GX_Bulletin()


GX_DiceGame() { # Used in MiniGame_Dice(). Requires: $1 - 1st dice, $2 - 2nd dice
    GDICE_SYM="@" # @ looks nice:)
    DICES='                  _______________            _______________
                 [               ].         [               ].
                 |               |:         |               |:         
                 |               |:         |               |:         
                 |               |:         |               |:         
                 |               |:         |               |:         
                 |               |:         |               |:         
                 [_______________];         [_______________];
                  `~------------~`           `~------------~`                
                                                     '

    clear
    echo "$DICES" | awk ' BEGIN { FS = "" ; OFS = ""; }
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
    print; } '
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
    # TODO: Must fix the prices or add msg on current value of gold.
    tput sc # save cursor position
    tput cup 10 4 # move to y=10, x=4 ( upper left corner is 0 0 )
    echo "1 FOOD costs $PRICE_IN_GOLD Gold"
    tput cup 11 4 # move to y=10, x=4 ( upper left corner is 0 0 )
    echo "or $PRICE_IN_TOBACCO Tobacco.\""
    tput rc # restore cursor position
    echo "$HR"
}



GX_Marketplace_Merchant() { # Used in GX_Marketplace
    case "$CHAR_RACE" in # define promt
	2 ) local PROMT="galant Elf of the Forests! " ;;
	3 ) local PROMT="fierce master Dwarf! " ;;
	4 ) local PROMT="young master Hobbit! " ;;
	1 | * ) local PROMT="weather-beaten Traveller!" ;;
    esac
    clear
    cat <<"EOT"
                                                            .--^`~~.
                                                            ),-~~._/     
              THE MERCHANT                                  j-, -`;;     
                                                            .~_~  ,'       
    "Oye there,                                         __..\`#~-(.__"
    Me and my Caravan travel far and wide             ,~'    `.\/,'  `\    
    to provide the Finest Merchandise                /  ,-.   |  |  .  \ .,,  
    in the Realm, and at the best                    \  \ _)__;~~l__|\  `[ } 
    possible prices! I buy everything      .-,        `._{__7-~-~-~~; `~-'|l  
    and sell only the best, 'tis true!     ,X.             :-'      |    ;  \  
    Want to trade?"                     __(___)_.~~,__    ;     (  `l   (__,_)
                                       [ _ _ _ _,)(. _]  ;      l    `,        
                                       [_ _ _ ,'    `.] ;       )     )       
                                       [ _ _ /        \ \,_____/\____,'     
                                       l_____l        4    ;_/  ,|_/__ 
                                             `-._____,'   /--|  \._`_.) 
                                                          \_/    
EOT

    tput sc # save cursor position
    tput cup 4 16 # move to y=4, x=16 ( upper left corner is 0 0 )
    echo "$PROMT"
    # TODO add PRICING case statements at crate-height.
    tput cup 12 4  # move to y=12, x=4 ( upper left corner is 0 0 )
    echo "Price 1"
    tput cup 13 4  # move to y=13, x=4 ( upper left corner is 0 0 )
    echo "Price 2"
    tput cup 14 4  # move to y=14, x=4 ( upper left corner is 0 0 )
    echo "Price 3"
    tput rc # restore cursor position
    echo "$HR"    

}

# GX_Marketplace_Merchant() { # Used in GX_Marketplace BACKUP
# 	clear
# 	cat <<"EOT"
#                                                             .--^`~~.
#                                                             ),-~~._/     
#               THE MERCHANT                                  j-, -`;;     
#                                                             .~_~  ,'       
# EOT
# echo -en "    \"Oye there, "
# case "$CHAR_RACE" in
# 2 ) echo -n "galant Elf of the Forests!               " ;;
# 3 ) echo -n "fierce master Dwarf!                     " ;;
# 4 ) echo -n "young master Hobbit!                     " ;;
# 1 | * ) echo -n "weather-beaten Traveller!                " ;;
# esac
# echo "__..\`#~-(.__"
# 	cat <<"EOT"
#     Me and my Caravan travel far and wide             ,~'    `.\/,'  `\    
#     to provide the Finest Merchandise                /  ,-.   |  |  .  \ .,,  
#     in the Realm, and at the best                    \  \ _)__;~~l__|\  `[ } 
#     possible prices! I buy everything      .-,        `._{__7-~-~-~~; `~-'|l  
#     and sell only the best, 'tis true!     ,X.             :-'      |    ;  \  
#     Want to trade?"                     __(___)_.~~,__    ;     (  `l   (__,_)
#                                        [ _ _ _ _,)(. _]  ;      l    `,        
#                                        [_ _ _ ,'    `.] ;       )     )       
#                                        [ _ _ /        \ \,_____/\____,'     
#                                        l_____l        4    ;_/  ,|_/__ 
#                                              `-._____,'   /--|  \._`_.) 
#                                                           \_/    
# EOT
# 	echo "$HR"
	
# # TODO add PRICING case statements at crate-height.
# }



# GFX MAP FUNCTIONS
LoadCustomMap() { # Used in MapCreate()
    local LIMIT=9
    local OFFSET=0
    local NUM=0
    while (true) ; do
	GX_LoadGame
	awk '{printf "  | %-15.-15s | %-15.-15s | %-30.-30s\n", $1, $2, $3, $4;}' <<< 'NAME CREATOR DESCRIPTION'
	for (( a=1; a <= LIMIT ; a++)); do
	    NUM=$(( a + OFFSET ))
	    [[ ! ${MAPS[$NUM]} ]] && break	    
	    [[ ${MAPS[$NUM]} == "Deleted" ]] && echo "  | Deleted" && continue
	    cat "${GAMEDIR}/${MAPS[$NUM]}" | awk '{
                   if (/^NAME:/)        { RLENGTH = match($0,/: /); NAME = substr($0, RLENGTH+2); }
                   if (/^CREATOR:/)     { RLENGTH = match($0,/: /); CREATOR = substr($0, RLENGTH+2); }
                   if (/^DESCRIPTION:/) { RLENGTH = match($0,/: /); DESCRIPTION = substr($0, RLENGTH+2); }
                   FILE = "'${MAPS[$NUM]}'";
                   gsub(".map$", "", FILE);
                   }
            END { printf "%s | %-15.15s | %-15.15s | %-30.30s\n", "'$a'", NAME, CREATOR, DESCRIPTION ;}'
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
		read -sn1 -p "Play this map? [Y/N]: " VAR
		case "$VAR" in
		    y | Y ) CUSTOM_MAP="${GAMEDIR}/${MAPS[$NUM]}" ; return 0;; # Return to MapCreate()
		    * )     unset MAP ;;
		esac
		;;
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

    if [[ "${MAPS[@]}" ]] ; then # If there is/are  custom map/s
	GX_LoadGame
	read -sn 1 -p "Would you like to play (C)ustom map or (D)efault? " MAP
	case "$MAP" in
	    c | C) LoadCustomMap && return 0;; #leave
	esac
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
# Map template generator (CLI arg function)
MapCreateCustom() {
    [[ ! -d "$GAMEDIR" ]] && Die "Please create $GAMEDIR/ directory before running" 
    
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
}

#                          END GFX FUNCTIONS                           #
#                                                                      #
#                                                                      #
########################################################################

########################################################################
#                                                                      #
#                          1. FUNCTIONS                                #
#                    All program functions go here!                    #

Die() {
    echo -e "$1" && exit 1
}

CleanUp() { # Used in MainMenu(), NewSector(),
    GX_BiaminTitle
    echo -e "\n$HR"
    [[ "$FIGHTMODE" ]] && { #  -20 HP -20 EXP Penalty for exiting CTRL+C during battle!
    	CHAR_HEALTH=$(( CHAR_HEALTH-20 )) ;
    	CHAR_EXP=$(( CHAR_EXP-20 )) ;
    	echo "PENALTY for CTRL+Chickening out during battle: -20 HP -20 EXP" ;
    	echo -e "HEALTH: $CHAR_HEALTH\tEXPERIENCE: $CHAR_EXP" ; }
    [[ "$CHAR" ]] && SaveCurrentSheet # Don't try to save if we've nobody to save :)
    echo -e "\nLeaving the realm of magic behind ....\nPlease submit bugs and feedback at <$WEBURL>"
    exit 0
}
# PRE-CLEANUP tidying function for buggy custom maps
CustomMapError() { # Used in MapCreate(), GX_Place() and NewSector()
    local ERROR_MAP=$1
    clear
    echo "Whoops! There is an error with your map file!
Either it contains unknown characters or it uses incorrect whitespace.
Recognized characters are: x . T @ H C
Please run game with --map argument to create a new template as a guide.

What to do?
1) rename $ERROR_MAP to ${ERROR_MAP}.error or
2) delete template file CUSTOM.map (deletion is irrevocable)."
    read -n 1 -p "Please select 1 or 2: " MAP_CLEAN_OPTS
    case "$MAP_CLEAN_OPTS" in
	1 ) mv "${ERROR_MAP}" "${ERROR_MAP}.error" ;
	    echo -e "\nCustom map file moved to ${ERROR_MAP}.error" ;
	    sleep 4 ;;
	2 ) rm -f "${ERROR_MAP}" ;
	    echo -e "\nCustom map deleted!" ;
	    sleep 4 ;;
	* ) Die "\nBad option! Quitting.." ;;
    esac
}

SetupHighscore() { # Used in main() and Announce()
	HIGHSCORE="$GAMEDIR/highscore" ;
	[[ -f "$HIGHSCORE" ]] || touch "$HIGHSCORE"; # Create empty "$GAMEDIR/highscore" if not exists	
	grep -q 'd41d8cd98f00b204e9800998ecf8427e' "$HIGHSCORE" && echo "" > "$HIGHSCORE" # Backwards compatibility: replaces old-style empty HS..
}

### DISPLAY MAP
GX_Map() { # Used in MapNav()
    if ((CHAR_ITEMS > 0)) && ((CHAR_ITEMS < 8)) ; then # Check for Gift of Sight
	# Show ONLY the NEXT item viz. "Item to see" (ITEM2C). There always will be item in HOTZONE[0]!
     	IFS="-" read -r "ITEM2C_X" "ITEM2C_Y" <<< "${HOTZONE[0]}" # Retrieve item map positions e.g. 1-15 >> X=1 Y=15
	# Remember, the player won't necessarily find items in HOTZONE array's sequence
    else # Lazy fix for awk - it falls when see undefined variable #kstn
	ITEM2C_Y=0 && ITEM2C_X=0 
    fi

    clear
    awk 'BEGIN { FS = "   " ; OFS = "   "; }
    {
      # place "o" (player) on map
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
      print;
    }' <<< "$MAP"
}
# SAVE CHARSHEET
SaveCurrentSheet() { # Saves current game values to CHARSHEET file (overwriting)
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
TURN: $TURN" > "$CHARSHEET"
}


# CHAR SETUP
BiaminSetup() { # Used in MainMenu()
    # Set CHARSHEET variable to gamedir/char.sheet (lowercase)
    CHARSHEET="$GAMEDIR/$(echo "$CHAR" | tr '[:upper:]' '[:lower:]' | tr -d " ").sheet"
    # Check whether CHAR exists if not create CHARSHEET
    if [[ -f "$CHARSHEET" ]] ; then
	echo -en " Welcome back, $CHAR!\n Loading character sheet ..." # -n for 80x24, DO NOT REMOVE IT #kstn
	
	# Sequence for updating older charsheets to later additions (compatibility)
	grep -q -E '^HOME:' "$CHARSHEET"        || echo "HOME: $START_LOCATION" >> $CHARSHEET
	grep -q -E '^GOLD:' "$CHARSHEET"        || echo "GOLD: 10" >> $CHARSHEET
	grep -q -E '^TOBACCO:' "$CHARSHEET"     || echo "TOBACCO: 10" >> $CHARSHEET
	grep -q -E '^FOOD:' "$CHARSHEET"        || echo "FOOD: 10" >> $CHARSHEET
	grep -q -E '^BBSMSG:' "$CHARSHEET"      || echo "BBSMSG: 0" >> $CHARSHEET
	grep -q -E '^STARVATION:' "$CHARSHEET"  || echo "STARVATION: 0" >> $CHARSHEET
	# TODO use  OFFSET_{GOLD,TOBACCO} 
	grep -q -E '^VAL_GOLD:' "$CHARSHEET"    || echo "VAL_GOLD: 1" >> $CHARSHEET
	grep -q -E '^VAL_TOBACCO:' "$CHARSHEET" || echo "VAL_TOBACCO: 1" >> $CHARSHEET
	grep -q -E '^VAL_CHANGE:' "$CHARSHEET"  || echo "VAL_CHANGE: 0.25" >> $CHARSHEET
	# Time 
	grep -q -E '^TURN:' "$CHARSHEET"        || echo "TURN: 0" >> $CHARSHEET
	# TODO I don't know why, but "read -r VAR1 VAR2 VAR3 <<< $(awk $FILE)" not works :(
	# But one local variable at any case is better that to open one file eight times
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
                   # new
                   if (/^TURN:/)    { TURN= $2 }
                 }
                 END { 
                 print CHARACTER ";" RACE ";" BATTLES ";" EXPERIENCE ";" LOCATION ";" HEALTH ";" ITEMS ";" KILLS ";" HOME ";" GOLD ";" TOBACCO ";" FOOD ";" BBSMSG ";" VAL_GOLD ";" VAL_TOBACCO ";" VAL_CHANGE ";" STARVATION ";" TURN ";"
                 }' $CHARSHEET )
	IFS=";" read -r CHAR CHAR_RACE CHAR_BATTLES CHAR_EXP CHAR_GPS CHAR_HEALTH CHAR_ITEMS CHAR_KILLS CHAR_HOME CHAR_GOLD CHAR_TOBACCO CHAR_FOOD BBSMSG VAL_GOLD VAL_TOBACCO VAL_CHANGE STARVATION TURN <<< "$CHAR_TMP"
	unset CHAR_TMP
	# If character is dead, don't fool around..
	(( CHAR_HEALTH <= 0 )) && Die "\nWhoops!\n $CHAR's health is $CHAR_HEALTH!\nThis game does not support necromancy, sorry!"
	sleep 2
    else
	echo " $CHAR is a new character!"
	CHAR_BATTLES=0
	CHAR_EXP=0
	CHAR_HEALTH=100
	CHAR_ITEMS=0
	CHAR_KILLS=0
	BBSMSG=0
	STARVATION=0;
	TURN=0			# For the beginning player starts from 1st Jan 1 year. After starting date'll be random
	GX_Races
	read -sn 1 -p " Select character race (1-4): " CHAR_RACE
	case "$CHAR_RACE" in
	    2 ) echo "You chose to be an ELF" && OFFSET_GOLD=3 && OFFSET_TOBACCO=2 ;;
	    3 ) echo "You chose to be a DWARF" && OFFSET_GOLD=2 && OFFSET_TOBACCO=3 ;;
	    4 ) echo "You chose to be a HOBBIT" && OFFSET_GOLD=3 && OFFSET_TOBACCO=2 ;;
	    1 | * ) CHAR_RACE=1 && echo "You chose to be a HUMAN" && OFFSET_GOLD=2 && OFFSET_TOBACCO=3 ;;
	esac
	
	# WEALTH formula = D12 - (D6 * CLASS OFFSET)
	# Determine Initial Wealth of GOLD 
	RollDice 20 && CHAR_GOLD=$DICE
	RollDice 6 && OFFSET_GOLD=$( bc <<< "$OFFSET_GOLD * $DICE" )
	# Adjusting CHAR_GOLD to CHAR_RACE offsets
	case $CHAR_RACE in
	    1 | 3 ) CHAR_GOLD=$( bc <<< "$CHAR_GOLD + $OFFSET_GOLD" ) ;; # Humans and dwarves
	    2 | 4 ) CHAR_GOLD=$( bc <<< "$CHAR_GOLD - $OFFSET_GOLD" ) ;; # Elves and hobbits
	esac

	# Determine Initial Wealth of TOBACCO
	RollDice 20 && CHAR_TOBACCO=$DICE 
	RollDice 6 && OFFSET_TOBACCO=$( bc <<< "$OFFSET_TOBACCO * $DICE" )
	# Adjusting CHAR_TOBACCO to CHAR_RACE offsets
	case $CHAR_RACE in
	    2 | 4 ) CHAR_TOBACCO=$( bc <<< "$CHAR_TOBACCO + $OFFSET_TOBACCO" ) ;; # Humans and dwarves
	    1 | 3 ) CHAR_TOBACCO=$( bc <<< "$CHAR_TOBACCO - $OFFSET_TOBACCO" ) ;; # Elves and hobbits
	esac

	# Set negative values to 0 [not floating numbers]
	(( CHAR_GOLD < 0 ))    && CHAR_GOLD=0    # poor bastard
	(( CHAR_TOBACCO < 0 )) && CHAR_TOBACCO=0 # healthy bastard
	
	# Determine initial food stock (D20)
	RollDice 20 && CHAR_FOOD=$DICE
	(( CHAR_FOOD < 5 )) && CHAR_FOOD=5
	
	# Set initial Value of Currencies
	VAL_GOLD=1
	VAL_TOBACCO=1
	VAL_CHANGE=0.25
	
	# Add location info
	CHAR_GPS="$START_LOCATION"
	CHAR_HOME="$START_LOCATION"
	# If there IS a CUSTOM.map file, ask where the player would like to start
	if [[ "$CUSTOM_MAP" ]] ; then
#	    START_LOCATION=$(awk '{ if (/^START LOCATION:/) { print $2; exit; } print "'$START_LOCATION'"; }' <<< "$CUSTOM_MAP" )
	    read -p " HOME location for custom maps (ENTER for default $START_LOCATION): " "CHAR_LOC"
	    if [[ ! -z "$CHAR_LOC" ]]; then
		# Use user input as start location.. but first SANITY CHECK
		read CHAR_LOC_LEN CHAR_LOC_A CHAR_LOC_B <<< $(awk '{print length($0) " " substr($0,0,1) " " substr($0,2)}' <<< "$CHAR_LOC")
		(( CHAR_LOC_LEN < 1 )) && Die " Error! Too less characters in $CHAR_LOC\n Start location is 2-3 alphanumeric chars [A-R][1-15], e.g. C2 or P13"
		(( CHAR_LOC_LEN > 3 )) && Die " Error! Too many characters in $CHAR_LOC\n Start location is 2-3 alphanumeric chars [A-R][1-15], e.g. C2 or P13"
		echo -n "Sanity check.."
		case "$CHAR_LOC_A" in
		    A | B | C | D | E | F | G | H | I | J | K | L | M | N | O | P | Q | R ) echo -n ".." ;;
		    * ) Die "\n Error! Start location X-Axis $CHAR_LOC_A must be a CAPITAL alphanumeric A-R letter!" ;;
		esac
		case "$CHAR_LOC_B" in
		    1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 ) echo ".. Done!" ;;
		    * ) Die "\n Error! Start location Y-Axis $CHAR_LOC_B is too big or too small!";;
		esac
		unset CHAR_LOC_LEN CHAR_LOC_A CHAR_LOC_B
		# End of SANITY check, everything okay!
		CHAR_GPS="$CHAR_LOC"
		CHAR_HOME="$CHAR_LOC"
		unset CHAR_LOC
	    fi # or CHAR_GPS and CHAR_HOME not changed from START_LOCATION
	fi
	echo " Creating fresh character sheet for $CHAR ..."
	SaveCurrentSheet
	sleep 2
    fi # Finish check whether CHAR exists if not create CHARSHEET 

    # Set abilities according to race (each equal to 12) + string var used frequently
    case $CHAR_RACE in
	1 ) HEALING=3 ; STRENGTH=3 ; ACCURACY=3 ; FLEE=3 ; CHAR_RACE_STR="human" ;; # human  (3,3,3,3)
	2 ) HEALING=4 ; STRENGTH=3 ; ACCURACY=4 ; FLEE=1 ; CHAR_RACE_STR="elf"   ;; # elf    (4,3,4,1)
	3 ) HEALING=2 ; STRENGTH=5 ; ACCURACY=3 ; FLEE=2 ; CHAR_RACE_STR="dwarf" ;; # dwarf  (2,5,3,2)
	4 ) HEALING=4 ; STRENGTH=1 ; ACCURACY=4 ; FLEE=3 ; CHAR_RACE_STR="hobbit";; # hobbit (4,1,4,3)
    esac

    # Adjust abilities according to items
    if (( CHAR_ITEMS >= 2 )); then
	((HEALING++))			# Adjusting for Emerald of Narcolepsy
	if (( CHAR_ITEMS >= 4 )); then
	    ((FLEE++))			# Adjusting for Fast Magic Boots
	    if (( CHAR_ITEMS >= 7 )); then		
		((STRENGTH++))		# Adjusting for Broadsword
		if (( CHAR_ITEMS >= 8 )); then	
		    ((ACCURACY++))	# Adjusting for Steady Hand Brew
		fi
	    fi
	fi
    fi

    # If Cheating is disabled (in CONFIGURATION) restrict health to 150
    (( DISABLE_CHEATS == 1 )) && (( CHAR_HEALTH >= 150 )) && CHAR_HEALTH=150
    Intro
}

DateFromTurn() {
    local YEAR_LENGHT=400
    local MONTH_STR=("Biamin Festival" # rarely happens, if ever :(
	"Witching Day"
	"After-Witching" "Year-Turn" 
	"Mid-Spring Day"
	"Plough Month" "Sigmar Month" 
	"Sun Still Day"
	"Summer Month" "Fore-Mystery" 
	"Mystery Day"
	"After-Mystery" "Harvest Month" 
	"Mid-Autumn Day"
	"Brew Month" "Chill Month" "Ulric Month" 
	"World Still Day"
	"Fore-Witching")
    local MONTH_LENGTH=( 0 0 1 33 66 67 100 133 166 167 200 201 233 266 267 300 333 366 367 400 )

    local WEEKDAY_STR=("Festag (Holiday)" "Wellentag (Work day)" "Aubentag (Levy day)" "Marktag (Market day)"
	"Backertag (Bake day)" "Bezahltag (Tax day)" "Konistag (King day)" "Angestag (Start week)") # Last day of week is ${WEEKDAY_STR[0]} !!!
    # http://warhammeronline.wikia.com/wiki/Morrslieb
    # Where Mannslieb is full every 25 days, on a constant and predictable cycle, 
    case $( bc <<< "( $TURN % 25 )" ) in
	0 | 1 | 2 | 3 ) MOON="New moon" ;;
	4 | 5 | 6 )     MOON="Waxing crescent" ;;
	7 | 8 | 9 )     MOON="First quarter" ;;
	10 | 11 | 12 )  MOON="Waxing gibbous" ;;
	13 | 14 | 15 )  MOON="Full moon" ;;
	16 | 17 | 18 )  MOON="Waning gibbous" ;;
	19 | 20 | 21 )  MOON="Third quarter" ;;
	22 | 23 | 24 )  MOON="Waning crescent" ;;
    esac

    WEEKDAY=${WEEKDAY_STR[$( bc <<< "$TURN % 8" )]}

    YEAR=$( bc <<< "( $TURN / $YEAR_LENGHT ) + 1" )
    local REMAINDER=$( bc <<< "$TURN % $YEAR_LENGHT" ) # month and days
    (( REMAINDER == 0 )) && ((YEAR--)) && REMAINDER=$YEAR_LENGHT # last day of year fix
    local MONTH_NUM=$( awk '{  
                    if ($0 == 1 )   { print "1"; exit; }
                    if ($0 <= 33 )  { print "2"; exit; }
                    if ($0 <= 66 )  { print "3"; exit; }
                    if ($0 == 67 )  { print "4"; exit; }
                    if ($0 <= 100 ) { print "5"; exit; }
                    if ($0 <= 133 ) { print "6"; exit; }
                    if ($0 <= 166 ) { print "7"; exit; }
                    if ($0 == 167 ) { print "8"; exit; }
                    if ($0 <= 200 ) { print "9"; exit; }
                    if ($0 == 201 ) { print "10"; exit; }
                    if ($0 <= 233 ) { print "11"; exit; }
                    if ($0 <= 266 ) { print "12"; exit; }
                    if ($0 == 267 ) { print "13"; exit; }
                    if ($0 <= 300 ) { print "14"; exit; }
                    if ($0 <= 333 ) { print "15"; exit; }
                    if ($0 <= 366 ) { print "16"; exit; }
                    if ($0 == 367 ) { print "17"; exit; }
                    if ($0 <= 400 ) { print "18"; exit; }
                    }' <<< "$REMAINDER" )
    case "$MONTH_NUM" in
	1 | 4 | 8 | 10 | 13 | 17 ) DAY=${MONTH_STR[$MONTH_NUM]} ;; # 'Witching Day' etc. 
	*)  MONTH=${MONTH_STR[$MONTH_NUM]}
	    DAY=$( bc <<< "$REMAINDER - ${MONTH_LENGTH[$MONTH_NUM]}" )
	    case "$DAY" in # Adjust date
		1 | 21 | 31 ) DAY+="st" ;;
		2 | 22 | 32 ) DAY+="nd" ;;
		3 | 23 | 33 ) DAY+="rd" ;;
 		* )           DAY+="th" ;;
	    esac
    esac
    (( YEAR > 99 )) && YEAR=$( bc <<< "$YEAR % 100" ) # FIX for year > 100
    case "$YEAR" in 
	1 | 21 | 31 | 41 | 51 | 61 | 71 | 81 | 91 ) YEAR+="st";;
	2 | 22 | 32 | 42 | 52 | 62 | 72 | 82 | 92 ) YEAR+="nd";;
	3 | 23 | 33 | 43 | 53 | 63 | 73 | 83 | 93 ) YEAR+="rd";;
	*) YEAR+="th";;
    esac

    case "$MONTH_NUM" in
	1 | 4 | 8 | 10 | 13 | 17 ) 
	    # Output example "Witching Day in the 13th cycle"
	    MONTH=""; # !!! Do not remove - fix for HighScore
	    BIAMIN_DATE_STR="The $DAY in the $YEAR Cycle";;
	*)  # Output example "3rd of Year-Turn in the 13th cycle"
	    BIAMIN_DATE_STR="$DAY of $MONTH in the $YEAR Cycle";;
    esac

}

TodaysDate() {
    # An adjusted version of warhammeronline.wikia.com/wiki/Calendar
    # Variables used in DisplayCharsheet () ($TODAYS_DATE_STR), and
    # in FightMode() ($TODAYS_DATE_STR, $TODAYS_DATE, $TODAYS_MONTH, $TODAYS_YEAR)

    # TODO: Decouple biamin date from real date once CREATION is set in charsheet
    # Add check here, IF CREATION is not set, CREATION && DATE in CHARSHEET is TodaysDate
    # if [[ $CREATION == 0 ]] ; then # first run
    read -r "TODAYS_YEAR" "TODAYS_MONTH" "TODAYS_DATE" <<< "$(date '+%-y %-m %-d')"
    # else
    # just increment date, month and/or year..
    # fi
    # TODO: Add CREATED or CREATION + DATE in charsheets:) Would be nice to have them after the char name..
    # NOTE: We probably shouldn't use $DATE but $BIAMIN_DATE or $GAMEDATE.
    
    # Adjust date
    case "$TODAYS_DATE" in
	1 | 21 | 31 ) TODAYS_DATE+="st" ;;
	2 | 22 ) TODAYS_DATE+="nd" ;;
	3 | 23 ) TODAYS_DATE+="rd" ;;
 	* ) TODAYS_DATE+="th" ;;
    esac
    # Adjust month
    case "$TODAYS_MONTH" in
	1 ) TODAYS_MONTH="After-Witching" ;;
	2 ) TODAYS_MONTH="Year-Turn" ;;
	3 ) TODAYS_MONTH="Plough Month" ;;
	4 ) TODAYS_MONTH="Sigmar Month" ;;
	5 ) TODAYS_MONTH="Summer Month" ;;
	6 ) TODAYS_MONTH="Fore-Mystery" ;;
	7 ) TODAYS_MONTH="After-Mystery" ;;
	8 ) TODAYS_MONTH="Harvest Month" ;;
	9 ) TODAYS_MONTH="Brew Month" ;;
 	10 ) TODAYS_MONTH="Chill Month" ;;
 	11 ) TODAYS_MONTH="Ulric Month" ;;
 	12 ) TODAYS_MONTH="Fore-Witching" ;;
 	* ) TODAYS_MONTH="Biamin Festival" ;;  # rarely happens, if ever :(
    esac
    case "$TODAYS_YEAR" in
	1 | 21 | 31 | 41 | 51 | 61 | 71 | 81 | 91 ) TODAYS_YEAR+="st";;
	2 | 22 | 32 | 42 | 52 | 62 | 72 | 82 | 92 ) TODAYS_YEAR+="nd";;
	3 | 23 | 33 | 43 | 53 | 63 | 73 | 83 | 93 ) TODAYS_YEAR+="rd";;
	*) TODAYS_YEAR+="th";;
    esac
    # Output example "3rd of Year-Turn in the 13th cycle"
    TODAYS_DATE_STR="$TODAYS_DATE of $TODAYS_MONTH in the $TODAYS_YEAR Cycle"
}


## WORLD EVENT functions

WorldChangeEconomy() {  # Used in NewSector()
	CHANGETYPE="$1" # In/Deflation (either + or - symbol)
	UNITTYPE="$2"	# Tobacco/Gold
	RollDice "$3"   # $3 == Severity, Roll for severity in fluctuation
	FLUX=$( bc <<< "$DICE * $VAL_CHANGE" )
	case "$UNITTYPE" in # Which market's affected?
	    1 ) VAL_TOBACCO=$( bc <<< "$VAL_TOBACCO $CHANGETYPE $FLUX" ) # How is tobacco affected?
		(( $(bc <<< "$VAL_TOBACCO <= 0") )) && VAL_TOBACCO=0.25	 # Adjusted for min 0.25 value
		VAL_TOBACCO_STR=$( awk '{ printf "%4.2f", $0 }' <<< $VAL_TOBACCO ) ;;  # Used in GX_Bulletin()
	    2 ) VAL_GOLD=$( bc <<< "$VAL_GOLD $CHANGETYPE $FLUX" )       # How is gold affected?
		(( $(bc <<< "$VAL_GOLD <= 0") )) && VAL_GOLD=0.25	 # Adjusted for min 0.25 value
		VAL_GOLD_STR=$( awk '{ printf "%4.2f", $0 }'  <<< $VAL_GOLD ) ;; # Used in GX_Bulletin()
	esac
} # Return to NewSector()

# Other WorldChangeFUNCTIONs go here:)

################### MENU SYSTEM #################

MainMenu() {
    while (true) ; do # Forever, because we exit through CleanUp()
	GX_Banner 		
	read -sn 1 -p "      (P)lay      (L)oad game      (H)ighscore      (C)redits      (Q)uit" TOPMENU_OPT
	case "$TOPMENU_OPT" in
	    p | P ) GX_Banner ; 
 		    read -p " Enter character name (case sensitive): " CHAR ;
		    [[ "$CHAR" ]] && BiaminSetup;; # Do nothing if CHAR is empty
	    l | L ) LoadGame && BiaminSetup;; # Do nothing if CHAR is empty
	    h | H ) HighScore ;;
	    c | C ) Credits ;;
	    q | Q ) CleanUp ;;
	    * ) ;;
	esac
    done
}
# Highscore
HighscoreRead() {
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

HighScore() { # Used in MainMenu()
    GX_HighScore
    echo ""
    # Show 10 highscore entries or die if Highscore list is empty
    [ -s "$HIGHSCORE" ] && HighscoreRead || echo -e " The highscore list is unfortunately empty right now.\n You have to play some to get some!"
    echo "" # empty line TODO fix it
    read -sn 1 -p "                    Press the any key to go to (M)ain menu"
}   # Return to MainMenu()

Credits() { # Used in MainMenu()
    GX_Credits
    read -sn 1 -p "             (H)owTo             (L)icense             (M)ain menu" "CREDITS_OPT"
    case "$CREDITS_OPT" in
	L | l ) License ;;
	H | h ) GX_HowTo ;;
    esac
    unset CREDITS_OPT
}   # Return to MainMenu()

PrepareLicense() { # gets licenses and concatenates into "LICENSE" in $GAMEDIR
    # TODO add option to use wget if systen hasn't curl (Debian for instance) -kstn
    # TODO I'm not sure. I was told to use curl because it has greater compatibility than wget..? - s3
    echo " Download GNU GPL Version 3 ..."
    GPL=$(curl -s "http://www.gnu.org/licenses/gpl-3.0.txt" || "") # I didn't know we could do that :)
    echo " Download CC BY-NC-SA 4.0 ..."
    CC=$(curl -s "http://creativecommons.org/licenses/by-nc-sa/4.0/legalcode.txt" || "")
    if [[ $GPL && $CC ]] ; then 
	echo -e "\t\t   BACK IN A MINUTE BASH CODE LICENSE:\t\t\t(Q)uit\n
$HR
$GPL
\n$HR\n\n\t\t   BACK IN A MINUTE ARTWORK LICENSE:\n\n
$CC"  > "$GAMEDIR/LICENSE"
	echo " Licenses downloaded and concatenated!"
	sleep 1
	return 0
    else
	echo "Couldn't download license files :( Do you have Internet access?"
	sleep 1
	return 1
    fi
}

ShowLicense() { # Used in License()
	case "$PAGER" in
		0 ) echo -en "\n License file available at $GAMEDIR/LICENSE\n" && PressAnyKey ;;
		* ) "$PAGER" "$GAMEDIR/LICENSE" ;;
	esac
}
License() { # Used in Credits()
    # Displays license if present or runs PrepareLicense && then display it..
    GX_BiaminTitle
    if [ -z "$PAGER" ] ; then				# If $PAGER is not set
	if [ -f "/usr/bin/less" ] ; then
	    local PAGER="/usr/bin/less"		# try less
	elif [ -f "/usr/bin/more" ] ; then
	    local PAGER="/usr/bin/more"		# or try more
	else
	    local PAGER="0"		# or fallback gracefully (see ShowLicense in case PAGER is 0)
	fi
    fi
    if [ -f "$GAMEDIR/LICENSE" ]; then
	ShowLicense
    else
	echo -e "\n License file currently missing in $GAMEDIR/ !"
	read -p " To DL licenses, about 60kB, type YES (requires internet access): " "DL_LICENSE_OPT"
	case "$DL_LICENSE_OPT" in
	    YES ) PrepareLicense && ShowLicense ;;
	    * )   echo -e "
Code License:\t<http://www.gnu.org/licenses/gpl-3.0.txt>
Art License:\t<http://creativecommons.org/licenses/by-nc-sa/4.0/legalcode.txt>
More info:\t<${WEBURL}about#license>
Press any key to go back to main menu!";
		read -sn 1;;
	esac
    fi
}   # Return to Credits() 

LoadGame() { # Used in MainMenu()
    local i=0 # Count of all sheets. We could use ${#array_name[@]}, but I'm not sure if MacOS'll understand that. So let's invent bicycle!
    # xargs ls -t - sort by date, last played char'll be the first in array
    for loadSHEET in $(find "$GAMEDIR"/ -name '*.sheet' | xargs ls -t) ; do # Find all sheets and add to array if any
	SHEETS[((++i))]="$loadSHEET" # $i++ THAN initialize SHEETS[$i]
    done

    if [[ ! ${SHEETS[@]} ]] ; then # If no one sheet was found
	GX_LoadGame
	echo " Sorry! No character sheets in $GAMEDIR/"
	read -sn 1 -p " Press any key to return to (M)ain menu and try (P)lay" # St. Anykey - patron of cyberneticists :)
	return 1   # BiaminSetup() will not be run after LoadGame()
    fi

    local LIMIT=9
    local OFFSET=0
    while (true) ; do
	GX_LoadGame
	for (( a=1; a <= LIMIT ; a++)); do
	    [[ ! ${SHEETS[((a + OFFSET))]} ]] && break
 	    awk '{ # Character can consist from two and more words, not only "Corum" but "Corum Jhaelen Irsei" for instance 
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
                 print " "'$a' ". \"" CHARACTER "\" the " RACE " (" HEALTH " HP, " EXPERIENCE " EXP, " ITEMS " items, sector " LOCATION ")" 
                 }' ${SHEETS[((a + OFFSET))]} 
	done
	(( i > LIMIT)) && echo -en "\n You have more than $LIMIT characters. Use (P)revious or (N)ext to list," # Don't show it if there are chars < LIMIT
	echo -en "\n Enter NUMBER of character to load or any letter to return to (M)ain Menu: "
	read -n 1 NUM # TODO replace to read -p after debug
	case "$NUM" in
	    n | N ) ((OFFSET + LIMIT < i)) && ((OFFSET += LIMIT)) ;; # Next part of list
	    p | P ) ((OFFSET > 0))         && ((OFFSET -= LIMIT)) ;; # Previous part of list
	    [1-9] ) NUM=$((NUM + OFFSET)); break;;                   # Set NUM = selected charsheet num
	    *     ) NUM=0; break;; # Unset NUM to prevent fall in [[ ! ${SHEETS[$NUM]} ]] if user press ESC, KEY_UP etc. ${SHEETS[0]} is always empty
	esac
    done
    echo "" # TODO empty line - fix it later
    if [[ ! ${SHEETS[$NUM]} ]] ; then
	unset NUM SHEETS i
	return 1 # BiaminSetup() will not be run after LoadGame()
    else
	CHAR=$(awk '{if (/^CHARACTER:/) { RLENGTH = match($0,/: /); print substr($0, RLENGTH+2);}}' ${SHEETS[$NUM]} );
	unset NUM SHEETS i
	return 0 # BiaminSetup() will be run after LoadGame()
    fi
}   # return to MainMenu()

# GAME ITEMS
# Randomizer for Item Positions
ITEM_YX() { # Used in HotzonesDistribute() and GX_Map()
    ITEM_Y=$((RANDOM%15+1))
    ITEM_X=$((RANDOM%18+1))
}

HotzonesDistribute() { # Used in Intro() and ItemWasFound()
    # Scatters special items across the map
    # bugfix to prevent finding item at 1st turn of 2 or more items at one turn
    local MAP_X;
    local MAP_Y;
    read -r MAP_X MAP_Y  <<< $(awk '{ print substr($0, 1 ,1); print substr($0, 2); }' <<< "$CHAR_GPS")
    MAP_X=$(awk '{print index("ABCDEFGHIJKLMNOPQR", $0)}' <<< "$MAP_X") # converts {A..R} to {1..18}
    ITEMS_2_SCATTER=$(( 8 - CHAR_ITEMS ))
    HOTZONE=() # Reset HOTZONE  
    while (( ITEMS_2_SCATTER > 0 )) ; do
	ITEM_YX # Randomize ITEM_X and ITEM_Y
	(( ITEM_X ==  MAP_X )) && (( ITEM_Y == MAP_Y )) && continue                  # reroll if HOTZONE == CHAR_GPS
	[[ $(grep -E "(^| )$ITEM_X-$ITEM_Y( |$)" <<< "${HOTZONE[@]}") ]] && continue # reroll if "$ITEM_X-$ITEM_Y" is already in ${HOTZONE[@]}
	HOTZONE[((--ITEMS_2_SCATTER))]="$ITEM_X-$ITEM_Y" # --ITEMS_2_SCATTER, then init ${HOTZONE[ITEMS_2_SCATTER]},
	# --ITEMS_2_SCATTER - because array starts from ${HOTZONE[0]} #kstn
    done
}
################### GAME SYSTEM #################
RollDice() {     # Used in RollForEvent(), RollForHealing(), etc
    # SEED=$(head -1 /dev/urandom | od -N 1 | awk '{ print $2 }'| sed s/^0*//)
    # RANDOM=$SEED
    # Suggestion from: http://tldp.org/LDP/abs/html/randomvar.html

    DICE_SIZE=$1         # DICE_SIZE used in RollForEvent()
    RANDOM=$(date '+%N') # Reseed random number generator using nano seconds    
    DICE=$((RANDOM%$DICE_SIZE+1))
}

## GAME FUNCTIONS: ITEMS IN LOOP
ItemWasFound() { # Used in NewSector()
    case "$CHAR_ITEMS" in
	0 ) GX_Item0 ;;				# Gift of Sight (set in MapNav)
	1 ) (( HEALING++ )) && GX_Item1 ;;	# Emerald of Narcolepsy (set now & setup)
	2 ) GX_Item2 ;;				# Guardian Angel (set in battle loop)
	3 ) (( FLEE++ )) && GX_Item3 ;;         # Fast Magic Boots (set now & setup)
	4 ) GX_Item4 ;;				# Quick Rabbit Reaction (set in battle loop)
	5 ) GX_Item5 ;;				# Flask of Terrible Odour (set in battle loop)
	6 ) (( STRENGTH++ )) && GX_Item6 ;;	# Two-Handed Broadsword	(set now & setup)
	7 ) (( ACCURACY++ )) && GX_Item7 ;;	# Steady Hand Brew (set now & setup)
    esac

    local COUNTDOWN=180
    while (( COUNTDOWN > 0 )); do
	echo -en "${CLEAR_LINE}                      Press any letter to continue  ($COUNTDOWN)"
	read -sn 1 -t 1 && COUNTDOWN=-1 || ((COUNTDOWN--))
    done
    # Re-distribute items to increase randomness if char haven't all 8 items. Now it is not bugfix but feauture
    (( ++CHAR_ITEMS < 8 )) && HotzonesDistribute # Increase CHAR_ITEMS , THEN check (( CHAR_ITEMS < 8 ))
    SaveCurrentSheet # Save CHARSHEET items
    NODICE=1         # No fighting if item is found..
}   # Return to NewSector()

## GAME ACTION: MAP + MOVE
MapNav() { # Used in NewSector()
    if [[ -z "$1" ]] ; then	# If empty = toggle map (m) was pressed, else just move!
	GX_Map
	# If COLOR==0, YELLOW and RESET =="" so string'll be without any colors
	echo -e " ${YELLOW}o ${CHAR}${RESET} is currently in $CHAR_GPS ($PLACE)\n$HR" # PLACE var defined in GX_Place()
	read -sn 1 -p " I want to go  (W) North  (A) West  (S)outh  (D) East  (Q)uit :  " DEST
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
    MAP_X=$(awk '{print substr("ABCDEFGHIJKLMNOPQR", '$MAP_X', 1)}' <<< "$MAP_X") # Translate MAP_X numeric back to A-R
    CHAR_GPS="$MAP_X$MAP_Y" 	# Set new [A-R][1-15] to CHAR_GPS
    sleep 3 # Merged with sleep from 'case "$DEST"' section
}   # Return NewSector()

# GAME ACTION: DISPLAY CHARACTER SHEET
DisplayCharsheet() { # Used in NewSector() and FightMode()
    MURDERSCORE=$(bc <<< "if ($CHAR_KILLS > 0) {scale=zero; 100 * $CHAR_KILLS/$CHAR_BATTLES } else 0" ) # kill/fight percentage
    local RACE=$(awk '{ print substr(toupper($0), 1,1) substr($0, 2); }' <<< "$CHAR_RACE_STR") # Capitalize
    GX_CharSheet
    cat <<EOF
 Character:                 $CHAR ($RACE)
 Health Points:             $CHAR_HEALTH
 Experience Points:         $CHAR_EXP
 Current Location:          $CHAR_GPS ($PLACE)
 Number of Battles:         $CHAR_BATTLES
 Enemies Slain:             $CHAR_KILLS ($MURDERSCORE%)
 Items found:               $CHAR_ITEMS of 8
 Special Skills:            Healing $HEALING, Strength $STRENGTH, Accuracy $ACCURACY, Flee $FLEE
 Inventory:                 $CHAR_GOLD Gold, $CHAR_TOBACCO Tobacco, $CHAR_FOOD Food
 Current Date:              $TODAYS_DATE_STR
 Turn (DEBUG):              $TURN (don't forget to remove it :) ) 
 Biamin Date:               $BIAMIN_DATE_STR
EOF
	read -sn 1 -p "      (D)isplay Race Info        (A)ny key to continue          (Q)uit" CHARSHEET_OPT
	case "$CHARSHEET_OPT" in
		d | D ) GX_Races && PressAnyKey ;;
		q | Q ) CleanUp ;;
	esac
}

# FIGHT MODE! (secondary loop for fights)
FightTable() {  # Used in FightMode()
    GX_Monster_"$ENEMY"
    printf "%-12.12s\t\tHEALTH: %s\tStrength: %s\tAccuracy: %s\n" "$SHORTNAME" "$CHAR_HEALTH" "$STRENGTH" "$ACCURACY"
    printf "%-12.12s\t\tHEALTH: %s\tStrength: %s\tAccuracy: %s\n\n" "$ENEMY_NAME" "$EN_HEALTH" "$EN_STRENGTH" "$EN_ACCURACY"
}   # Return to FightMode()


EchoFightFormula() { # Display Formula in Fighting. Used in FightMode()
    # req.: dice-size | formula | skill-abbrevation
    local DICE_SIZE="$1"
    local FORMULA="$2"
    local SKILLABBREV="$3"

    (( DICE_SIZE <= 9 )) && DICE_SIZE+=" "

    case "$FORMULA" in
	eq )    FORMULA="= " ;;
	gt )    FORMULA="> " ;;
	lt )    FORMULA="< " ;;
	ge )    FORMULA=">=" ;;
	le )    FORMULA="<=" ;;
	times ) FORMULA="x " ;;
    esac

    # skill & roll
    echo -n "Roll D${DICE_SIZE} $FORMULA $SKILLABBREV ( "
    # The actual symbol in $DICE vs eg $CHAR_ACCURACY is already
    # determined in the if and cases of the Fight Loop, so don't repeat here.
}

FightMode() {	  # FIGHT MODE! (secondary loop for fights)
                  # Used in NewSector() and Rest()
    LUCK=0        # Used to assess the match in terms of EXP..
    FIGHTMODE=1	  # Anti-cheat bugfix for CleanUp: Adds penalty for CTRL+C during fights!
    PICKPOCKET=0  # Flag for succesful pickpocket

    RollDice 20 # Determine enemy type
    case "$SCENARIO" in
	H ) ((DICE <= 2)) && ENEMY="chthulu" || ENEMY="dragon" ;; 
            # 1-7 (7/20)                         # 8-10 (3/20)                       # 17-20 (4/20)                      # 11-16 (6/20)
	x ) ((DICE <= 7 )) && ENEMY="orc"     || ((DICE <= 10)) && ENEMY="goblin" || ((DICE >= 17)) && ENEMY="dragon" || ENEMY="varg"   ;;
	. ) ((DICE <= 12)) && ENEMY="goblin"  || ((DICE >= 15)) && ENEMY="bandit" || ENEMY="boar"   ;; # boar   13-15 (2/20)
	T ) ((DICE <= 11)) && ENEMY="bandit"  || ((DICE >= 14)) && ENEMY="mage"   || ENEMY="dragon" ;; # dragon 12-13 (2/20)
	    # 1-6 (6/20)                         # 7-10 (4/20)                       # 19-20 (2/20)                      # 11-18 (8/20)
	@ ) ((DICE <=  6)) && ENEMY="goblin"  || ((DICE <= 10)) && ENEMY="boar"   || ((DICE >= 19)) && ENEMY="orc"    || ENEMY="bandit" ;;
	C ) ((DICE ==  1)) && ENEMY="chthulu" || ((DICE >= 7))  && ENEMY="mage"   || ENEMY="dragon" ;; # dragon 2-6 (5/20)
    esac

    # ENEMY ATTRIBUTES
    # EN_FLEE_THRESHOLD - At what Health will enemy flee? :)
    # PL_FLEE_EXP       - Exp player get if he manage to flee from enemy
    # EN_FLEE_EXP       - Exp player get if enemy manage to flee from him
    # EN_DEFEATED_EXP   - Exp player get if he manage to kill the enemy

    case "$ENEMY" in
	# orig: str=2, acc=4
	bandit )  EN_STRENGTH=1 ; EN_ACCURACY=4 ; EN_FLEE=7 ; EN_HEALTH=30  ; EN_FLEE_THRESHOLD=18 ; PL_FLEE_EXP=5   ; EN_FLEE_EXP=10  ; EN_DEFEATED_EXP=20   ;; 
	# orig: str=3, acc=3
	goblin )  EN_STRENGTH=3 ; EN_ACCURACY=3 ; EN_FLEE=5 ; EN_HEALTH=30  ; EN_FLEE_THRESHOLD=15 ; PL_FLEE_EXP=10  ; EN_FLEE_EXP=15  ; EN_DEFEATED_EXP=30   ;; 
	boar )    EN_STRENGTH=5 ; EN_ACCURACY=2 ; EN_FLEE=4 ; EN_HEALTH=60  ; EN_FLEE_THRESHOLD=35 ; PL_FLEE_EXP=5   ; EN_FLEE_EXP=20  ; EN_DEFEATED_EXP=40   ;;
	orc )     EN_STRENGTH=4 ; EN_ACCURACY=4 ; EN_FLEE=4 ; EN_HEALTH=80  ; EN_FLEE_THRESHOLD=40 ; PL_FLEE_EXP=15  ; EN_FLEE_EXP=25  ; EN_DEFEATED_EXP=50   ;; 
	varg )    EN_STRENGTH=4 ; EN_ACCURACY=3 ; EN_FLEE=3 ; EN_HEALTH=80  ; EN_FLEE_THRESHOLD=60 ; PL_FLEE_EXP=25  ; EN_FLEE_EXP=50  ; EN_DEFEATED_EXP=100  ;;
	mage )    EN_STRENGTH=5 ; EN_ACCURACY=3 ; EN_FLEE=4 ; EN_HEALTH=90  ; EN_FLEE_THRESHOLD=45 ; PL_FLEE_EXP=35  ; EN_FLEE_EXP=75  ; EN_DEFEATED_EXP=150  ;;
	dragon )  EN_STRENGTH=4 ; EN_ACCURACY=4 ; EN_FLEE=2 ; EN_HEALTH=100 ; EN_FLEE_THRESHOLD=50 ; PL_FLEE_EXP=45  ; EN_FLEE_EXP=90  ; EN_DEFEATED_EXP=180  ;;
	chthulu ) EN_STRENGTH=6 ; EN_ACCURACY=5 ; EN_FLEE=1 ; EN_HEALTH=500 ; EN_FLEE_THRESHOLD=35 ; PL_FLEE_EXP=200 ; EN_FLEE_EXP=500 ; EN_DEFEATED_EXP=1000 ;;
    esac
    
    # Capitalize enemy to Enemy, used in FightTable()
    ENEMY_NAME=$(awk '{ print substr(toupper($0), 1,1) substr($0, 2); }' <<< "$ENEMY") 
    
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
    esac

    # Loot: Determine loot type and size 
    RollDice 100
    (( DICE <= EN_GOLD    )) && RollDice 10 && EN_GOLD=$( bc <<< "scale=2; $DICE * ($EN_GOLD / 100)" ) || EN_GOLD=0
    RollDice 100
    (( DICE <= EN_TOBACCO )) && RollDice 10 && EN_TOBACCO=$( bc <<< "scale=2; $DICE * (EN_TOBACCO / 100)" ) || EN_TOBACCO=0
    RollDice 100
    if (( DICE <= EN_FOOD )) ; then # Loot: Food table for animal creatures
	RollDice 10
	case "$ENEMY" in
	    boar )    EN_FOOD=$( bc <<< "scale=2; $DICE * 0.5" )  ;; # max 20 days, min 2 days   (has the most eatable foodstuff)
	    varg )    EN_FOOD=$( bc <<< "scale=2; $DICE * 0.13" ) ;; # max  5 days, min 0.5 day  (tough, sinewy meat and less eatable)
	    chthulu ) EN_FOOD=$DICE                               ;; # max 40 days, min 4 days   (is huge..)
	    dragon )  EN_FOOD=$( bc <<< "scale=2; $DICE * 0.25" ) ;; # max 10 days, min 1 day    (doesn't taste good, but works)
	esac
    fi # IDEA: Boars might have tusks, dragon teeth and varg pelts (skin) you can sell at the market. (3.0)

    # Adjustments for items
    (( CHAR_ITEMS >= 5 )) && (( ACCURACY++ )) # item4: Quick Rabbit Reaction
    (( CHAR_ITEMS >= 6 )) && (( EN_FLEE++ ))  # item5: Flask of Terrible Odour

    GX_Monster_$ENEMY
    sleep 1 # Pause to admire monster :) # TODO playtest, not sure if this is helping..

    # DETERMINE INITIATIVE (will usually be enemy)
    if (( EN_ACCURACY > ACCURACY )) || (( PLAYER_RESTING == 1 )) ; then
	(( PLAYER_RESTING == 1 )) && echo "Suddenly you was attacked by the $ENEMY " || echo "The $ENEMY has initiative"
	NEXT_TURN="en"
    else
	echo -e "$CHAR has the initiative!\n"
	# Sigge do we need add check for rest - if player was attacked during the rest he can flee,
	# but if he was attaced during the rest - will he try to pickpocket enemy ? #kstn
	# YES, this makes sense. We can't "benefit" from night attacks, except if we win battle:) -sig
	read -sn 1 -p "          Press (F) to Flee (P) to Pickpocket or (A)ny key to fight" FLEE_OPT
	case "$FLEE_OPT" in
	    f | F ) # flee
		GX_Monster_$ENEMY # FightTable # Cosmetic fix # What about this? #kstn
		echo -e "\nTrying to slip away unseen.. (Flee: $FLEE)"
		RollDice 6
		(( DICE <= FLEE )) && { 
		    echo "You rolled $DICE and managed to run away!";
		    LUCK=3;
		    unset FIGHTMODE; } || {
		    echo "You rolled $DICE and lost your initiative.." ;
		    NEXT_TURN="en" ;  } ;;
	    p | P ) # Pickpocket
		GX_Monster_$ENEMY # FightTable # Cosmetic fix # What about this? #kstn
		RollDice 6
		if (( DICE <= ACCURACY )) ; then
		    RollDice 6
		    if (( DICE >= EN_ACCURACY )) ; then # "steal success" take loot
			echo -en "\nYou successfully stole the ${ENEMY}'s pouch, "
			case $(bc <<< "($EN_GOLD + $EN_TOBACCO) > 0") in # bc return 1 if true, 0 if false
			    0 ) echo -e "but it feels rather light..\n" ;;
			    1 ) echo -e "and it feels heavy!\n"; PICKPOCKET=1 ;;
			esac
			# Fight or flee 2nd round (player doesn't lose initiative if he'll fight after pickpocketing)
			read -sn 1 -p "                  Press (F) to Flee or (A)ny key to fight" FLEE_OPT
			case "$FLEE_OPT" in
			    f | F) # Player tries to flee after successful pickpocketing
				if (( 2 > 1 )); then # DEBUG: during testing flee always succeed!
				    LUCK=3;
				    unset FIGHTMODE;
				else
				    echo "flee fall"
				    NEXT_TURN="en"
				fi
				;;
			    *) NEXT_TURN="pl" ;; # fight				
			esac
		    else
			echo "You were unable to pickpocket from the ${ENEMY}!"
			NEXT_TURN="en"
		    fi
		else
		    echo "You were unable to pickpocket from the ${ENEMY}!"
		    NEXT_TURN="en"
		fi
		;;
	    * ) NEXT_TURN="pl" ;; # fight
	esac
    fi

    sleep 1

    (( CHAR_ITEMS >= 5 )) && (( ACCURACY--)) # Reset Quick Rabbit Reaction (ACCURACY) before fighting.. # I was wrong about bug here :( #kstn

    # GAME LOOP: FIGHT LOOP
    while (( FIGHTMODE > 0 )) # If player didn't manage to run
    do
	if (( CHAR_HEALTH <= 0 )); then # If player is dead
	    echo "Your health points are $CHAR_HEALTH" && sleep 2
	    echo "You WERE KILLED by the $ENEMY, and now you are dead..." && sleep 2
	    if (( CHAR_EXP >= 1000 )) && (( CHAR_HEALTH > -15 )); then
		echo "However, your $CHAR_EXP Experience Points relates that you have"
		echo "learned many wondrous and magical things in your travels..!"
		echo "+20 HEALTH: Health restored by 20 points (HEALTH: $CHAR_HEALTH)"
		(( CHAR_HEALTH += 20 ))
		LUCK=2
		sleep 8
	    elif (( CHAR_ITEMS >= 3 )) && (( CHAR_HEALTH > -5 )); then
		echo "Suddenly you awake again, SAVED by your Guardian Angel!"
		echo "+5 HEALTH: Health restored by 5 points (HEALTH: $CHAR_HEALTH)"
		(( CHAR_HEALTH += 5 ))
		LUCK=2
		sleep 8
	    else # DEATH!
		echo "Gain 1000 Experience Points to achieve magic healing!"
		sleep 4		
		GX_Death
		# echo " The $TODAYS_DATE_STR:"
		echo " The $BIAMIN_DATE_STR:"
		echo " In such a short life, this sorry $CHAR_RACE_STR gained $CHAR_EXP Experience Points."
		local COUNTDOWN=20
		while (( COUNTDOWN > 0 )); do
		    echo -en "${CLEAR_LINE} We honor $CHAR with $COUNTDOWN secs silence." 
    		    read -sn 1 -t 1 && COUNTDOWN=-1 || ((COUNTDOWN--))
		done
		unset COUNTDOWN
		#echo "$CHAR_EXP;$CHAR;$CHAR_RACE;$CHAR_BATTLES;$CHAR_KILLS;$CHAR_ITEMS;$TODAYS_DATE;$TODAYS_MONTH;$TODAYS_YEAR" >> "$HIGHSCORE"
		echo "$CHAR_EXP;$CHAR;$CHAR_RACE;$CHAR_BATTLES;$CHAR_KILLS;$CHAR_ITEMS;$DAY;$MONTH;$YEAR" >> "$HIGHSCORE"
		rm -f "$CHARSHEET" # A sense of loss is important for gameplay:)
		unset CHARSHEET CHAR CHAR_RACE CHAR_HEALTH CHAR_EXP CHAR_GPS SCENARIO CHAR_BATTLES CHAR_KILLS CHAR_ITEMS # Zombie fix
		DEATH=1 
	    fi
	    unset FIGHTMODE # At any case finally dead or resurrected player can't countinue fight
	    break	    # Exit fight loop
	fi

	FightTable

	if [[ "$NEXT_TURN" == "pl" ]] ; then  # Player's turn
	    read -sn 1 -p "It's your turn, press any key to (R)oll or (F) to Flee" "FIGHT_PROMPT"
	    RollDice 6
	    FightTable
	    echo -n "ROLL D6: $DICE"
	    case "$FIGHT_PROMPT" in
		f | F ) # Player tries to flee!
		    RollDice 6
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
			    sleep 1
			else # Player managed to flee
			    echo -n "$DICE > $EN_ACCURACY ) You managed to flee!"
			    unset FIGHTMODE
			    LUCK=3
			    break
			fi
		    else
			echo -n "$DICE > $FLEE ) Your escape was unsuccessful!"
		    fi
		    ;;
		*)  # Player fights
		    unset FIGHT_PROMPT
		    if (( DICE <= ACCURACY )); then
			echo -e "\tAccuracy [D6 $DICE < $ACCURACY] Your weapon hits the target!"
			read -sn 1 -p "Press the R key to (R)oll for damage" "FIGHT_PROMPT"
			RollDice 6
			echo -en "\nROLL D6: $DICE"
			DAMAGE=$(( DICE * STRENGTH ))
			echo -en "\tYour blow dishes out $DAMAGE damage points!"
			EN_HEALTH=$(( EN_HEALTH - DAMAGE ))
			sleep 3 # Important sleep here! It allows you to watch the enemy's health go from + to - :D
			(( EN_HEALTH <= 0 )) && unset FIGHTMODE && break 
		    else
			echo -e "\tAccuracy [D6 $DICE > $ACCURACY] You missed!"
			sleep 2
		    fi		    
	    esac
	    NEXT_TURN="en"
	else # Enemy's turn
	    FightTable
	    if (( EN_HEALTH < EN_FLEE_THRESHOLD )) && (( EN_HEALTH < CHAR_HEALTH )); then # Enemy tries to flee
		RollDice 20
		echo -e "Rolling for enemy flee: D20 < $EN_FLEE"
		sleep 2
		if (( DICE < EN_FLEE )); then
		    echo -e "ROLL D20: ${DICE}\tThe $ENEMY uses an opportunity to flee!"
		    LUCK=1
		    unset FIGHTMODE
		    sleep 2
		    break # bugfix: Fled enemy continue fighting..
		fi		
		FightTable # If enemy didn't manage to run
	    fi

	    echo "It's the ${ENEMY}'s turn"
	    sleep 2
	    RollDice 6
	    if (( DICE <= EN_ACCURACY )); then
		echo "Accuracy [D6 $DICE < $EN_ACCURACY] The $ENEMY strikes you!"
		RollDice 6
		DAMAGE=$(( DICE * EN_STRENGTH ))
		echo "-$DAMAGE HEALTH: The $ENEMY's blow hits you with $DAMAGE points!"
		CHAR_HEALTH=$(( CHAR_HEALTH - DAMAGE ))
		SaveCurrentSheet
	    else
		echo "Accuracy [D6 $DICE > $EN_ACCURACY] The $ENEMY misses!"
	    fi
	    NEXT_TURN="pl"
	    sleep 2
	fi
    done
    # FIGHT LOOP ends

    # After the figthing 
    if (( DEATH != 1 )) ; then   # VICTORY!
	GX_Monster_$ENEMY
	case "$LUCK" in
	    1)  # ENEMY managed to FLEE
		echo -e "\nYou defeated the $ENEMY and gained $EN_FLEE_EXP Experience Points!" 
		(( CHAR_EXP += EN_FLEE_EXP )) ;;
	    2)  # died but saved by guardian angel or 1000 EXP
		echo -e "\nWhen you come to, the $ENEMY has left the area ..." ;;
	    3)  # PLAYER managed to FLEE during fight!
		echo -e "\nYou got away while the $ENEMY wasn't looking, gaining $PL_FLEE_EXP Experience Points!"
		(( CHAR_EXP += PL_FLEE_EXP )) ;;
	    *)  # ENEMY was slain!
		echo -e "\nYou defeated the $ENEMY and gained $EN_DEFEATED_EXP Experience Points!\n" 
		(( CHAR_EXP += EN_DEFEATED_EXP ))
		(( CHAR_KILLS++ ))
		if (( PICKPOCKET != 1 )); then # Check for loot 
		    echo -n "Searching the dead ${ENEMY}'s corpse, you find "
		    if (( $(bc <<< "($EN_GOLD + $EN_TOBACCO) == 0") )) ; then
			echo "mostly just lint .."
		    else
			(( $(bc <<< "$EN_GOLD > 0") )) && CHAR_GOLD=$( bc <<< "$CHAR_GOLD + $EN_GOLD" ) || EN_GOLD="no"
			(( $(bc <<< "$EN_TOBACCO > 0") )) && CHAR_TOBACCO=$( bc <<< "$CHAR_TOBACCO + $EN_TOBACCO" ) || EN_TOBACCO="no"
			echo "$EN_GOLD gold and $EN_TOBACCO tobacco"			
		    fi
		fi
		(( $(bc <<< "$EN_FOOD > 0") )) && echo "You scavenge $EN_FOOD food from the ${ENEMY}'s body" && CHAR_FOOD=$(bc <<< "$CHAR_FOOD + $EN_FOOD")
	esac

	if (( PICKPOCKET > 0 )); then # check for stealing
	    echo -n "In the pouch lifted from the ${ENEMY}, you find $EN_GOLD gold and $EN_TOBACCO tobacco"
	    CHAR_GOLD=$( bc <<< "$CHAR_GOLD + $EN_GOLD" )
	    CHAR_TOBACCO=$( bc <<< "$CHAR_TOBACCO + $EN_TOBACCO" )
	    case "$ENEMY" in
		orc ) echo "$CHAR gained $EN_PICKPOCKET_EXP Experience Points for successfully pickpocketing an $ENEMY!" ;;
		*   ) echo "$CHAR gained $EN_PICKPOCKET_EXP Experience Points for successfully pickpocketing a $ENEMY!" ;;
	    esac
	    (( CHAR_EXP += EN_PICKPOCKET_EXP ))
	    sleep 2
	fi

	(( CHAR_BATTLES++ ))
	SaveCurrentSheet
	sleep 4
	DisplayCharsheet
    fi    
}   # END FightMode. Return to NewSector() or to Rest()


# GAME ACTION: REST
RollForHealing() { # Used in Rest()
    RollDice 6
    echo -e "Rolling for healing: D6 <= $HEALING\nROLL D6: $DICE"
    (( DICE > HEALING )) && echo "$2" || ( (( CHAR_HEALTH += $1 )) && echo "You slept well and gained $1 Health." )
    ((TURN++))
    sleep 2
}   # Return to Rest()

# GAME ACTION: REST
# Game balancing can also be done here, if you think players receive too much/little health by resting.
Rest() {  # Used in NewSector()
    PLAYER_RESTING=1 # Set flag for FightMode()
    RollDice 100
    GX_Rest
    case "$SCENARIO" in
	H ) if (( CHAR_HEALTH < 100 )); then
		CHAR_HEALTH=100
		echo "You slept well in your own bed. Health restored to 100."
	    else
		echo "You slept well in your own bed, and woke up to a beautiful day."
	    fi
	    ((TURN++))
	    sleep 2
	    ;;
	x ) RollForEvent 60 "fight" && FightMode || RollForHealing 5  "The terrors of the mountains kept you awake all night.." ;;
	. ) RollForEvent 30 "fight" && FightMode || RollForHealing 10 "The dangers of the roads gave you little sleep if any.." ;;
	T ) RollForEvent 15 "fight" && FightMode || RollForHealing 15 "The vices of town life kept you up all night.." ;;
	@ ) RollForEvent 35 "fight" && FightMode || RollForHealing 5  "Possibly dangerous wood owls kept you awake all night.." ;;
	C ) RollForEvent 5  "fight" && FightMode || RollForHealing 35 "Rowdy castle soldiers on a drinking binge kept you awake.." ;;
    esac
    unset PLAYER_RESTING # Reset flag
    sleep 2
}   # Return to NewSector()

# THE GAME LOOP

RollForEvent() { # Used in NewSector() and Rest()
    # $1 - dice size, $2 - event
    echo -e "Rolling for $2: D${DICE_SIZE} <= $1\nD${DICE_SIZE}: $DICE" 
    sleep 2
    (( DICE <= $1 )) && return 0 || return 1
}   # Return to NewSector() or Rest()

GX_Place() {     # Used in NewSector() and MapNav()
    # Display scenario GFX and define place name for MapNav() and DisplayCharsheet()
    case "$1" in
	H ) GX_Home      ; PLACE="Home" ;;
	x ) GX_Mountains ; PLACE="Mountain" ;;
	. ) GX_Road      ; PLACE="Road" ;;
	T ) GX_Town      ; PLACE="Town" ;;
	@ ) GX_Forest    ; PLACE="Forest" ;;
	C ) GX_Castle    ; PLACE="Oldburg Castle" ;;
	Z | * ) CustomMapError;;
    esac
}   # Return to NewSector() or MapNav()

CheckForDeath() { # Used in NewSector()
    (( DEATH == 1 )) && unset DEATH && HighScore && return 0
}

MiniGame_Dice() { # Small dice based minigame used in Tavern()
	echo -en "${CLEAR_LINE}"

	# How many players currently at the table
	DGAME_PLAYERS=$((RANDOM%6)) # 0-5 players
	(( DGAME_PLAYERS == 0 )) && read -sn1 -p "There's no one at the table. May be you should come back later?" && return 0  # leave
	# Determine stake size
	RollDice 6
	DGAME_STAKES=$( bc <<< "$DICE * $VAL_CHANGE" ) # min 0.25, max 1.5
	# Check if player can afford it
	if (( $(bc <<< "$CHAR_GOLD <= $DGAME_STAKES") )); then
	    read -sn1 -p "No one plays with a poor, Goldless $CHAR_RACE_STR! Come back when you've got it.." 
	    return 0 # leave
	fi

	GX_DiceGame_Table
	case "$DGAME_PLAYERS" in # Ask whether player wants to join
	    1 ) read -sn1 -p "There's a gambler wanting to roll dice for $DGAME_STAKES Gold a piece. Want to [J]oin?" JOIN_DICE_GAME ;;
	    * ) read -sn1 -p "There are $DGAME_PLAYERS players rolling dice for $DGAME_STAKES Gold a piece. Want to [J]oin?" JOIN_DICE_GAME	    
	esac
	case "$JOIN_DICE_GAME" in
	    j | J | y | Y ) ;; # Game on! Do nothing.
	    * ) echo -e "\nToo high stakes for you, $CHAR_RACE_STR?" ; sleep 2; return 0;; # Leave.
	esac

	GAME_ROUND=1
	CHAR_GOLD=$(bc <<< "$CHAR_GOLD - $DGAME_STAKES" )
	echo -e "\nYou put down $DGAME_STAKES Gold and pull out a chair .. [ -$DGAME_STAKES Gold ]" && sleep 3
	
	# Determine starting pot size
	DGAME_POT=$( bc <<< "$DGAME_STAKES * ( $DGAME_PLAYERS + 1 )" )
	
	# DICE GAME LOOP
	while ( true ) ; do
	    GX_DiceGame_Table
	    if (( $(bc <<< "$CHAR_GOLD < $DGAME_STAKES") )) ; then # Check if we've still got gold for 1 stake...
		echo "You're out of gold, $CHAR_RACE_STR. Come back when you have some more!"
		break # if not, leave immediately		
	    fi		
	    read -p "Round $GAME_ROUND. The pot's $DGAME_POT Gold. Bet (2-12), (I)nstructions or (L)eave Table: " DGAME_GUESS
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

	    # Determine if we're sharing the bet based on odds percentage.. # TODO. Do these calculations just once/round!
	    case $DGAME_GUESS in # DGAME_COMP
		2 | 12 ) DGAME_COMP=3 ;;  # 1/36 = 03 %
		3 | 11 ) DGAME_COMP=6 ;;  # 2/36 = 06 % 
		4 | 10 ) DGAME_COMP=9 ;;  # 3/36 = 09 %
		5 | 9  ) DGAME_COMP=12 ;; # 4/36 = 12 %
		6 | 8  ) DGAME_COMP=14 ;; # 5/36 = 14 %
		7      ) DGAME_COMP=17 ;; # 1/6  = 17 % == 61 %
	    esac
	    
	    # Run that through a loop of players num and % dice..
	    DGAME_PLAYERS_COUNTER=$DGAME_PLAYERS
	    DGAME_COMPETITION=0
	    while (( DGAME_PLAYERS_COUNTER >= 1 )) ; do
		RollDice 100
		(( DICE <= DGAME_COMP )) && (( DGAME_COMPETITION++ )) # Sharing!
		(( DGAME_PLAYERS_COUNTER-- ))
	    done
	    
	    # Roll the dice (pray for good luck!)
	    echo -n "Rolling for $DGAME_GUESS ($DGAME_COMP% odds).. " && sleep 1
	    case "$DGAME_COMPETITION" in
		0 ) echo "No one else playing for $DGAME_GUESS!" ;;
		1 ) echo "Sharing bet with another player!" ;;	    
		* ) echo "Sharing bet with $DGAME_COMPETITION other players!"		    
	    esac
	    sleep 1
	    
	    RollDice 6 && DGAME_DICE_1=$DICE && RollDice 6 && DGAME_DICE_2=$DICE
	    DGAME_RESULT=$( bc <<< "$DGAME_DICE_1 + $DGAME_DICE_2" )
	    # IDEA: If we later add an item or charm for LUCK, add adjustments here.
	    
	    GX_DiceGame "$DGAME_DICE_1" "$DGAME_DICE_2" # Display roll result graphically
	    
	    # Calculate % of POT (initial DGAME_WINNINGS) to be paid out given DGAME_RESULT (odds)
	    case "$DGAME_RESULT" in
	    2 | 12 ) DGAME_WINNINGS=$DGAME_POT ;;		       # 100%  # TODO
	    3 | 11 ) DGAME_WINNINGS=$( bc <<< "$DGAME_POT * 0.85" ) ;; # 85%   # PLAY TEST THESE %s
	    4 | 10 ) DGAME_WINNINGS=$( bc <<< "$DGAME_POT * 0.70" ) ;; # 70%
	    5 | 9  ) DGAME_WINNINGS=$( bc <<< "$DGAME_POT * 0.55" ) ;; # 55%
	    6 | 8  ) DGAME_WINNINGS=$( bc <<< "$DGAME_POT * 0.40" ) ;; # 40%
	    7      ) DGAME_WINNINGS=$( bc <<< "$DGAME_POT * 0.25" ) ;; # 25%
	    esac
	    
	    if (( DGAME_GUESS == DGAME_RESULT )) ; then # You won
   		DGAME_POT=$( bc <<< "$DGAME_POT - $DGAME_WINNINGS" )  # Adjust winnings to odds
		DGAME_WINNINGS=$( bc <<< "$DGAME_WINNINGS / ( $DGAME_COMPETITION + 1 )" ) # no competition = winnings/1
		echo "You rolled $DGAME_RESULT and won $DGAME_WINNINGS Gold! [ +$DGAME_WINNINGS Gold ]"
		CHAR_GOLD=$( bc <<< "$CHAR_GOLD + $DGAME_WINNINGS" )
		sleep 3
	    else # You didn't win
		echo -n "You rolled $DGAME_RESULT and lost.. "
		
		# Check if other player(s) won the pot
		DGAME_COMPETITION=$( bc <<< "$DGAME_PLAYERS - $DGAME_COMPETITION" )
		DGAME_OTHER_WINNERS=0
		
		# Chances of any player picking the resulting number
		case "$DGAME_RESULT" in
		    2 | 12 ) DGAME_COMP=3 ;;  # 1/36 = 03 %
		    3 | 11 ) DGAME_COMP=6 ;;  # 2/36 = 06 % 
		    4 | 10 ) DGAME_COMP=9 ;;  # 3/36 = 09 %
		    5 | 9  ) DGAME_COMP=12 ;; # 4/36 = 12 %
		    6 | 8  ) DGAME_COMP=14 ;; # 5/36 = 14 %
		    7      ) DGAME_COMP=17 ;; # 1/6  = 17 % == 61 %
		esac
		
		while (( DGAME_COMPETITION >= 1 )) ; do
		    RollDice 100
		    (( DICE <= DGAME_COMP )) && (( DGAME_OTHER_WINNERS++ )) # +1 more winner
		    (( DGAME_COMPETITION-- ))
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
	done
	sleep 3 # After 'break' in while-loop
	SaveCurrentSheet
}

Tavern() { # Used in GoIntoTown()
    while (true); do
	GX_Tavern # Tavern gained +30 HEALTH - Town*2
	read -sn1 -p "     (R)ent a room and rest safely     (P)lay dice     (A)ny key to Exit" VAR
	case "$VAR" in
	    r | R) 
		GX_Tavern
		read -sn1 -p "      rent for 1 (G)old      rent for 1 (T)obacco      (A)ny key to Exit" CUR
		case "$CUR" in
		    g | G ) 
			if (( $(bc <<< "$CHAR_GOLD == 0") )); then # check for money
			    echo "You don't have enough Gold to rent a room in the Tavern"
			else
			    GX_Rest
			    CHAR_GOLD=$(bc <<< "$CHAR_GOLD - 1")
			    echo -n "You got some much needed rest .."
			    if (( CHAR_HEALTH < 150 )); then
				(( CHAR_HEALTH += 30 ))
				(( CHAR_HEALTH > 150 )) && CHAR_HEALTH=150
				echo " and your HEALTH is $CHAR_HEALTH now"
			    fi
			    ((TURN++))
			fi
			;;
		    t | T )
			if (( $(bc <<< "$CHAR_TOBACCO == 0") )); then # check for money
			    echo "You don't have enough Tobacco to rent a room in the Tavern"
			else
			    GX_Rest
			    CHAR_TOBACCO=$(bc <<< "$CHAR_TOBACCO - 1")
			    echo -n "You got some much needed rest .."
			    if (( CHAR_HEALTH < 150 )); then
				(( CHAR_HEALTH += 30 ))
				(( CHAR_HEALTH > 150 )) && CHAR_HEALTH=150
				echo " and your HEALTH is $CHAR_HEALTH now"
			    fi
			    ((TURN++))
			fi
			;;
		esac 
		read -n 1;; # DEBUG replace to sleep 
 	    p | P ) MiniGame_Dice ;;
	    * ) break ;; # Leave tavern
	esac
    done
} # Return to GoIntoTown()

Marketplace() { # Used in GoIntoTown()
    # The PRICE of a unit (food, ale) is always 1.
    while (true); do
	GX_Marketplace
	read -sn 1 -p "           (G)rocer          (M)erchant          (L)eave Marketplace" VAR
	case "$VAR" in
	    g | G) Marketplace_Grocer;; # Trade FOOD for GOLD and TOBACCO
	    m | M) Marketplace_Merchant;; # Trade TOBACCO <-> GOLD ??? Or what?? #kstn
	    # Smbd who'll trade boars' tusks etc for GOLD/TOBACCO ???
	    *) break ;; # Leave marketplace
	esac
    done
    # IDEA? Add stealing from market??? 
    # Good idea, but we'd have to arrange a fight and new enemy type (shopkeep)..
    # Or he call the police (the guards?) and they throw player from town? (kstn)
} # Return to GoIntoTown()

Marketplace_Merchant(){
    GX_Marketplace_Merchant
    read -sn 1
}

Marketplace_Grocer() { # Used in GoIntoTown()
    # The PRICE of a unit (food, ale) is always 1.
    # Determine prices for 1 unit depending on currencies' respective values
    PRICE_IN_GOLD=$( bc <<< "scale=2; 1/$VAL_GOLD" )
    PRICE_IN_TOBACCO=$( bc <<< "scale=2; 1/$VAL_TOBACCO" )		
    while (true); do
	GX_Marketplace_Grocer
	echo "Welcome to my shoppe, stranger! We have the right prices for you .." # Will be in GX_..
	echo "1 FOOD costs $PRICE_IN_GOLD Gold or $PRICE_IN_TOBACCO Tobacco" # Will perhaps add pricing in GX_!
	echo -e "You currently have $CHAR_GOLD Gold, $CHAR_TOBACCO Tobacco and $CHAR_FOOD Food in your inventory\n"
	read -sn1 -p "       Trade for (G)old        Trade for (T)obacco       (N)ot interested" MARKETVAR
	case "$MARKETVAR" in
	    g | G )
		GX_Marketplace_Grocer
		read -p "How many food items do you want to buy? " QUANTITY
		# TODO check for QUANTITY - if falls if QUANTITY != [0-9]+
		local COST=$( bc <<< "$PRICE_IN_GOLD * $QUANTITY" )
		if (( $(bc <<< "$CHAR_GOLD > $COST") )); then
		    CHAR_GOLD=$(bc <<< "$CHAR_GOLD - $COST")
		    CHAR_FOOD=$(bc <<< "${CHAR_FOOD} + ${QUANTITY}")
		    echo "You bought $QUANTITY food for $COST Gold, and you have $CHAR_FOOD Food in your inventory"
		else
		    echo "You don't have enough Gold to buy $QUANTITY food yet. Try a little less!"
		fi
		read -n 1		
		;;
	    t | T )
		GX_Marketplace_Grocer
		read -p "How much food you want to buy? " QUANTITY
		# TODO check for QUANTITY - if falls if QUANTITY != [0-9]+
		local COST=$( bc <<< "${PRICE_IN_TOBACCO} * $QUANTITY" )
		if (( $(bc <<< "$CHAR_TOBACCO > $COST") )); then
		    CHAR_TOBACCO=$(bc <<< "$CHAR_TOBACCO - $COST")
		    CHAR_FOOD=$(bc <<< "${CHAR_FOOD} + ${QUANTITY}")
		    echo "You traded $COST Tobacco for $QUANTITY food, and have $CHAR_FOOD Food in your inventory"
		else
		    echo "You don't have enough Tobacco to trade for $QUANTITY food yet. Try a little less!"
		fi
		read -n 1		
		;;
	    *) break;
	esac
    done
    unset PRICE_IN_GOLD PRICE_IN_TOBACCO
    # TODO? Add stealing from market??? 
    # Good idea, but we'd have to arrange a fight and new enemy type (shopkeep)..
    # Or he call the police (the guards?) and they throw player from town? (kstn)
} # Return to GoIntoTown()


# Marketplace() { # Used in GoIntoTown()
#     # The PRICE of a unit (food, ale) is always 1.
#     while (true); do
# 	GX_Marketplace
# 	# Determine prices for 1 unit depending on currencies' respective values
# 	local PRICE_IN_GOLD=$( bc <<< "scale=2; 1/$VAL_GOLD" )
# 	local PRICE_IN_TOBACCO=$( bc <<< "scale=2; 1/$VAL_TOBACCO" )		
# 	echo "Welcome to my shoppe, stranger! We have the right prices for you .." # Will be in GX_..
# 	echo "1 FOOD costs $PRICE_IN_GOLD Gold or $PRICE_IN_TOBACCO Tobacco" # Will perhaps add pricing in GX_!
# 	echo -e "You currently have $CHAR_GOLD Gold, $CHAR_TOBACCO Tobacco and $CHAR_FOOD Food in your inventory\n"
# 	read -sn1 -p "       Trade for (G)old        Trade for (T)obacco       (N)ot interested" MARKETVAR
# 	case "$MARKETVAR" in
# 	    g | G )
# 		GX_Marketplace
# 		read -p "How many food items do you want to buy? " QUANTITY
# 		# TODO check for QUANTITY - if falls if QUANTITY != [0-9]+
# 		local COST=$( bc <<< "$PRICE_IN_GOLD * $QUANTITY" )
# 		if (( $(bc <<< "$CHAR_GOLD > $COST") )); then
# 		    CHAR_GOLD=$(bc <<< "$CHAR_GOLD - $COST")
# 		    CHAR_FOOD=$(bc <<< "${CHAR_FOOD} + ${QUANTITY}")
# 		    echo "You bought $QUANTITY food for $COST Gold, and you have $CHAR_FOOD Food in your inventory"
# 		else
# 		    echo "You don't have enough Gold to buy $QUANTITY food yet. Try a little less!"
# 		fi
# 		read -n 1		
# 		;;
# 	    t | T )
# 		GX_Marketplace
# 		read -p "How much food you want to buy? " QUANTITY
# 		# TODO check for QUANTITY - if falls if QUANTITY != [0-9]+
# 		local COST=$( bc <<< "${PRICE_IN_TOBACCO} * $QUANTITY" )
# 		if (( $(bc <<< "$CHAR_TOBACCO > $COST") )); then
# 		    CHAR_TOBACCO=$(bc <<< "$CHAR_TOBACCO - $COST")
# 		    CHAR_FOOD=$(bc <<< "${CHAR_FOOD} + ${QUANTITY}")
# 		    echo "You traded $COST Tobacco for $QUANTITY food, and have $CHAR_FOOD Food in your inventory"
# 		else
# 		    echo "You don't have enough Tobacco to trade for $QUANTITY food yet. Try a little less!"
# 		fi
# 		read -n 1		
# 		;;
# 	    *) break;
# 	esac
#     done
#     # TODO? Add stealing from market??? 
#     # Good idea, but we'd have to arrange a fight and new enemy type (shopkeep)..
#     # Or he call the police (the guards?) and they throw player from town? (kstn)
# } # Return to GoIntoTown()


GoIntoTown() { # Used in NewSector()
    while (true); do
    GX_Place "$SCENARIO" # GX_Town 
        # Add separate GX for this? 
        # What about add separate GX for Town and use current GX_Town() here? #kstn
	echo -n "      (T)avern      (B)ulletin Board      (M)arketplace      (E)xit Town"	
	read -sn 1 ACTION
	case "$ACTION" in
	    t | T ) Tavern ;;
	    m | M ) Marketplace ;;
	    b | B ) GX_Bulletin "$BBSMSG" ;;
	    * ) break ;; # Leave town
	esac
    done
} # Return to NewSector()

# THE GAME LOOP
NewSector() { # Used in Intro()
    while (true) # While (player-is-alive) :) 
    do
	((TURN++)) # Nev turn, new date
	DateFromTurn # Get year, month, day, weekday
	# Find out where we are - Fixes LOCATION in CHAR_GPS "A1" to a place on the MapNav "X1,Y1"
	read -r MAP_X MAP_Y  <<< $(awk '{ print substr($0, 1 ,1); print substr($0, 2); }' <<< "$CHAR_GPS")
	MAP_X=$(awk '{print index("ABCDEFGHIJKLMNOPQR", $0)}' <<< "$MAP_X") # converts {A..R} to {1..18} #kstn
	SCENARIO=$(awk '{ if ( NR == '$((MAP_Y+2))') { print $'$((MAP_X+2))'; }}' <<< "$MAP" ) # MAP_Y+2 MAP_X+2 - padding for borders
	# Look for treasure @ current GPS location  - Checks current section for treasure
	(( CHAR_ITEMS < 8 )) && [[ $(grep -E "(^| )$MAP_X-$MAP_Y( |$)" <<< "${HOTZONE[@]}") ]] && ItemWasFound

	GX_Place "$SCENARIO"	
	if [[ "$NODICE" ]] ; then # Do not attack player at the first turn of after finding item
	    unset NODICE 
	else
	    RollDice 100        # Find out if we're attacked 
	    case "$SCENARIO" in # FightMode() if RollForEvent return 0
		H ) RollForEvent 1  && FightMode ;;
		x ) RollForEvent 50 && FightMode ;;
		. ) RollForEvent 20 && FightMode ;;
		T ) RollForEvent 15 && FightMode ;;
		@ ) RollForEvent 35 && FightMode ;;
		C ) RollForEvent 10 && FightMode ;;
		* ) CustomMapError ;;
	    esac
            (( DEATH == 1 )) && break # If player was slain in fight mode
	    GX_Place "$SCENARIO"
	fi

	# Food check # TODO add it to Rest() after finishing
	# TODO move it to separate function after finishing		
	  # What's your plan? -Sig.
	    # Look, we need check-for-starvation here and in Rest (one code in two places) 
	    # So it seems to me that it should be separate function (like CheckForDeath) #kstn
			# Sounds like a sound logic :) # sigge
	# TODO not check for food at the 1st turn
	# TODO set check to death from starvation
	# TODO Probably due to this temporary placement in code it popped up on the Display Race Info page after a fight.. :P
	# TODO Yes, it pops up sometimes when it's not (for the gamer experienced as) a new sector..?
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
	    # ADD CHECK HERE IF HEALTH <= 0 then "You have starved to death" sleep 2 && death..
	fi
	sleep 2 ### DEBUG

	if (( --WORLDCHANGE_COUNTDOWN <= 0 )); then # --WorldChangeCounter THEN Check for WORLD EVENT: Economy
	    RollDice 100
	    if (( DICE <= 15 )); then 	# 15% chance for economic event transpiring
		RollDice 12  # = Number of possible scenarios (+ default 0)		
		BBSMSG="$DICE" # Update BBSMSG
		
		case "$DICE" in
		    # Econ '+'=Inflation, '-'=deflation | 1=Tobacco, 2=Gold | Severity 12=worst (0.25-3.00 change), 5=lesser (0.25-1.25 change)
		    1 )  WorldChangeEconomy + 1 12 ;; # Wild Fire Threatens Tobacco (serious inflation)
		    2 )  WorldChangeEconomy + 1 5  ;; # Hobbits on Strike (lesser inflation)
		    3 )  WorldChangeEconomy - 1 12 ;; # Tobacco Overproduction (serious deflation)
		    4 )  WorldChangeEconomy - 1 5  ;; # Tobacco Import Increase (lesser deflation)
		    5 )  WorldChangeEconomy + 2 12 ;; # Gold Demand Increases due to War (serious inflation)
		    6 )  WorldChangeEconomy + 2 5  ;; # Gold Required for New Fashion (lesser inflation)
		    7 )  WorldChangeEconomy - 2 12 ;; # New Promising Gold Vein (serious deflation)
		    8 )  WorldChangeEconomy - 2 5  ;; # Discovery of Artificial Gold Prices (lesser deflation)
		    9 )  WorldChangeEconomy - 2 4  ;; # Alchemists promise gold (lesser deflation)
		    10 ) WorldChangeEconomy + 1 4  ;; # Water pipe fashion (lesser inflation)
		    11 ) WorldChangeEconomy + 2 10 ;; # King Bought Tracts of Land (serious inflation)
		    12 ) WorldChangeEconomy - 1 10 ;; # Rumor of Tobacco Pestilence false (serious deflation)
		esac

		SaveCurrentSheet         # Save world changes to charsheet
		WORLDCHANGE_COUNTDOWN=20 # Give the player a 20 turn break TODO Test how this works..
	    fi
	fi

	while (true); do # GAME ACTIONS MENU BAR
	    GX_Place "$SCENARIO"
	    case "$SCENARIO" in # Determine promt
		T | C ) read -sn 1 -p "     (C)haracter    (R)est    (G)o into Town    (M)ap and Travel    (Q)uit" ACTION ;;
		H )     read -sn 1 -p "     (C)haracter     (B)ulletin     (R)est     (M)ap and Travel     (Q)uit" ACTION ;;
		* )     read -sn 1 -p "        (C)haracter        (R)est        (M)ap and Travel        (Q)uit"    ACTION ;;
	    esac

	    case "$ACTION" in
		c | C ) DisplayCharsheet ;;
		r | R ) Rest;                   # Player may be attacked during the rest :)
		    CheckForDeath && break 2 ;; # If player was slain during the rest
		q | Q ) CleanUp ;;              # Leaving the realm of magic behind ....
		b | B ) [[ "$SCENARIO" -eq "H" ]] && GX_Bulletin $BBSMSG ;;
		g | G ) [[ "$SCENARIO" -eq "T" || "$SCENARIO" -eq "C" ]] && GoIntoTown ;;
		m | M ) MapNav; break ;;        # Go to Map then move
		* ) MapNav "$ACTION"; break ;;	# Move directly (if not WASD, then loitering :)
	    esac
	done
	
    done
}	# Return to MainMenu() (if player is dead)

Intro() { # Used in BiaminSetup() . Intro function basically gets the game going
    SHORTNAME=$(awk '{ print substr(toupper($0), 1, 1) substr($0, 2); }' <<< "$CHAR") # Create capitalized FIGHT CHAR name
    TodaysDate	       # Fetch today's date in Warhammer calendar (Used in DisplayCharsheet() and FightMode() )
    MapCreate          # Create session map in $MAP  
    (( CHAR_ITEMS < 8 )) && HotzonesDistribute # Place items randomly in map
    WORLDCHANGE_COUNTDOWN=0 # WorldChange Counter (0 or negative value allow changes)    
    # Create strings for economical situation..
    VAL_GOLD_STR=$( awk '{ printf "%4.2f", $0 }' <<< $VAL_GOLD )       # Usual printf is locale-depended - it cant work with '.' as delimiter when
    VAL_TOBACCO_STR=$( awk '{ printf "%4.2f", $0 }' <<< $VAL_TOBACCO ) # locale's delimiter is ',' (cyrillic locale for instance) #kstn

    GX_Intro

    local COUNTDOWN=60
    while (( COUNTDOWN >= 0 )) ; do
    	read -sn 1 -t 1 && COUNTDOWN=-1 || ((COUNTDOWN--))
    done
    unset COUNTDOWN
    NODICE=1 # Do not roll on first section after loading/starting a game in NewSector()
    NewSector
}

Announce() {
    # Simply outputs a 160 char text you can cut & paste to social media.
    
    # TODO: Once date is decoupled from system date (with CREATION and DATE), create new message. E.g.
    # $CHAR died $DATE having fought $BATTLES ($KILLS victoriously) etc...

    SetupHighscore

    # Die if $HIGHSCORE is empty
    [[ ! -s "$HIGHSCORE" ]] && Die "Sorry, can't do that just yet!\nThe highscore list is unfortunately empty right now."

    echo "TOP 10 BACK IN A MINUTE HIGHSCORES"
    HighscoreRead
    echo -en "\nSelect the highscore (1-10) you'd like to display or CTRL+C to cancel: "
    read SCORE_TO_PRINT

    ((SCORE_TO_PRINT < 1)) && ((SCORE_TO_PRINT > 10 )) && Die "\nOut of range. Please select an entry between 1-10. Quitting.."

    RollDice 6
    case "$DICE" in
	1 ) ADJECTIVE="honorable" ;;
	2 ) ADJECTIVE="fearless" ;;
	3 ) ADJECTIVE="courageos" ;;
	4 ) ADJECTIVE="brave" ;;
	5 ) ADJECTIVE="legendary" ;;
	6 ) ADJECTIVE="heroic" ;;
    esac

    ANNOUNCEMENT_TMP=$(sed -n "${SCORE_TO_PRINT}"p "$HIGHSCORE")
    IFS=";" read -r highEXP highCHAR highRACE highBATTLES highKILLS highITEMS highDATE highMONTH highYEAR <<< "$ANNOUNCEMENT_TMP"

    case "$highRACE" in
	1 ) highRACE="Human" ;;
	2 ) highRACE="Elf" ;;
	3 ) highRACE="Dwarf" ;;
	4 ) highRACE="Hobbit" ;;
    esac

    (( highBATTLES == 1 )) && highBATTLES+=" battle" || highBATTLES+=" battles"
    (( highITEMS == 1 ))   && highITEMS+=" item"     || highITEMS+=" items"

    highCHAR=$(awk '{ print substr(toupper($0), 1,1) substr($0, 2); }' <<< "$highCHAR") # Capitalize
    
    if [[ "$highMONTH" ]] ; then # fix for "Witching Day", etc
	ANNOUNCEMENT="$highCHAR fought $highBATTLES, $highKILLS victoriously, won $highEXP EXP and $highITEMS. This $ADJECTIVE $highRACE was finally slain the $highDATE of $highMONTH in the $highYEAR Cycle."
    else
	ANNOUNCEMENT="$highCHAR fought $highBATTLES, $highKILLS victoriously, won $highEXP EXP and $highITEMS. This $ADJECTIVE $highRACE was finally slain at the $highDATE in the $highYEAR Cycle."
    fi
    ANNOUNCEMENT_LENGHT=$(awk '{print length($0)}' <<< "$ANNOUNCEMENT" ) 
    GX_HighScore

    echo "ADVENTURE SUMMARY to copy and paste to your social media of choice:"
    echo -e "\n$ANNOUNCEMENT\n" | fmt
    echo "$HR"

    ((ANNOUNCEMENT_LENGHT > 160)) && echo "Warning! String longer than 160 chars ($ANNOUNCEMENT_LENGHT)!"
    exit 0
}

ColorConfig() {
    echo -e "\nWe need to configure terminal colors for the map!
Please note that a colored symbol is easier to see on the world map.
Back in a minute was designed for white text on black background.
Does \033[1;33mthis text appear yellow\033[0m without any funny characters?"
    read -sn1 -p "Do you want color? [Y/N]: " COLOR_CONFIG
    case "$COLOR_CONFIG" in
	n | N ) COLOR=0 ; echo -e "\nDisabling color! Edit $GAMEDIR/config to change this setting.";;
	* )     COLOR=1 ; echo -e "\nEnabling color!" ;;
    esac
    sed -i"~" "/^COLOR:/s/^.*$/COLOR: $COLOR/g" "$GAMEDIR/config" # MacOS fix http://stackoverflow.com/questions/7573368/in-place-edits-with-sed-on-os-x
    sleep 2
}

CreateBiaminLauncher() {
    grep -q 'biamin' "$HOME/.bashrc" && Die "Found existing launcher in $HOME/.bashrc.. skipping!" 
    BIAMIN_RUNTIME=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ) # TODO $0 is a powerful beast, but will sometimes fail..
    echo "This will add $BIAMIN_RUNTIME/biamin to your .bashrc"
    read -n 1 -p "Install Biamin Launcher? [Y/N]: " LAUNCHER
    case "$LAUNCHER" in
	y | Y ) echo -e "\n# Back in a Minute Game Launcher (just run 'biamin')\nalias biamin='$BIAMIN_RUNTIME/biamin.sh'" >> "$HOME/.bashrc";
	        echo -e "\nDone. Run 'source \$HOME/.bashrc' to test 'biamin' command." ;;
	* ) echo -e "\nDon't worry, not changing anything!";;
    esac
    exit 0
}        

#                           END FUNCTIONS                              #
#                                                                      #
#                                                                      #
########################################################################

########################################################################
#                                                                      #
#                        2. RUNTIME BLOCK                              #
#                   All running code goes here!                        #

# Parse CLI arguments if any # TODO use getopts ?
case "$1" in
    -a | --announce )     Announce ;;
    -i | --install ) CreateBiaminLauncher ;;
    -h | --help )
	echo "Run BACK IN A MINUTE with '-p', '--play' or 'p' argument to play!"
	echo "For usage: run biamin --usage"
	echo "Current dir for game files: $GAMEDIR/"
	echo "Change at runtime or on line 10 in the CONFIGURATION of the script."
	exit 0;;
    --map )
	read -n1 -p "Create custom map template? [Y/N]: " CUSTOM_MAP_PROMPT
	case "$CUSTOM_MAP_PROMPT" in
		y | Y) echo -e "\nCreating custom map template.." ; MapCreateCustom ;;
		*)     echo -e "\nNot doing anything! Quitting.."
	esac
	exit 0 ;;
    -p | --play | p ) echo "Launching Back in a Minute.." ;;
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
    --update ) # Update function
	# Removes stranded repo files before proceeding..
	STRANDED_REPO_FILES=$(find "$GAMEDIR"/repo.* | wc -l)
	(( STRANDED_REPO_FILES > 0 )) && rm -f "$GAMEDIR/repo.*"
	REPO_SRC="https://gitorious.org/back-in-a-minute/code/raw/biamin.sh"
	GX_BiaminTitle;
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
 		read -sn1 -p "Update to Biamin version $REPOVERSION? [Y/N] " CONFIRMUPDATE
		case "$CONFIRMUPDATE" in
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
		    * ) echo -e "\nNot updating! Removing temporary file .."; rm -f "$REPO" ;;
		esac
		;;
	esac
	echo "Done. Thanks for playing :)"
	exit 0;;
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

if [[ ! -d "$GAMEDIR" ]] ; then # Check whether gamedir exists..
    echo -e "Game directory default is $GAMEDIR/\nYou can change this in $GAMEDIR/config. Creating directory .."
    mkdir -p "$GAMEDIR/" || Die "ERROR! You do not have write permissions for $GAMEDIR .."
fi

if [[ ! -f "$GAMEDIR/config" ]] ; then # Check whether $GAMEDIR/config exists..
    echo "Creating $GAMEDIR/config .." ;
    echo -e "GAMEDIR: ${GAMEDIR}\nCOLOR: NA" > "$GAMEDIR/config" ;
fi

echo "Putting on the traveller's boots.."

# Load variables from $GAMEDIR/config. NB variables should not be empty !
read -r GAMEDIR COLOR <<< $(awk '{ if (/^GAMEDIR:/)  { GAMEDIR= $2 }
                                   if (/^COLOR:/)    { COLOR = $2  } }
                            END { print GAMEDIR " " COLOR ;}' "$GAMEDIR/config" )
# Color configuration
case "$COLOR" in
    1 ) echo "Enabling color for maps!" ;;
    0 )	echo "Enabling old black-and-white version!" ;;
    * ) ColorConfig ;;
esac

if (( COLOR == 1 )); then # Define colors
    YELLOW='\033[1;33m' # Used in MapNav() and GX_Map()
    RESET='\033[0m'
fi # TODO define here another seqences from MapNav()

# Define escape sequences #TODO replace to tput or similar
CLEAR_LINE="\e[1K\e[80D" # \e[1K - erase to the start of line \e[80D - move cursor 80 columns backward

trap CleanUp SIGHUP SIGINT SIGTERM # Direct termination signals to CleanUp
SetupHighscore # Setup highscore file
MainMenu       # Run main menu
exit 0         # This should never happen:
               # .. but why be 'tardy when you can be tidy?
