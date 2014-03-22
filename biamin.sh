#!/bin/bash
# Back In A Minute by Sigg3.net (C) 2014
# Code is GNU GPLv3 & ASCII art is CC BY-NC-SA 4.0
<<<<<<< HEAD
VERSION="1.3.6"
=======
VERSION="1.3"
>>>>>>> 1813685971b8991e5779e5ab65a6dba945314655
WEBURL="http://sigg3.net/biamin/"

########################################################################
# BEGIN CONFIGURATION                                                  #
<<<<<<< HEAD
# Default dir for config, change at runtime (no trailing slash!)       #
GAMEDIR="$HOME/.biamin"                                                #
=======
# Game directory used for game files (no trailing slash!)              #
GAMEDIR="$HOME/Games/biamin"                                           #
>>>>>>> 1813685971b8991e5779e5ab65a6dba945314655
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

GX_Banner() {
clear
cat <<"EOT"
            ______                                                     
          (, /    )       /)     ,                    ,               
            /---(  _   _ (/_      __     _     ___     __      _/_  _ 
         ) / ____)(_(_(__/(__  _(_/ (_  (_(_   // (__(_/ (_(_(_(___(/_
        (_/ (                                                         
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
clear
cat <<"EOT"
            ______                                                     
          (, /    )       /)     ,                    ,               
            /---(  _   _ (/_      __     _     ___     __      _/_  _ 
         ) / ____)(_(_(__/(__  _(_/ (_  (_(_   // (__(_/ (_(_(_(___(/_
        (_/ (   
                         
   Back in a minute is an adventure game with 4 playable races, 6 enemies,
   8 items and 6 scenarios spread across the 270 sections of the world map.
   Biamin saves character sheets between sessions and keeps a highscore!
   The game supports custom maps too! See --help or --usage for information.
EOT
echo -e "\n   Game directory: $GAMEDIR/\n"
cat <<"EOT"
   This timekiller's written entirely in BASH. It was intended for sysadmins
   but please note that it isn't console-friendly and it looks best in 80x24
   terminal emulators (white on black). Make sure it's a window you can close.
      
   BASH code (C) Sigg3.net GNU GPL Version 3 2014
   ASCII art (C) Sigg3.net CC BY-NC-SA 4.0 2014 (except figlet banners)

EOT
echo "   Visit the Back in a minute website at <$WEBURL>"
echo "   for updates, feedback and to report bugs. Thank you."
echo "$HR"
}
GX_HowTo() {
clear
cat <<"EOT"
            ______                                                     
          (, /    )       /)     ,                    ,               
            /---(  _   _ (/_      __     _     ___     __      _/_  _ 
         ) / ____)(_(_(__/(__  _(_/ (_  (_(_   // (__(_/ (_(_(_(___(/_
        (_/ (   
                         
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
EOT
echo "   For more information please visit <$WEBURL>"
echo "$HR"
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
echo "$HR"
}
GX_Races() {
clear
cat <<"EOT"

                        C H A R A C T E R   R A C E S :

      1. MAN            2. ELF              3. DWARF            4. HOBBIT
 
   Healing:  3/6      Healing:  4/6       Healing:  2/6        Healing:  4/6   
   Strength: 3/6      Strength: 3/6       Strength: 5/6        Strength: 1/6
   Accuracy: 3/6      Accuracy: 4/6       Accuracy: 3/6        Accuracy: 4/6
   Flee:     3/6      Flee:     1/6       Flee:     2/6        Flee:     3/6
   
   
   Dice rolls on each turn. Accuracy also initiative. Healing during resting.

EOT
echo "$HR"
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
                        \ \_|\/\     ________      / /            \ \ 
                         \ _    \   /        \    /  /             \ \
         T H E            \ \____\_|          \--/  /__   ____      \ \ 
         M I G H T Y       \_    _|            |       ) / __ )      \ \
                             \  / \    .\  /.  |        / |  (_   __  \ \
         C H T H U L U ' S    \/    \         /       _/ /|  | \_/  )  \ \     
                              /   _/         \      / _/   \/   /-/|    \ \     
         W R A T H   I S     /   //.(/((| |\(\\    / /          \/ |     \ \   (
         U P O N   Y O U    /   / ||__ "| |   \|  |_ |----------L /       \ \ _/
                           /   /  \__/  | |/|      \_) \        |/         \_/
                          /   /     |    \_/            \               __(
                          |   (      |                   \           __(
                          \|\|\\      |                   `         (  

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

# GFX MAP FUNCTIONS

# FILL THE $MAP file using either default or custom map
MapCreate() {
if [ -f "$GAMEDIR/CUSTOM.map" ]; then
	if grep -q 'Z' "$GAMEDIR/CUSTOM.map" ; then
		echo "Whoops! Custom map file still contains Z's!"
		echo "Use ONLY symbols from the legend (x . T @ H C) in your custom maps!"
		CustomMapError
	else
		cat "$GAMEDIR/CUSTOM.map" > "$MAP"
	fi
else
	cat <<"EOT" > "$MAP"
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
fi
}

# Map template generator (CLI arg function)
MapCreateCustom() {
if [ -d "$GAMEDIR" ] ; then
	cat <<"EOT" > ""$GAMEDIR"/rename_to_CUSTOM.map"
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
	echo "Custom map template created in $GAMEDIR/rename_to_CUSTOM.map"
	echo -e "\n1. Change all 'Z' symbols in map area with any of these:  x . T @ H C"
	echo "   See the LEGEND in rename_to_CUSTOM.map file for details."
	echo "   Home default is $START_LOCATION. Change line 16 of CONFIG or enter new HOME at runtime."
	echo "2. Spacing must be accurate, so don't touch whitespace or add new lines."
	echo -e "3. When you are done, simply rename your map file to CUSTOM.map\n"
	echo -e "Please submit bugs and feedback at <$WEBURL>"
	exit
else
	echo "Please create $GAMEDIR/ directory before running" && exit
fi
}
								       
#                          END GFX FUNCTIONS                           #
#                                                                      #       
#                                                                      #
########################################################################





########################################################################       
#                                                                      #
#                          1. FUNCTIONS                                #
#                    All program functions go here!                    #
									       


# CLEANUP Function
CleanUp() {
	
# -10 HP Penalty for exiting CTRL+C during battle!
if (( FIGHTMODE == 1 )); then
	echo -e "\n PENALTY for CTRL+Chickening out during battle: -20 HP -20 EXP"
	CHAR_HEALTH=$(( CHAR_HEALTH-20 ))
	CHAR_EXP=$(( CHAR_EXP-20 ))
	echo -en " HEALTH: $CHAR_HEALTH\tEXPERIENCE: $CHAR_EXP"
	SaveCurrentSheet
fi

if [ -f "$MAP" ]; then
	rm -f "$MAP" 
fi
echo -e "\nLeaving the realm of magic behind ...." 
echo -e "Please submit bugs and feedback at <$WEBURL>"
exit
}

# PRE-CLEANUP tidying function for buggy custom maps
CustomMapError() {
<<<<<<< HEAD
echo -e "What to do?\n1) rename CUSTOM.map to CUSTOM_err.map or\n2) delete template file CUSTOM.map (deletion is irrevocable).\n"
echo -en "Please select 1 or 2: " && read -n 1 MAP_CLEAN_OPTS
case "$MAP_CLEAN_OPTS" in
1 ) mv "$GAMEDIR/CUSTOM.map" "$GAMEDIR/CUSTOM_err.map" && echo -e "\nCustom map file moved to $GAMEDIR/CUSTOM_err.map" && sleep 4 ;;
2 ) rm -f "$GAMEDIR/CUSTOM.map" && echo -e "\nCustom map deleted!" && sleep 4 ;;
* ) echo -e "\nBad option! Quitting.." && exit ;;
esac
=======
echo -e "What to do? We can either 1) rename CUSTOM.map to CUSTOM_err.map or\n2) delete template file CUSTOM.map (deletion is irrevocable).\n"
MAP_CLEAN_OPTS="Rename Delete"
select OPT in "$MAP_CLEAN_OPTS"; do
if [ "$OPT" = "Rename" ]; then
	echo "Custom map file moved to $GAMEDIR/CUSTOM_err.map"
	mv "$GAMEDIR/CUSTOM.map" "$GAMEDIR/CUSTOM_err.map"
	CleanUp
elif [ "$OPT" = "Delete" ]; then
	echo -en "If you are sure you want to delete CUSTOM.map, type YES: " && read -n 3 "del_map_opt"
	if [ "$del_map_opt" = "YES" ] ; then
		echo -e "\nDeleting $GAMEDIR/CUSTOM.map.."
		rm -f "$GAMEDIR/CUSTOM.map"
		CleanUp
	else
		echo "Not deleting anything. Quitting.."
		CleanUp
	fi
else
	echo "Bad option! Quitting.."
	CleanUp
fi
done
>>>>>>> 1813685971b8991e5779e5ab65a6dba945314655
}


# Setup Highscore File
SetupHighscore() {
if [ -d "$GAMEDIR" ] ; then
	HIGHSCORE="$GAMEDIR/highscore"

	if [ -f "$HIGHSCORE" ]; then
		touch -a "$HIGHSCORE"
	else
		echo "d41d8cd98f00b204e9800998ecf8427e" > "$HIGHSCORE"
	fi
else
	echo "Please create $GAMEDIR/ directory before running" && exit
fi	
}



### DISPLAY MAP
GX_Map() {
clear
((MAP_Y_TMP--))
if (( COLOR == 1 )); then
	sed -n 1,"${MAP_Y_TMP}"p "$MAP" | sed ''/~/s//$(printf "\033[1;33m~\033[0m")/''
else
	sed -n 1,"${MAP_Y_TMP}"p "$MAP"
fi
((MAP_Y_TMP++))
if (( MAP_Y > 9 )); then
	echo -en "$MAP_Y )   "
else
	echo -en " $MAP_Y )   "
fi
if (( MAP_X == 18 )); then
	# Lazy fix to add border ASCII "(" when X pos is R (fully east)
	if (( COLOR == 1 )) ; then
		sed -n "${MAP_Y_TMP}"p "$MAP" | sed 's/.[0-9].)   //g' | gawk -F "   " -v OFS="   " '{$'$MAP_X'="o ("; print }' | sed ''/o/s//$(printf "\033[1;33mo\033[0m")/'' | sed ''/~/s//$(printf "\033[1;33m~\033[0m")/''
	else
		sed -n "${MAP_Y_TMP}"p "$MAP" | sed 's/.[0-9].)   //g' | gawk -F "   " -v OFS="   " '{$'$MAP_X'="o ("; print }'
	fi
else
	if (( COLOR == 1 )); then
		sed -n "${MAP_Y_TMP}"p "$MAP" | sed 's/.[0-9].)   //g' | gawk -F "   " -v OFS="   " '{$'$MAP_X'="o"; print }' | sed ''/o/s//$(printf "\033[1;33mo\033[0m")/'' | sed ''/~/s//$(printf "\033[1;33m~\033[0m")/''
	else
		sed -n "${MAP_Y_TMP}"p "$MAP" | sed 's/.[0-9].)   //g' | gawk -F "   " -v OFS="   " '{$'$MAP_X'="o"; print }'
	fi
fi
((MAP_Y_TMP++))
if (( COLOR == 1 )); then
	sed -n "${MAP_Y_TMP}",21p "$MAP" | sed ''/~/s//$(printf "\033[1;33m~\033[0m")/''
else
	sed -n "${MAP_Y_TMP}",21p "$MAP"
fi
((MAP_Y_TMP--))
}

### DISPLAY MAP with GIFT OF SIGHT
GX_MapSight() {
<<<<<<< HEAD
=======
	
	# sed: -e expression #1, char 2: unterminated `s' command


>>>>>>> 1813685971b8991e5779e5ab65a6dba945314655
# Show ONLY the NEXT item viz. "Item to see" (ITEM2C)
# Since 1st item is item0, and CHAR_ITEMS begins at 0, ITEM2C=CHAR_ITEMS
ITEM2C=${HOTZONE[$CHAR_ITEMS]} #original with echo.. ITEM2C=$(echo ${HOTZONE[$CHAR_ITEMS]})

# If ITEM2C has been found earlier, it is now 20-20 and must be changed
# Remember, the player won't necessarily find items in HOTZONE array's sequence
if [ "$ITEM2C" = "20-20" ] ; then
	ITEM_X && ITEM_Y
	HOTZONE[$CHAR_ITEMS]="$ITEM_X-$ITEM_Y"
	ITEM2C=${HOTZONE[$CHAR_ITEMS]}
fi

# Retrieve item map positions e.g. 1-15 >> X=1 Y=15
IFS="-" read -r "ITEM2C_X" "ITEM2C_Y" <<< "$ITEM2C"

# If the item is the same as last time, don't repeat operations
if [ -n "$ITEM2C_prev" ] && [ "$ITEM2C" = "$ITEM2C_prev" ]; then
	GX_Map # Avoids unnecessary IO
else
	# Reset map-file to default
	MapCreate
	(( ITEM2C_Y++ )) && (( ITEM2C_Y++ )) # Add 2x padding for ASCII borders

	# Replace item pos in map file with s symbol
	if (( ITEM2C_X == 18 )); then
		# Lazy fix for most eastern col
		ITEM2C_STR=$(sed -n "${ITEM2C_Y}"p "$MAP" | sed 's/.[0-9].)   //g' |  gawk -F "   " -v OFS="   " '{$'$ITEM2C_X'="~ ("; print }')
	else
		ITEM2C_STR=$(sed -n "${ITEM2C_Y}"p "$MAP" | sed 's/.[0-9].)   //g' |  gawk -F "   " -v OFS="   " '{$'$ITEM2C_X'="~"; print }')
	fi

	(( ITEM2C_Y-- )) && (( ITEM2C_Y-- )) # Remove padding

	if (( ITEM2C_Y > 9 )); then	
		ITEM2C_STR="$ITEM2C_Y )   $ITEM2C_STR"
	else
		ITEM2C_STR=" $ITEM2C_Y )   $ITEM2C_STR"
	fi
	
	# Replace line in $MAP file with ITEM2C_STR
	MAP_TMP=$(mktemp "$GAMEDIR"/map.tmp.XXXXXXXX)		# TODO change sed below to -i to avoid tmp file?
	(( ITEM2C_Y++ )) && (( ITEM2C_Y++ )) # Add padding again
	REMOVE_STR=$(sed -n "${ITEM2C_Y}"p "$MAP")	
	sed -e "s/$REMOVE_STR/$ITEM2C_STR/g" "$MAP" > "$MAP_TMP"
	# TMP cleanup (remove if you can avoid tmp file MAP_TMP)
	mv "$MAP_TMP" "$MAP"
	unset MAP_TMP
	
	# Last item logged to avoid unnecessary IO
	(( ITEM2C_Y-- )) && (( ITEM2C_Y-- )) # Remove padding
	ITEM2C_prev="$ITEM2C_X-$ITEM2C_Y"

	# Display map with updated ~ item symbol
	GX_Map
fi
}


# SAVE CHARSHEET
SaveCurrentSheet() {
# Saves current game values to CHARSHEET file (overwriting)
echo "CHARACTER: $CHAR" > "$CHARSHEET"
echo "RACE: $CHAR_RACE" >> "$CHARSHEET"
echo "BATTLES: $CHAR_BATTLES" >> "$CHARSHEET"
echo "EXPERIENCE: $CHAR_EXP">> "$CHARSHEET"
echo "LOCATION: $CHAR_GPS" >> "$CHARSHEET"
echo "HEALTH: $CHAR_HEALTH" >> "$CHARSHEET"
echo "ITEMS: $CHAR_ITEMS" >> "$CHARSHEET"
echo "KILLS: $CHAR_KILLS" >> "$CHARSHEET"
echo "HOME: $CHAR_HOME" >> "$CHARSHEET"
}

# CHAR SETUP
BiaminSetup() {
# Set CHARSHEET variable to gamedir/char.sheet (lowercase)
CHARSHEET="$GAMEDIR/$(echo "$CHAR" | tr '[:upper:]' '[:lower:]' | tr -d " ").sheet"

# Check whether CHAR exists if not create CHARSHEET
if [ -f "$CHARSHEET" ] ; then
	echo " Welcome back, $CHAR!"
	echo " Loading character sheet ..."
<<<<<<< HEAD
	# replaced grep | sed to only grep		#kstn 20/03/2014
	CHAR=$(sed -n '/^CHARACTER:/s/CHARACTER: //p' "$CHARSHEET")
	CHAR_RACE=$(sed -n '/^RACE:/s/RACE: //p' "$CHARSHEET")
	CHAR_BATTLES=$(sed -n '/^BATTLES:/s/BATTLES: //p' "$CHARSHEET")
	CHAR_EXP=$(sed -n '/^EXPERIENCE:/s/EXPERIENCE: //p' "$CHARSHEET")
	CHAR_GPS=$(sed -n '/^LOCATION:/s/LOCATION: //p' "$CHARSHEET")
	CHAR_HEALTH=$(sed -n '/^HEALTH:/s/HEALTH: //p' "$CHARSHEET")
	CHAR_ITEMS=$(sed -n '/^ITEMS:/s/ITEMS: //p' "$CHARSHEET")
	CHAR_KILLS=$(sed -n '/^KILLS:/s/KILLS: //p' "$CHARSHEET")
=======
	CHAR=$(grep 'CHARACTER:' "$CHARSHEET" | sed 's/CHARACTER: //g')
	CHAR_RACE=$(grep 'RACE:' "$CHARSHEET" | sed 's/RACE: //g')
	CHAR_BATTLES=$(grep 'BATTLES:' "$CHARSHEET" | sed 's/BATTLES: //g')
	CHAR_EXP=$(grep 'EXPERIENCE:' "$CHARSHEET" | sed 's/EXPERIENCE: //g')
	CHAR_GPS=$(grep 'LOCATION:' "$CHARSHEET" | sed 's/LOCATION: //g')
	CHAR_HEALTH=$(grep 'HEALTH:' "$CHARSHEET" | sed 's/HEALTH: //g')
	CHAR_ITEMS=$(grep 'ITEMS:' "$CHARSHEET" | sed 's/ITEMS: //g')
	CHAR_KILLS=$(grep 'KILLS:' "$CHARSHEET" | sed 's/KILLS: //g')
>>>>>>> 1813685971b8991e5779e5ab65a6dba945314655

	# Compatibility fix for older charactersheets
	if grep -q 'HOME:' "$CHARSHEET" ; then
		CHAR_HOME=$(grep 'HOME:' "$CHARSHEET" | sed 's/HOME: //g')
	else
		CHAR_HOME="$START_LOCATION"
	fi
	# If character is dead, don't fool around..
	if (( CHAR_HEALTH <= 0 )); then
		echo -e "\nWhoops!"
		echo " $CHAR's health is $CHAR_HEALTH!"
		echo " This game does not support necromancy, sorry!"
		CleanUp
	fi
	sleep 2
else
	echo " $CHAR is a new character!"
	CHAR_BATTLES=0
	CHAR_EXP=0
	CHAR_HEALTH=100
	CHAR_ITEMS=0
	CHAR_KILLS=0
	GX_Races
	echo -en " Select character race (1-4): " && read -sn 1 CHAR_RACE
	case $CHAR_RACE in
		2 ) echo "You chose to be an ELF" ;;
		3 ) echo "You chose to be a DWARF" ;;
		4 ) echo "You chose to be a HOBBIT" ;;
		1 | * ) CHAR_RACE=1 && echo "You chose to be a HUMAN" ;;	# Not very good, but works :) #kstn
	esac
	# If there IS a CUSTOM.map file, ask where the player would like to start
	if [ -f "$GAMEDIR/CUSTOM.map" ] ; then
		echo -en " HOME location for custom maps (ENTER for default $START_LOCATION): " && read "CHAR_LOC"
		if [ -z "$CHAR_LOC" ]; then
			CHAR_GPS="$START_LOCATION"
			CHAR_HOME="$START_LOCATION"
		else
			# Use user input as start location.. but first SANITY CHECK
			CHAR_LOC_LEN="${#CHAR_LOC}" # Length of string
			if (( CHAR_LOC_LEN > 3 )) || (( CHAR_LOC_LEN < 1 )) ; then
				echo " Error! Wrong number of characters in $CHAR_LOC"
				echo " Start location is 2-3 alphanumeric chars [A-R][1-15], e.g. C2 or P13"
				CleanUp
			else
				echo -en "Sanity check.."
				CHAR_LOC_A=$(echo "$CHAR_LOC" | cut -c 1-1)
				if (( CHAR_LOC_LEN == 2 )) ; then
					CHAR_LOC_B=$(echo "$CHAR_LOC" | cut -c 2-2)
				else
					CHAR_LOC_B=$(echo "$CHAR_LOC" | cut -c 2-3)
				fi
				case "$CHAR_LOC_A" in
					A | B | C | D | E | F | G | H | I | J | K | L | M | N | O | P | Q | R ) echo -en ".." ;;
					* ) echo -e "\n Error! Start location X-Axis $CHAR_LOC_A must be a CAPITAL alphanumeric A-R letter!" && CleanUp ;;
				esac
				case "$CHAR_LOC_B" in
					1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 ) echo -en ".. Done!\n" ;;
					* ) echo -e "\n Error! Start location Y-Axis $CHAR_LOC_B is too big or too small!" && CleanUp ;;
				esac
			fi
			unset CHAR_LOC_LEN && unset CHAR_LOC_A && unset CHAR_LOC_B
			# End of SANITY check, everything okay!
			CHAR_GPS="$CHAR_LOC"
			CHAR_HOME="$CHAR_LOC"
			unset CHAR_LOC
		fi
	else
		CHAR_GPS="$START_LOCATION"
		CHAR_HOME="$START_LOCATION"
	fi
	echo " Creating fresh character sheet for $CHAR ..."
	SaveCurrentSheet
	sleep 2
fi

# Set abilities according to race (each equal to 12)
case $CHAR_RACE in
1 ) HEALING=3 && STRENGTH=3 && ACCURACY=3 && FLEE=3 ;; # human (3,3,3,3)
2 ) HEALING=4 && STRENGTH=3 && ACCURACY=4 && FLEE=1 ;; # elf (4,3,4,1)
3 ) HEALING=2 && STRENGTH=5 && ACCURACY=3 && FLEE=2 ;; # dwarf (2,5,3,2)
4 ) HEALING=4 && STRENGTH=1 && ACCURACY=4 && FLEE=3 ;; # hobbit (4,1,4,3)
esac

<<<<<<< HEAD
# Adjust abilities according to items
if (( CHAR_ITEMS >= 2 )); then
	((HEALING++))				 		   	# Adjusting for Emerald of Narcolepsy
	if (( CHAR_ITEMS >= 4 )); then
		((FLEE++))						   	# Adjusting for Fast Magic Boots
		if (( CHAR_ITEMS >= 7 )); then		
			((STRENGTH++))				   	# Adjusting for Broadsword
			if (( CHAR_ITEMS >= 8 )); then	
				((ACCURACY++))				# Adjusting for Steady Hand Brew
=======
# Adjust abilities according to items and spells
if (( CHAR_ITEMS >= 2 )); then
	((HEALING++))				 		   # Adjusting for Emerald of Narcolepsy
	if (( CHAR_ITEMS >= 4 )); then
		((FLEE++))						   # Adjusting for Fast Magic Boots
		if (( CHAR_ITEMS >= 7 )); then
			((STRENGTH++))				   # Adjusting for Broadsword
			if (( CHAR_ITEMS >= 8 )); then # Allows tampered files!
				((ACCURACY++))			   # Adjusting for Steady Hand Brew
>>>>>>> 1813685971b8991e5779e5ab65a6dba945314655
			fi
		fi
	fi
fi

# If Cheating is disabled (in CONFIGURATION) restrict health to 149
if (( DISABLE_CHEATS == 1 )) && (( CHAR_HEALTH >= 150 )); then
	CHAR_HEALTH=150
	SaveCurrentSheet
fi

# Zombie fix
if (( DEATH == 1 )); then
	DEATH=0 && Intro
fi
}

# Today's Date (used in Highscore, Charsheet and in DEATH!)
# An adjusted version of warhammeronline.wikia.com/wiki/Calendar
TodaysDate() {
IFS="-" read -r "TODAYS_YEAR" "TODAYS_MONTH" "TODAYS_DATE" <<< "$(date +%F)"

# Adjust date
case "$TODAYS_DATE" in
	01 ) TODAYS_DATE="1st" ;;
	02 ) TODAYS_DATE="2nd" ;;
	03 ) TODAYS_DATE="3rd" ;;
	04 | 05 | 06 | 07 | 08 | 09 ) TODAYS_DATE=${TODAYS_DATE#?} && TODAYS_DATE+="th" ;;
	21 | 31 ) TODAYS_DATE+="st" ;;
	22 ) TODAYS_DATE+="nd" ;;
	23 ) TODAYS_DATE+="rd" ;;
	* ) TODAYS_DATE+="th" ;;
esac

# Adjust month
case "$TODAYS_MONTH" in
	01 ) TODAYS_MONTH="After-Witching" ;;
	02 ) TODAYS_MONTH="Year-Turn" ;;
	03 ) TODAYS_MONTH="Plough Month" ;;
	04 ) TODAYS_MONTH="Sigmar Month" ;;
	05 ) TODAYS_MONTH="Summer Month" ;;
	06 ) TODAYS_MONTH="Fore-Mystery" ;;
	07 ) TODAYS_MONTH="After-Mystery" ;;
	08 ) TODAYS_MONTH="Harvest Month" ;;
	09 ) TODAYS_MONTH="Brew Month" ;;
	10 ) TODAYS_MONTH="Chill Month" ;;
	11 ) TODAYS_MONTH="Ulric Month" ;;
	12 ) TODAYS_MONTH="Fore-Witching" ;;
	* ) TODAYS_MONTH="Biamin Festival" ;;  # rarely happens, if ever :(
esac

<<<<<<< HEAD
# Adjust year (removes 20 from 2013). This will have to be rewritten in 2021.
TODAYS_YEAR=${TODAYS_YEAR#??}
TODAYS_YEAR_STR=$TODAYS_YEAR && TODAYS_YEAR_STR+="th"

# Output example "3rd of Year-Turn in the 13th cycle"
TODAYS_DATE_STR="$TODAYS_DATE of $TODAYS_MONTH in the $TODAYS_YEAR_STR Cycle"	# "date sentence" LOL
=======
# Adjust year (removes 20 from 2013)
TODAYS_YEAR=${TODAYS_YEAR#??}

# Output example "3rd of Year-Turn in the 13th cycle"
TODAYS_DATE_STR="$TODAYS_DATE of $TODAYS_MONTH in the $TODAYS_YEARth Cycle"	# "date sentence" LOL
>>>>>>> 1813685971b8991e5779e5ab65a6dba945314655
}


################### MENU SYSTEM #################
# Main menu
MainMenu() {
	# The actual menu we use..
	TopMenu() {
	GX_Banner
	echo -en "        (P)lay    (L)oad game    (H)ighscore    (C)redits    (Q)uit   "
	read -sn 1 TOPMENU_OPT
	}
	TopMenu
	case "$TOPMENU_OPT" in
	p ) GX_Banner && echo -en " Enter character name (case sensitive): " && read "CHAR" && BiaminSetup;;
	h ) HighScore ;;
	l ) LoadGame ;;
	c ) Credits ;;
	q | * ) CleanUp ;;
	esac
}

# Highscore
HighscoreRead() {
sort -g -r "$HIGHSCORE" -o "$HIGHSCORE"
HIGHSCORE_TMP=$(mktemp "$GAMEDIR"/high.XXXXXX) # Dirty workaround to allow nice tabbed output..
echo -e " #;Hero;EXP;Wins;Items;Entered History\n; " > "$HIGHSCORE_TMP"
i=1
# Read values from highscore file (BashFAQ/001)
while IFS=";" read -r highEXP highCHAR highRACE highBATTLES highKILLS highITEMS highDATE highMONTH highYEAR; do
if (( i > SCORES_2_DISPLAY )); then
	break
fi
case "$highRACE" in
	1 ) highRACE="Human" ;;
	2 ) highRACE="Elf" ;;
	3 ) highRACE="Dwarf" ;;
	4 ) highRACE="Hobbit" ;;
esac

echo " $i.;$highCHAR the $highRACE;$highEXP;$highKILLS/$highBATTLES;$highITEMS/8;$highMONTH $highDATE ($highYEAR)" >> "$HIGHSCORE_TMP"
((i++))
done < "$HIGHSCORE"
column -t -s ";" "$HIGHSCORE_TMP"			# Nice tabbed output!
rm -f "$HIGHSCORE_TMP" && unset HIGHSCORE_TMP
}

HighScore() {
GX_HighScore
echo -en "\n"
if grep -q 'd41d8cd98f00b204e9800998ecf8427e' "$HIGHSCORE" ; then
	echo " The highscore list is unfortunately empty right now."
	echo " You have to play some to get some!"
else
	SCORES_2_DISPLAY=10	# Show 10 highscore entries
	HighscoreRead
fi
echo -en "\n                   Press the any key to go to (M)ain menu    " && read -sn 1
MainMenu
}

Credits() {
GX_Credits
echo -en "                 (M)ain menu    (H)owTo    (L)icense    (Q)uit               " && read -sn 1 "CREDITS_OPT"
case "$CREDITS_OPT" in
L | l ) License ;;
Q | q ) CleanUp ;;
H | h ) HowTo ;;
M | * ) MainMenu ;;
esac
}

HowTo() {
GX_HowTo
echo -en "                       (M)ain menu    (C)redits   (Q)uit               " && read -sn 1 "HOWTO_OPT"
case "$HOWTO_OPT" in
C | c ) Credits ;;
Q | q ) CleanUp ;;
M | m | * ) MainMenu ;;
esac
}

PrepareLicense() {
# gets licenses and concatenates into "LICENSE" in $GAMEDIR
curl -s -o "$GAMEDIR/code-license" "http://www.gnu.org/licenses/gpl-3.0.txt"
curl -s -o "$GAMEDIR/art-license" "http://creativecommons.org/licenses/by-nc-sa/4.0/legalcode.txt"
echo -e "\t\t   BACK IN A MINUTE BASH CODE LICENSE:\t\t\t(Q)uit\n\n$HR\n" >> "$GAMEDIR/LIC-PRE-0"
echo -e "\n\n$HR\n\n\t\t   BACK IN A MINUTE ARTWORK LICENSE:\n\n" >> "$GAMEDIR/LIC-INTER-1"
cat "$GAMEDIR/LIC-PRE-0" "$GAMEDIR/code-license" "$GAMEDIR/LIC-INTER-1" "$GAMEDIR/art-license" > "$GAMEDIR/LICENSE"
rm -f "$GAMEDIR/code-license" && rm -f "$GAMEDIR/art-license" && rm -f "$GAMEDIR/LIC-PRE-0" && rm -f "$GAMEDIR/LIC-INTER-1"
echo "Licenses downloaded and concatenated!" && sleep 1
}

License() {
# Displays license if present or runs PrepareLicense && then display it..
clear
if [ -f "$GAMEDIR/LICENSE" ]; then
	less "$GAMEDIR/LICENSE"
else
	echo "License file currently missing in $GAMEDIR/ !"
	echo -en "To DL licenses, about 60kB, type YES (requires internet access): " && read "DL_LICENSE_OPT"
	case "$DL_LICENSE_OPT" in
	YES ) PrepareLicense && less "$GAMEDIR/LICENSE" ;;
	* ) echo -e "Code License:\t<http://www.gnu.org/licenses/gpl-3.0.txt>\nArt License:\t<http://creativecommons.org/licenses/by-nc-sa/4.0/legalcode.txt>\nMore info:\t<$WEBURLabout#license>\nPress any key to go back to main menu!" && read -sn 1;;
	esac
fi
MainMenu
}

LoadGame() {
# TODO This function could be more userfriendly (one typically hits a number, not writes a name...)
local NUMBEROFSHEETS="$(find "$GAMEDIR"/ -name '*.sheet' | wc -l)"
if (( NUMBEROFSHEETS >= 1 )); then
	GX_LoadGame && echo -en "\n"
	i=1
	for loadSHEET in "$GAMEDIR"/*.sheet ; do
		loadCHAR=$(sed -n '/^CHARACTER:/s/CHARACTER: //p' "$loadSHEET")	# reduced to sed #kstn 20/03/2014
		loadRACE=$(sed -n '/^RACE:/s/RACE: //p' "$loadSHEET")
		case "$loadRACE" in
		1 ) loadRACE="Human" ;;
		2 ) loadRACE="Elf" ;;
		3 ) loadRACE="Dwarf" ;;
		4 ) loadRACE="Hobbit" ;;
		esac
<<<<<<< HEAD
		loadGPS=$(sed -n '/^LOCATION:/s/LOCATION: //p' "$loadSHEET")
		loadHEALTH=$(sed -n '/^HEALTH:/s/HEALTH: //p' "$loadSHEET")
		loadITEMS=$(sed -n '/^ITEMS:/s/ITEMS: //p' "$loadSHEET")
		loadEXP=$(sed -n '/^EXPERIENCE:/s/EXPERIENCE: //p' "$loadSHEET")
=======
		loadGPS=$(grep 'LOCATION:' "$loadSHEET" | sed 's/LOCATION: //g')
		loadHEALTH=$(grep 'HEALTH:' "$loadSHEET" | sed 's/HEALTH: //g')
		loadITEMS=$(grep 'ITEMS:' "$loadSHEET" | sed 's/ITEMS: //g')
		loadEXP=$(grep 'EXPERIENCE:' "$loadSHEET" | sed 's/EXPERIENCE: //g')
>>>>>>> 1813685971b8991e5779e5ab65a6dba945314655
	echo -en " $i. \"$loadCHAR\" the $loadRACE ($loadHEALTH HP, $loadEXP EXP, $loadITEMS items, sector $loadGPS)\n"
	(( i++ ))
	done
else
	GX_LoadGame && echo -en "\n"
	echo -e " Sorry! No character sheets in $GAMEDIR/"
fi
echo -en "\n Enter NAME of character to load or create (case sensitive): " && read "CHAR" && BiaminSetup
}

# GAME ITEMS
# Randomizer for Item Positions used in e.g. HotzonesDistribute
ITEM_X() {
ITEM_X=$((RANDOM%18+1))
}
ITEM_Y() {
ITEM_Y=$((RANDOM%15+1))
}

HotzonesDistribute() {
# Scatters special items across the map
if (( CHAR_ITEMS < 8 )); then
	ITEMS_2_SCATTER=$(( 8 - CHAR_ITEMS ))
	# default x-y HOTZONEs to extraterrestrial section 20-20
	HOTZONE=( 20-20 20-20 20-20 20-20 20-20 20-20 20-20 20-20 )
	i=7
	while [ $ITEMS_2_SCATTER -gt 0 ]; do
		ITEM_X && ITEM_Y
		HOTZONE[$i]="$ITEM_X-$ITEM_Y"
		((i--))
		((ITEMS_2_SCATTER--))
	done
fi
}


################### GAME SYSTEM #################

## GAME FUNCTIONS: DICE ROLLS (D6, D20, D100)
# Credit to kastian for proposing this re-write:)
RollDice() {
DICE=$((RANDOM%$1+1))
}

## GAME FUNCTIONS: MAP LOCATION (gps fix)
# Fixes LOCATION in CHARSHEET "A1" to a place on the MapNav "X1,Y1"
GPS_Fix() {
MAP_X_TMP=$(grep 'LOCATION:' "$CHARSHEET" | sed 's/LOCATION: //g' | cut -c 1-1)
case "$MAP_X_TMP" in
 A ) MAP_X=1 ;;
 B ) MAP_X=2 ;;
 C ) MAP_X=3 ;;
 D ) MAP_X=4 ;;
 E ) MAP_X=5 ;;
 F ) MAP_X=6 ;;
 G ) MAP_X=7 ;;
 H ) MAP_X=8 ;;
 I ) MAP_X=9 ;;
 J ) MAP_X=10 ;;
 K ) MAP_X=11 ;;
 L ) MAP_X=12 ;;
 M ) MAP_X=13 ;;
 N ) MAP_X=14 ;;
 O ) MAP_X=15 ;;
 P ) MAP_X=16 ;;
 Q ) MAP_X=17 ;;
 R ) MAP_X=18 ;;
esac
unset MAP_X_TMP

MAP_Y=$(grep 'LOCATION:' "$CHARSHEET" | sed 's/LOCATION: .//g')
MAP_Y_TMP=$(( MAP_Y+2 ))

SCENARIO=$(sed -n "${MAP_Y_TMP}p" "$MAP" | sed 's/...)//g' | tr -d " " | cut -c $MAP_X-$MAP_X)
}

# Translate MAP_X numeric back to A-R
TranslatePosition() {
case "$MAP_X" in
1 ) MAP_X="A" ;;
2 ) MAP_X="B" ;;
3 ) MAP_X="C" ;;
4 ) MAP_X="D" ;;
5 ) MAP_X="E" ;;
6 ) MAP_X="F" ;;
7 ) MAP_X="G" ;;
8 ) MAP_X="H" ;;
9 ) MAP_X="I" ;;
10 ) MAP_X="J" ;;
11 ) MAP_X="K" ;;
12 ) MAP_X="L" ;;
13 ) MAP_X="M" ;;
14 ) MAP_X="N" ;;
15 ) MAP_X="O" ;;
16 ) MAP_X="P" ;;
17 ) MAP_X="Q" ;;
18 ) MAP_X="R" ;;
esac
}

## GAME FUNCTIONS: ITEMS IN LOOP
ItemWasFound() {
case "$CHAR_ITEMS" in
0 ) GX_Item0 ;;					# Gift of Sight (set in MapNav)
1 ) (( HEALING++ )) && GX_Item1 ;;	# Emerald of Narcolepsy (set now & setup)
2 ) GX_Item2 ;;					# Guardian Angel (set in battle loop)
3 ) (( FLEE++ )) && GX_Item3 ;; # Fast Magic Boots (set now & setup)
4 ) GX_Item4 ;;					# Quick Rabbit Reaction (set in battle loop)
5 ) GX_Item5 ;;					# Flask of Terrible Odour (set in battle loop)
6 ) (( STRENGTH++ )) && GX_Item6 ;;	# Two-Handed Broadsword	(set now & setup)
7 | *) (( ACCURACY++ )) && GX_Item7 ;;	# Steady Hand Brew (set now & setup)
esac

COUNTDOWN=180
while (( COUNTDOWN > 0 )); do
GX_Item$CHAR_ITEMS
echo "                      Press any letter to continue  ($COUNTDOWN)" && read -sn 1 -t 1 SKIP
if [ -z "$SKIP" ]; then
	((COUNTDOWN--))
else
	COUNTDOWN=$(( COUNTDOWN-180 ))
fi
done
unset SKIP

# Remove the item that is found from the world
i=0
while (( i < 7 )); do
	if [ "$HERE_STR" = "${HOTZONE[$i]}" ] ; then
		HOTZONE[$i]="20-20"
	fi
	((i++))
done

(( CHAR_ITEMS++ )) 

# BUGFIX: re-distribute items to increase randomness. Fix to avoid items
# previously shown still there (but hidden) after a diff item was found..
HotzonesDistribute

# Save CHARSHEET items
SaveCurrentSheet

if [ -n "$ITEM2C_prev" ] && [ "$HERE_STR" = "$ITEM2C_prev" ] ; then
	MapCreate		# makes sure $SCENARIO isn't invalid $ symbol
	GPS_Fix			# fetch the correct $SCENARIO from updated map
fi

DICE=99      		# no fighting if item is found..
}

LookForItem() {
# Checks current section HERE_STR for treasure
HERE_STR="$MAP_X-$MAP_Y"
for zoneS in "${HOTZONE[@]}" ; do
	if [ "$zoneS" = "$HERE_STR" ] ; then
       	ItemWasFound
    fi
done
}


## GAME ACTION: MAP + MOVE
MapNav() {
if [ -z "$1" ] ; then	# If empty = toggle map (m) was pressed, else just move!
	clear # Don't remove this
	# Check for Gift of Sight
	if (( CHAR_ITEMS == 0 )); then
		GX_Map
	elif (( CHAR_ITEMS > 7 )); then
		GX_Map
	else
		GX_MapSight
	fi
	if (( COLOR == 1 )); then
		echo -en " \033[1;33mo $CHAR\033[0m is currently in $CHAR_GPS"
	else
		echo -en " o $CHAR is currently in $CHAR_GPS"
	fi
	case "$SCENARIO" in
	H ) echo -e " (Home)" ;;
	x ) echo -e " (Mountain)" ;;
	. ) echo -e " (Road)" ;;
	T ) echo -e " (Town)" ;;
	@ ) echo -e " (Forest)" ;;
	C ) echo -e " (Oldburg Castle)" ;;
	esac
	echo "$HR"
	echo -en " I want to go   (W) North  (A) West  (S)outh  (D) East  (Q)uit  :  "
	read -sn 1 DEST
else
	# The player did NOT toggle map, just moved without looking from action bar..
	DEST="$1"
	case "$SCENARIO" in	# Shows the _current_ scenario scene, not the destination's.
	H ) GX_Home ;;
	T ) GX_Town ;;
	@ ) GX_Forest ;;
	x ) GX_Mountains ;;
	. ) GX_Road ;;
	C ) GX_Castle ;;
	Z | * ) clear && echo "Whoops! There is an error with your map file!"
	echo "Either it contains unknown characters or it uses incorrect whitespace."
	echo "Recognized characters are: x . T @ H C"
	echo -e "Please run game with --map argument to create a new template as a guide.\n"
	CustomMapError
	;;
	esac
fi
case "$DEST" in
w | W | n | N ) # Going North (Reversed: Y-1)
	echo -en "You go North"
	if (( (MAP_Y-1) < 1 )); then
		echo -e "\nYou wanted to visit Santa, but walked in a circle.." && sleep 3
	else
		(( MAP_Y-- ))
		TranslatePosition
		CHAR_GPS="$MAP_X$MAP_Y"
		SaveCurrentSheet
		sleep 1
	fi
	;;
d | D | e | E ) # Going East (X+1)
	echo -en "You go East"
	if (( (MAP_X+1) > 18 )); then
		echo -e "\nYou tried to go East of the map, but walked in a circle.." && sleep 3
	else
		(( MAP_X++ ))
		TranslatePosition
		CHAR_GPS="$MAP_X$MAP_Y"
		SaveCurrentSheet
		sleep 1
	fi
	;;
s | S ) # Going South (Reversed: Y+1)
	echo -en "You go South"
	if (( (MAP_Y+1) > 15 )); then
		echo -e "\nYou tried to go someplace warm, but walked in a circle.." && sleep 3
	else
		(( MAP_Y++ ))
		TranslatePosition
		CHAR_GPS="$MAP_X$MAP_Y"
		SaveCurrentSheet
		sleep 1
	fi		
	;;
a | A ) # Going West (X-1)
	echo -en "You go West"
	if (( (MAP_X-1) < 1 )); then
		echo -e "\nYou tried to go West of the map, but walked in a circle.." && sleep 3
	else
		(( MAP_X-- ))
		TranslatePosition
		CHAR_GPS="$MAP_X$MAP_Y"
		SaveCurrentSheet
		sleep 1
	fi
	;;
q | Q ) SaveCurrentSheet && CleanUp ;;
* ) echo -en "Loitering.." && sleep 2
esac
unset DEST
NewSection
}

# GAME ACTION: DISPLAY CHARACTER SHEET 
DisplayCharsheet() {
TodaysDate	# Fetches old world date format
if (( CHAR_KILLS >= 1 )); then
	MURDERSCORE=$(echo "scale=zero;100*$CHAR_KILLS/$CHAR_BATTLES" | bc -l) # kill/fight percentage
else
	MURDERSCORE=0
fi
GX_CharSheet
echo -en " Character:                 $CHAR"
case $CHAR_RACE in
	1 ) echo " (Human)" ;;
	2 ) echo " (Elf)" ;;
	3 ) echo " (Dwarf)" ;;
	4 ) echo " (Hobbit)" ;;
esac
echo " Health Points:             $CHAR_HEALTH"
echo " Experience Points:         $CHAR_EXP"
echo -en " Current Location:          $CHAR_GPS"
case "$SCENARIO" in
	H ) echo " (Home)" ;; 
	x ) echo " (Mountain)" ;;
	. ) echo " (Road)" ;;
	T ) echo " (Town)" ;;
	@ ) echo " (Forest)" ;;
	C ) echo " (Oldburg Castle)" ;;
esac
echo " Current Date:              $TODAYS_DATE_STR"
echo " Number of Battles:         $CHAR_BATTLES"
echo " Enemies Slain:             $CHAR_KILLS ($MURDERSCORE%)"
echo " Items found:               $CHAR_ITEMS of 8"
echo " Special Skills:            Healing $HEALING, Strength $STRENGTH, Accuracy $ACCURACY, Flee $FLEE"
echo -en "\n       (D)isplay Race Info       (R)est     (M)ap and Move     (Q)uit     "
read -sn 1 CHARSHEET_OPT
case "$CHARSHEET_OPT" in
	d | D ) GX_Races
		echo -en "\n                     (R)est     (M)ap and Move     (Q)uit     "
		read -sn1 CHARSHEET_OPT2
		case "$CHARSHEET_OPT2" in
		r | R ) Rest ;;
		m | M ) MapNav ;;
		q | Q | * ) SaveCurrentSheet && CleanUp ;;
		esac
		;;
	r | R ) Rest ;;
	m | M ) MapNav ;;
	q | Q | *) SaveCurrentSheet && CleanUp ;;
esac
}

# FIGHT MODE! (secondary loop for fights)
FightMode() {
LUCK=0		# Used to assess the match in terms of EXP..
FIGHTMODE=1	# Anti-cheat bugfix for CleanUp: Adds penalty for CTRL+C during fights!

# Determine enemy type
RollDice 20
case "$SCENARIO" in
H ) ENEMY="chthulu" ;; 
x ) if (( DICE <= 10 )); then
	ENEMY="orc"
    elif (( DICE >= 16 )); then
	ENEMY="goblin"
    else
	ENEMY="varg"
    fi
    ;;
. ) if (( DICE <= 12 )); then
	ENEMY="goblin"
    else
	ENEMY="bandit"
    fi
    ;;
T ) if (( DICE <= 15 )); then
	ENEMY="bandit"
    else
	ENEMY="mage"
    fi
    ;;
@ ) if (( DICE <= 8 )); then
	ENEMY="goblin"
    elif (( DICE >= 17 )); then
	ENEMY="orc"
    else
	ENEMY="bandit"
    fi
    ;;
C ) if (( DICE <= 5 )); then
	ENEMY="chthulu"
    else
	ENEMY="mage"
    fi
    ;;
esac
GX_Monster_$ENEMY

# ENEMY ATTRIBUTES; If you want to tune/balance the fights do it here!
case "$ENEMY" in
orc ) EN_STRENGTH=4 && EN_ACCURACY=4 && EN_FLEE=4 && EN_HEALTH=80 && EN_FLEE_THRESHOLD=40 ;;		# EN_FLEE_THRESHOLD
goblin ) EN_STRENGTH=3 && EN_ACCURACY=3 && EN_FLEE=5 && EN_HEALTH=30 && EN_FLEE_THRESHOLD=15 ;;		# At what Health will enemy flee?
bandit )EN_STRENGTH=2 && EN_ACCURACY=4 && EN_FLEE=7 && EN_HEALTH=30 && EN_FLEE_THRESHOLD=18 ;;
mage ) EN_STRENGTH=5 && EN_ACCURACY=3 && EN_FLEE=4 && EN_HEALTH=90 && EN_FLEE_THRESHOLD=45 ;;
varg ) EN_STRENGTH=4 && EN_ACCURACY=3 && EN_FLEE=3 && EN_HEALTH=80 && EN_FLEE_THRESHOLD=60 ;;
chthulu ) EN_STRENGTH=6 && EN_ACCURACY=5 && EN_FLEE=1 && EN_HEALTH=500 && EN_FLEE_THRESHOLD=350 ;;	# :)
esac
sleep 2

# Adjustments for items
if (( CHAR_ITEMS >= 5 )); then
	(( ACCURACY++ )) # item4: Quick Rabbit Reaction
fi

if (( CHAR_ITEMS >= 6 )); then
	(( EN_FLEE++ )) # item5: Flask of Terrible Odour
fi

# DETERMINE INITIATIVE (will usually be enemy)
if (( EN_ACCURACY > ACCURACY )); then
	echo "The $ENEMY has initiative" && sleep 2
	NEXT_TURN="en"
else
	echo "$CHAR has the initiative!"
<<<<<<< HEAD
	echo -en "\n\t\t   Press any key to fight or (F) to Flee"
	read -sn 1 FLEE_OPT
	case "$FLEE_OPT" in
		f | F ) echo -e "\nTrying to slip away unseen.. (Flee: $FLEE)"
		RollDice 6
		if (( DICE <= FLEE )); then
			echo "You rolled $DICE and managed to run away!" && sleep 3
			FIGHTMODE=0
			MapNav
		else
			echo "You rolled $DICE and lost your initiative.." && sleep 3
=======
	echo -en "\n                            (F)ight or (E)scape?           "
	read -sn 1 FLEE_OPT
	case "$FLEE_OPT" in
		e | E ) echo -e "\nTrying to escape.. (Flee: $FLEE)"
		RollDice 6
		if (( DICE <= FLEE )); then
			echo "You rolled $DICE and managed to run away!" && sleep 2
			FIGHTMODE=0
			MapNav
		else
			echo "You rolled $DICE and lost your initiative.." && sleep 2
>>>>>>> 1813685971b8991e5779e5ab65a6dba945314655
			NEXT_TURN="en"
		fi
		;;
		* ) NEXT_TURN="pl" ;;
	esac

fi

if (( CHAR_ITEMS >= 5 )); then
	(( ACCURACY--))	# Resets Quick Rabbit Reaction setting..
fi




# GAME LOOP: FIGHT LOOP
while (( EN_HEALTH > 0 ))
do
	if (( CHAR_HEALTH <= 0 )); then
		echo -e "\nYour health points are $CHAR_HEALTH" && sleep 2
		echo "You WERE KILLED by the $ENEMY, and now you are dead..." && sleep 2
		if (( CHAR_EXP >= 1000 )) && (( CHAR_HEALTH < -5 )) && (( CHAR_HEALTH > -15 )); then
			echo "However, your $CHAR_EXP Experience Points relates that you have"
			echo "learned many wondrous and magical things in your travels..!"
			echo "+20 HEALTH: Health Restored to 20"
			CHAR_HEALTH=20
			LUCK=2 && EN_HEALTH=0
			sleep 8
			break	# bugfix: Resurrected player could continue fighting
		else
			if (( CHAR_ITEMS >= 3 )) && (( CHAR_HEALTH >= -5 )); then
				echo "Suddenly you awake again, SAVED by your Guardian Angel!"
				echo "+5 HEALTH: Health Restored to 5"
				CHAR_HEALTH=5
				EN_HEALTH=0
				LUCK=2
				sleep 8
				break # bugfix: Resurrected player could continue fighting..
			else
				# DEATH!
				echo "Gain 1000 Experience Points to achieve magic healing!" && sleep 4
				case "$CHAR_RACE" in
					1 ) FUNERAL_RACE="human" ;;
					2 ) FUNERAL_RACE="elf" ;;
					3 ) FUNERAL_RACE="dwarf" ;;
					4 ) FUNERAL_RACE="hobbit" ;;
				esac
				TodaysDate		# Fetch today's date in Warhammer calendar
				COUNTDOWN=20
				while (( COUNTDOWN >= 0 )); do
					GX_Death
					echo " The $TODAYS_DATE_STR:"
					echo " In such a short life, this sorry $FUNERAL_RACE gained $CHAR_EXP Experience Points."
					echo " We honor $CHAR with $COUNTDOWN secs silence." && read -sn 1 -t 1 SKIP_FUNERAL
					if [ -z "$SKIP_FUNERAL" ]; then
						((COUNTDOWN--))
					else
						COUNTDOWN=$(( COUNTDOWN-20 ))
					fi
				done
				unset SKIP_FUNERAL
				# overwrite or update highscore
				if grep -q 'd41d8cd98f00b204e9800998ecf8427e' "$HIGHSCORE" ; then
					echo "$CHAR_EXP;$CHAR;$CHAR_RACE;$CHAR_BATTLES;$CHAR_KILLS;$CHAR_ITEMS;$TODAYS_DATE;$TODAYS_MONTH;$TODAYS_YEAR" > "$HIGHSCORE"
				else
					echo "$CHAR_EXP;$CHAR;$CHAR_RACE;$CHAR_BATTLES;$CHAR_KILLS;$CHAR_ITEMS;$TODAYS_DATE;$TODAYS_MONTH;$TODAYS_YEAR" >> "$HIGHSCORE"
				fi
				rm -f "$CHARSHEET"			# A sense of loss is important for gameplay:)
				unset CHARSHEET				# Zombie fix
				unset CHAR
				unset CHAR_RACE
				unset CHAR_HEALTH
				unset CHAR_EXP
				unset CHAR_GPS
				unset SCENARIO
				unset CHAR_BATTLES
				unset CHAR_KILLS
				unset CHAR_ITEMS
				FIGHTMODE=0 && DEATH=1	&& EN_HEALTH=0 && break 	# Zombie fix
			fi
		fi
	fi
	GX_Monster_$ENEMY
	echo -e "${SHORTNAME^}\t\tHEALTH: $CHAR_HEALTH\tStrength: $STRENGTH\tAccuracy: $ACCURACY" | tr '_' ' '
	echo -e "${ENEMY^}\t\t\tHEALTH: $EN_HEALTH\tStrength: $EN_STRENGTH\tAccuracy: $EN_ACCURACY"
	if [ "$NEXT_TURN" = "pl" ] ; then
		# Player's turn
<<<<<<< HEAD
		echo -en "\nIt's your turn, press any key to (R)oll or (F) to Flee" && read -sn 1 "FIGHT_PROMPT"
=======
		echo -en "\nIt's your turn, press the R key to (R)oll" && read -sn 1 # "FIGHT_PROMPT" # Bugfix: repeated keys [shellcheck didn't like these]
>>>>>>> 1813685971b8991e5779e5ab65a6dba945314655
		RollDice 6
		GX_Monster_$ENEMY
		echo -e "${SHORTNAME^}\t\tHEALTH: $CHAR_HEALTH\tStrength: $STRENGTH\tAccuracy: $ACCURACY" | tr '_' ' '
		echo -e "${ENEMY^}\t\t\tHEALTH: $EN_HEALTH\tStrength: $EN_STRENGTH\tAccuracy: $EN_ACCURACY"
		echo -en "\nROLL D6: $DICE"
<<<<<<< HEAD
		if [ "$FIGHT_PROMPT" = "f" ] || [ "$FIGHT_PROMPT" = "F" ] ; then
			unset FIGHT_PROMPT
			# Player tries to flee!
			if (( DICE <= FLEE )); then
				echo -e "\tFlee [D6 $DICE < FLEE] You managed to flee!"
				EN_HEALTH=0
				LUCK=3
				sleep 3
				break
			else
				echo -e "\tFlee [D6 $DICE > $FLEE] Your escape was ill-fated!"
				NEXT_TURN="en" && sleep 2
			fi
		else
			# Player fights
			unset FIGHT_PROMPT
			if (( DICE <= ACCURACY )); then
				echo -e "\tAccuracy [D6 $DICE < $ACCURACY] Your weapon hits the target!"
				echo -en "Press the R key to (R)oll for damage" && read -sn 1 "FIGHT_PROMPT"
				RollDice 6
				echo -en "\nROLL D6: $DICE"
				DAMAGE=$(( DICE*STRENGTH ))
				echo -en "\tYour blow dishes out $DAMAGE damage points!"
				EN_HEALTH=$(( EN_HEALTH-DAMAGE ))
				unset FIGHT_PROMPT
				if (( EN_HEALTH <= 0 )); then
					sleep 1 # extra pause here..
				fi	
				NEXT_TURN="en" && sleep 3
			else
				echo -e "\tAccuracy [D6 $DICE > $ACCURACY] You missed!"
				NEXT_TURN="en" && sleep 2
			fi
=======
		unset FIGHT_PROMPT # Bugfix: repeated keys
		if (( DICE <= ACCURACY )); then
			echo -e "\tAccuracy [D6 $DICE < $ACCURACY] Your weapon hits the target!"
			echo -en "Press the R key to (R)oll for damage" && read -sn 1 # "FIGHT_PROMPT" # Bugfix: repeated keys [shellcheck didn't like these]
			RollDice 6
			echo -en "\nROLL D6: $DICE"
			DAMAGE=$(( DICE*STRENGTH ))
			echo -en "\tYour blow dishes out $DAMAGE damage points!"
			EN_HEALTH=$(( EN_HEALTH-DAMAGE ))
			unset FIGHT_PROMPT # Bugfix: repeated keys
			if (( EN_HEALTH <= 0 )); then
				sleep 2 # extra pause here..
			fi
			NEXT_TURN="en" && sleep 3

		else
			echo -e "\tAccuracy [D6 $DICE > $ACCURACY] You missed!"
			NEXT_TURN="en" && sleep 2
>>>>>>> 1813685971b8991e5779e5ab65a6dba945314655
		fi
	else
		# Enemy's turn
		echo -en "\nIt's the $ENEMY's turn" && sleep 2
		RollDice 6
		if (( DICE <= EN_ACCURACY )); then
			echo -en "\nAccuracy [D6 $DICE < $EN_ACCURACY] The $ENEMY strikes you!"
			RollDice 6
			DAMAGE=$(( DICE*EN_STRENGTH ))
			echo -en "\n-$DAMAGE HEALTH: The $ENEMY's blow hits you with $DAMAGE points!"
			CHAR_HEALTH=$(( CHAR_HEALTH-DAMAGE ))
			SaveCurrentSheet
			NEXT_TURN="pl" && sleep 3
		else
			echo -e "\nAccuracy [D6 $DICE > $EN_ACCURACY] The $ENEMY misses!"
			NEXT_TURN="pl" && sleep 2
		fi
	fi
	if [ "$NEXT_TURN" = "en" ] ; then
		if (( EN_HEALTH > 0 )) && (( EN_HEALTH < EN_FLEE_THRESHOLD )) && (( EN_HEALTH < CHAR_HEALTH )); then
			GX_Monster_$ENEMY
			echo -e "${SHORTNAME^}\t\tHEALTH: $CHAR_HEALTH\tStrength: $STRENGTH\tAccuracy: $ACCURACY" | tr '_' ' '
			echo -e "${ENEMY^}\t\t\tHEALTH: $EN_HEALTH\tStrength: $EN_STRENGTH\tAccuracy: $EN_ACCURACY"
			RollDice 20
			echo -e "\nRolling for enemy flee: D20 < $EN_FLEE" && sleep 2
			if (( DICE < EN_FLEE )); then
				echo -en "ROLL D20: $DICE"
				echo -e "\tThe $ENEMY uses an opportunity to flee!"
				LUCK=1 && EN_HEALTH=0
				sleep 2
			fi
		fi
	fi	
done

if (( DEATH == 1 )); then
	HighScore # zombie fix
else
	# VICTORY!
	if (( LUCK == 2 )); then
		# died but saved by guardian angel or 1000 EXP
		echo "When you come to, the $ENEMY has left the area ..."
	else
		if (( LUCK == 1 )); then
<<<<<<< HEAD
			# ENEMY managed to FLEE
=======
			# ENEMY ran away
>>>>>>> 1813685971b8991e5779e5ab65a6dba945314655
			echo -en "You defeated the $ENEMY and gained"
			case "$ENEMY" in
				bandit ) echo " 10 Experience Points!" && CHAR_EXP=$(( CHAR_EXP+10 )) ;;
				goblin ) echo " 15 Experience Points!" && CHAR_EXP=$(( CHAR_EXP+15 )) ;;
				orc ) echo " 25 Experience Points!" && CHAR_EXP=$(( CHAR_EXP+25 )) ;;
				varg ) echo " 50 Experience Points!" && CHAR_EXP=$(( CHAR_EXP+50 )) ;;
				mage ) echo " 75 Experience Points!" && CHAR_EXP=$(( CHAR_EXP+75 )) ;;
				chthulu ) echo "500 Experience Points!" && CHAR_EXP=$(( CHAR_EXP+500 )) ;;
			esac
		else
<<<<<<< HEAD
			if (( LUCK == 3 )); then
				# PLAYER manged to FLEE during fight!
				echo -en "You got away while the $ENEMY wasn't looking, gaining"
				case "$ENEMY" in
					bandit ) echo " 6 Experience Points!" && CHAR_EXP=$(( CHAR_EXP+5 )) ;;
					goblin ) echo " 7 Experience Points!" && CHAR_EXP=$(( CHAR_EXP+10 )) ;;
					orc ) echo " 13 Experience Points!" && CHAR_EXP=$(( CHAR_EXP+15 )) ;;
					varg ) echo " 25 Experience Points!" && CHAR_EXP=$(( CHAR_EXP+25 )) ;;
					mage ) echo " 38 Experience Points!" && CHAR_EXP=$(( CHAR_EXP+35 )) ;;
					chthulu ) echo "200 Experience Points!" && CHAR_EXP=$(( CHAR_EXP+200 )) ;;
				esac
			else
				# ENEMY was slain!
				GX_Monster_$ENEMY
				echo -e "${SHORTNAME^}\t\tHEALTH: $CHAR_HEALTH\tStrength: $STRENGTH\tAccuracy: $ACCURACY" | tr '_' ' '
				echo -e "${ENEMY^}\t\t\tHEALTH: $EN_HEALTH\tStrength: $EN_STRENGTH\tAccuracy: $EN_ACCURACY"
				echo -en "\nYou defeated the $ENEMY and gained"
				case "$ENEMY" in
					bandit ) echo " 20 Experience Points!" && CHAR_EXP=$(( CHAR_EXP+20 )) ;;
					goblin ) echo " 30 Experience Points!" && CHAR_EXP=$(( CHAR_EXP+30 )) ;;
					orc ) echo " 50 Experience Points!" && CHAR_EXP=$(( CHAR_EXP+50 )) ;;
					varg ) echo " 100 Experience Points!" && CHAR_EXP=$(( CHAR_EXP+100 )) ;;
					mage ) echo " 150 Experience Points!" && CHAR_EXP=$(( CHAR_EXP+150 )) ;;
					chthulu ) echo "1000 Experience Points!" && CHAR_EXP=$(( CHAR_EXP+1000 )) ;;
				esac
				(( CHAR_KILLS++ ))
			fi
=======
			# enemy was slain!
			GX_Monster_$ENEMY
			echo -e "${SHORTNAME^}\t\tHEALTH: $CHAR_HEALTH\tStrength: $STRENGTH\tAccuracy: $ACCURACY" | tr '_' ' '
			echo -e "${ENEMY^}\t\t\tHEALTH: $EN_HEALTH\tStrength: $EN_STRENGTH\tAccuracy: $EN_ACCURACY"
			echo -en "\nYou defeated the $ENEMY and gained"
			case "$ENEMY" in
				bandit ) echo " 20 Experience Points!" && CHAR_EXP=$(( CHAR_EXP+20 )) ;;
				goblin ) echo " 30 Experience Points!" && CHAR_EXP=$(( CHAR_EXP+30 )) ;;
				orc ) echo " 50 Experience Points!" && CHAR_EXP=$(( CHAR_EXP+50 )) ;;
				varg ) echo " 100 Experience Points!" && CHAR_EXP=$(( CHAR_EXP+100 )) ;;
				mage ) echo " 150 Experience Points!" && CHAR_EXP=$(( CHAR_EXP+150 )) ;;
				chthulu ) echo "1000 Experience Points!" && CHAR_EXP=$(( CHAR_EXP+1000 )) ;;
			esac
			(( CHAR_KILLS++ ))
>>>>>>> 1813685971b8991e5779e5ab65a6dba945314655
		fi
	fi
	FIGHTMODE=0
	(( CHAR_BATTLES++ ))
	SaveCurrentSheet
<<<<<<< HEAD
	unset LUCK
=======
>>>>>>> 1813685971b8991e5779e5ab65a6dba945314655
	sleep 4
	DisplayCharsheet
fi
}

RollForHealing() {
# For use in Rest
RollDice 6
echo "Rolling for healing: D6 <= $HEALING"
echo "ROLL D6: $DICE"
}


# GAME ACTION: REST
# Game balancing can also be done here, if you think players receive too much/little health by resting.
Rest() {
RollDice 100
GX_Rest
case "$SCENARIO" in
H ) if (( CHAR_HEALTH <= 100 )); then
		CHAR_HEALTH=100
		echo "You slept well in your own bed. Health restored to 100."
	else
		echo "You slept well in your own bed, and woke up to a beautiful day."
    fi
    sleep 2
    ;;
x ) echo "Rolling for event: D100 <= 60" && echo "ROLL D100: $DICE" && sleep 2
    if (( DICE <= 60 )); then
	FightMode
    	else
		RollForHealing
		if (( DICE <= HEALING )); then
			CHAR_HEALTH=$(( CHAR_HEALTH+5 ))
			echo "You slept well and gained 5 Health."
				else
			echo "The terrors of the mountains kept you awake all night.."
		fi
		sleep 2
	fi ;;
. ) echo "Rolling for event: D100 <= 30" && echo "ROLL D100: $DICE" && sleep 2
    if (( DICE <= 30 )); then
	FightMode
    	else
		RollForHealing
		if (( DICE <= HEALING )); then
			CHAR_HEALTH=$(( CHAR_HEALTH+10 ))
			echo "You slept well and gained 10 Health."
				else
			echo "The dangers of the roads gave you little sleep if any.."
		fi
		sleep 2
	fi ;;
T ) echo "Rolling for event: D100 <= 15" && echo "ROLL D100: $DICE" && sleep 2
    if (( DICE <= 15 )); then
	FightMode
    	else
		RollForHealing
		if (( DICE <= HEALING )); then
			CHAR_HEALTH=$(( CHAR_HEALTH+15 ))
			echo "You slept well and gained 15 Health."
				else
			echo "The vices of town life kept you up all night.."
		fi
		sleep 2
	fi ;;
@ ) echo "Rolling for event: D100 <= 35" && echo "ROLL D100: $DICE" && sleep 2
    if (( DICE <= 35 )); then
	FightMode
    	else
		RollForHealing
		if (( DICE <= HEALING )); then
			CHAR_HEALTH=$(( CHAR_HEALTH+5 ))
			echo "You slept well and gained 5 Health."
				else
			echo "Possibly dangerous wood owls kept you awake all night.."
		fi
		sleep 2
	fi ;;
C ) echo "Rolling for event: D100 <= 5" && echo "ROLL D100: $DICE" && sleep 2
    if (( DICE <= 5 )); then
	FightMode
    	else
		RollForHealing
		if (( DICE <= HEALING )); then
			CHAR_HEALTH=$(( CHAR_HEALTH+35 ))
			echo "You slept well and gained 35 Health."
				else
			echo "Rowdy castle soldiers on a drinking binge kept you awake.."
		fi
		sleep 2
	fi ;;
esac
sleep 2
MapNav
}


# GAME ACTIONS MENU BAR
ActionsBar() {
	echo -en "          (C)haracter     (R)est     (M)ap and Travel     (Q)uit   "
	read -sn 1 ACTION
	case "$ACTION" in
		c | C ) DisplayCharsheet ;;
		r | R ) Rest ;;
		q | Q ) SaveCurrentSheet && CleanUp ;;
		m | M ) MapNav ;;	# go to Map then move
		* ) MapNav "$ACTION" ;;	# Move directly (if not WASD, then loitering :)
	esac
}



# THE GAME LOOP
NewSection() {
# Check whether there will be blood or not (DICE vs. SCENARIO below)
# No fighting if first sector after starting a new/load game!
if (( NEWGAME==1 )); then
	DICE=99
	NEWGAME=0
else
	RollDice 100
fi

# Find out where we are
GPS_Fix

# Look for treasure @ current GPS location
if (( CHAR_ITEMS < 8 )); then
	LookForItem
fi

# Find out if we're attacked, else just disp scenario GFX
case "$SCENARIO" in
H ) GX_Home
	echo "Rolling for event: D100 = 66"
	echo "D100: $DICE" && sleep 2
	if (( DICE == 66 )); then
		FightMode
	else
		GX_Home
		CHAR_HEALTH=100
	fi
	;;
x ) GX_Mountains
	echo "Rolling for event: D100 <= 50"
	echo "D100: $DICE" && sleep 2
	if (( DICE <= 50 )); then
		FightMode
	else
		GX_Mountains
	fi
	;;
. ) GX_Road
	echo "Rolling for event: D100 <= 20"
	echo "D100: $DICE" && sleep 2
	if (( DICE <= 20 )); then
		FightMode
	else
		GX_Road
	fi
	;;
T ) GX_Town
	echo "Rolling for event: D100 <= 15"
	echo "D100: $DICE" && sleep 2
	if (( DICE <= 15 )); then
		FightMode
	else
		GX_Town
	fi
	;;
@ ) GX_Forest
	echo "Rolling for event: D100 <= 35"
	echo "D100: $DICE" && sleep 3
	if (( DICE <= 35 )); then
		FightMode
	else
		GX_Forest
	fi	
	;;
C ) GX_Castle
	echo "Rolling for event: D100 <= 10"
	echo "D100: $DICE" && sleep 2
	if (( DICE <= 10 )); then
		FightMode
	else
		GX_Castle
	fi
	;;
Z |* )  clear
        echo "Whoops! There is an error with your map file!"
	echo "Either it contains unknown characters or it uses incorrect whitespace."
	echo "Recognized characters are: x . T @ H C"
	echo -e "Please run game with --map argument to create a new template as a guide.\n"
	CustomMapError
	;;
esac
# Display Menu
ActionsBar
}

# Create FIGHT CHAR name
CosmeticName() {
SHORTNAME="$CHAR"
SHORTNAME_LENGTH="${#SHORTNAME}"
if (( SHORTNAME_LENGTH <= 7 )); then
	SPACER="_"
	while (( SHORTNAME_LENGTH <= 12 ))
	do
		SHORTNAME="$SHORTNAME$SPACER"
		SHORTNAME_LENGTH="${#SHORTNAME}"

	done
else
	SHORTNAME=$(echo "$SHORTNAME" | cut -c 1-15)
fi
}

# Intro function basically gets the game going
Intro() {
CosmeticName 		# Cosmetic name for fight loop
HotzonesDistribute 	# Place items randomly in map
COUNTDOWN=60
while [ $COUNTDOWN -ge 0 ]; do
GX_Intro
echo "                        Press any letter to continue" && read -sn 1 -t 1 SKIP
if [ -z "$SKIP" ]; then
	((COUNTDOWN--))
else
	COUNTDOWN=$(( COUNTDOWN-61 ))
fi
done
unset SKIP

# DEBUG Display HOTZONEs
# Please Leave commented, has ill-effect on gameplay!)
#clear
#echo "Echo HOTZONEs"
#i=0
#while (( i <= 7 )) ; do
#	echo -e ""$i". ${HOTZONE[$i]}"
#	((i++))
#done
#read -sn 1
#DEBUG

NEWGAME=1 # Do not roll on first section after loading/starting a game

NewSection
}


Announce() {
# Simply outputs a 160 char text you can cut & paste to social media.
# I was gonna use pump.io for this, but too much hassle && dependencies..

SetupHighscore
if grep -q 'd41d8cd98f00b204e9800998ecf8427e' "$HIGHSCORE" ; then
	echo "Sorry, can't do that just yet!"
	echo "The highscore list is unfortunately empty right now."
	exit
else
	echo -e "TOP 10 BACK IN A MINUTE HIGHSCORES\n"
	SCORES_2_DISPLAY=10
	HighscoreRead
	echo -en "\nSelect the highscore (1-10) you'd like to display or CTRL+C to cancel: " && read SCORE_TO_PRINT
	if (( SCORE_TO_PRINT >= 1 )) && (( SCORE_TO_PRINT <= 10 )); then
		ANNOUNCEMENT_TMP=$(mktemp "$GAMEDIR/hello.XXXXXX")
		sed -n "${SCORE_TO_PRINT}","${SCORE_TO_PRINT}"p "$HIGHSCORE" > "$ANNOUNCEMENT_TMP"
		RollDice 6
		case $DICE in
		1 ) ADJECTIVE="honorable" ;;
		2 ) ADJECTIVE="fearless" ;;
		3 ) ADJECTIVE="courageos" ;;
		4 ) ADJECTIVE="brave" ;;
		5 ) ADJECTIVE="legendary" ;;
		6 ) ADJECTIVE="heroic" ;;
		esac
		while IFS=";" read -r highEXP highCHAR highRACE highBATTLES highKILLS highITEMS highDATE highMONTH highYEAR; do
			case $highRACE in
				1 ) highRACE="Human" ;;
				2 ) highRACE="Elf" ;;
				3 ) highRACE="Dwarf" ;;
				4 ) highRACE="Hobbit" ;;
			esac
			if (( highBATTLES == 1 )); then
				highBATTLES_STR="battle"
			else
				highBATTLES_STR="battles"
			fi
			if (( highITEMS == 1 )); then
				highITEMS_STR="item"
			else
				highITEMS_STR="items"
			fi
		highCHAR=${highCHAR^}
		ANNOUNCEMENT="$highCHAR fought $highBATTLES $highBATTLES_STR, $highKILLS victoriously, won $highEXP EXP and $highITEMS $highITEMS_STR. This $ADJECTIVE $highRACE was finally slain the $highDATE of $highMONTH in the $highYEARth Cycle."
		done < "$ANNOUNCEMENT_TMP"
		rm -f "$ANNOUNCEMENT_TMP" && unset ANNOUNCEMENT_TMP
		echo -en "\n"
		ANNOUNCEMENT_LENGHT="${#ANNOUNCEMENT}"
		GX_HighScore
		echo "ADVENTURE SUMMARY to copy and paste to your social media of choice:"
		echo -e "\n$ANNOUNCEMENT\n"
		echo -e "$HR\n"
		if (( ANNOUNCEMENT_LENGHT > 160 )); then
			echo "Warning! String longer than 160 chars ($ANNOUNCEMENT_LENGHT)!"
		fi
		exit
	else
		echo -e "\nOut of range. Please select an entry between 1-10. Quitting.." && exit
	fi
fi
}

# Used in CONFIG generation below..
NoWriteOnGamedir() {
echo "ERROR! You do not have write permissions for $GAMEDIR.." && exit
}

ColorConfig() {
echo -e "\nWe need to configure terminal colors for the map!\nPlease note that a colored symbol is easier to see on the world map.\nBack in a minute was designed for white text on black background."
echo -e "Does \033[1;33mthis text appear yellow\033[0m without any funny characters?\n" && echo -en "Do you want color? No to DISABLE, Yes or ENTER to ENABLE color: " && read COLOR_CONFIG
case "$COLOR_CONFIG" in
	N | n | NO | No | no | DISABLE | disable ) COLOR=0 && echo -e "Disabling color! Edit $GAMEDIR/config to change this setting." && sed -i 's/COLOR: NA/COLOR: 0/g' "$GAMEDIR/config" ;;
	* ) COLOR=1 && echo "Enabling color!" && sed -i 's/COLOR: NA/COLOR: 1/g' "$GAMEDIR/config" ;;
esac
sleep 2
}
		        
CreateBiaminLauncher() {
BIAMIN_RUNTIME=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )	# TODO $0 is a powerful beast, but will sometimes fail..
echo "This will add $BIAMIN_RUNTIME/biamin.sh to your .bashrc"
echo -en "Install Biamin Launcher? [Y/N]: " && read -n 1 LAUNCHER
case "$LAUNCHER" in
y | Y ) LAUNCHER=1 ;;
* ) LAUNCHER=0 ;;
esac
if (( LAUNCHER == 1 )) ; then
	if grep -q 'biamin.sh' "$HOME/.bashrc" ; then
		echo -e "\nFound existing launcher in $HOME/.bashrc.. skipping!"
	else
		echo -e "\n# Back in a Minute Game Launcher (just run 'biamin')" >> "$HOME/.bashrc"
		echo "biamin() {" >> "$HOME/.bashrc"
		echo "$BIAMIN_RUNTIME/biamin.sh \"\$@\"" >> "$HOME/.bashrc"
		echo "}" >> "$HOME/.bashrc"
		echo -e "\nDone. Close and re-open BASH to test \"biamin\" command!"
	fi
else
	echo -e "\nDon't worry, not changing anything!"
fi
exit
}		        
		        

#                           END FUNCTIONS                              #       
#                                                                      #       
#                                                                      #
########################################################################





########################################################################       
#                                                                      #
#                        2. RUNTIME BLOCK                              #
#                   All running code goes here!                        #
									       


# Parse CLI arguments if any
case "$1" in
	--announce )   	Announce ;;
	--h | --help )	echo "Run the game BACK IN A MINUTE with '--play' or 'p' arguments to play!"
			echo "For usage: run biamin --usage"
			echo -e "\nCurrent dir for game files: $GAMEDIR/"
<<<<<<< HEAD
			echo "Change at runtime or on line 10 in the CONFIGURATION of the script."
			exit ;;
	--i | --install ) CreateBiaminLauncher ;;
	--map )         echo -en "Create custom map template? [Y/N] " && read -n1 CUSTOM_MAP_PROMPT
			if [ "$CUSTOM_MAP_PROMPT" = "y" ] || [ "$CUSTOM_MAP_PROMPT" = "Y" ]; then
				echo -e "\nCreating custom map template.."
				MapCreateCustom

=======
			echo "Change this setting on line 10 in the CONFIGURATION section of script."

			exit ;;
	--map )         echo -e "Create custom map template?"
			CUSTOM_MAP_PROMPT="Yes No"
			select OPT in "$CUSTOM_MAP_PROMPT"; do
			if [ "$OPT" = "Yes" ]; then
				echo "Creating custom map template.."
				break
			elif [ "$OPT" = "No" ]; then
				echo "Not doing anything! Quitting.."
				exit
>>>>>>> 1813685971b8991e5779e5ab65a6dba945314655
			else
				echo -e "\nNot doing anything! Quitting.."
				exit
<<<<<<< HEAD
			fi ;;
=======
			fi
			done
			MapCreateCustom ;;
>>>>>>> 1813685971b8991e5779e5ab65a6dba945314655
	--play | p ) 	echo "Launching Back in a Minute.." ;;
	
    --v | --version )	echo -e "BACK IN A MINUTE VERSION $VERSION Copyright (C) 2014 Sigg3.net"
			echo -e "\nGame SHELL CODE released under GNU GPL version 3 (GPLv3)."
			echo "This is free software: you are free to change and redistribute it."
			echo "There is NO WARRANTY, to the extent permitted by law."
			echo "For details see: <http://www.gnu.org/licenses/gpl-3.0>"
			echo -e "\nGame ARTWORK released under Creative Commons CC BY-NC-SA 4.0."
			echo "You are free to copy, distribute, transmit and adapt the work."
			echo "For details see: <http://creativecommons.org/licenses/by-nc-sa/4.0/>"
			echo -e "\nGame created by Sigg3. Submit bugs & feedback at <$WEBURL>"
			exit ;;
			
	--usage | * )	echo "Usage: biamin or ./biamin.sh"
            echo "  (NO ARGUMENTS)      display this usage text and exit"
            echo "  --play or p         PLAY the game \"Back in a minute\""
			echo "  --announce          DISPLAY an adventure summary for social media and exit"
<<<<<<< HEAD
			echo "  --install           ADD biamin.sh to your .bashrc file"
=======
>>>>>>> 1813685971b8991e5779e5ab65a6dba945314655
			echo "  --map               CREATE custom map template with instructions and exit"
			echo "  --help              display help text and exit"
			echo "  --usage             display this usage text and exit" 
			echo "  --version           display version and licensing info and exit"
			exit ;;
esac

# Check whether gamedir exists..
if [ -d "$GAMEDIR" ] && [ -f "$GAMEDIR/config" ] ; then
	echo "Putting on the traveller's boots.."
	COLOR=$(sed -n '/^COLOR:/s/COLOR: //p' "$GAMEDIR/config")
	GAMEDIR=$(sed -n '/^GAMEDIR:/s/GAMEDIR: //p' "$GAMEDIR/config")
else
<<<<<<< HEAD
	echo "Game directory default is $GAMEDIR/"
	echo "You can change this in $GAMEDIR/config. Creating directory.."
	mkdir -p "$GAMEDIR/" || NoWriteOnGamedir
	echo "GAMEDIR: $GAMEDIR" > "$GAMEDIR/config"
	echo "COLOR: NA" >> "$GAMEDIR/config"
fi

# Color configuration
COLOR=$(sed -n '/^COLOR:/s/COLOR: //p' "$GAMEDIR/config")
case "$COLOR" in
1 ) echo "Enabling color for maps!" ;;
0 )	echo "Enabling old black-and-white version!" ;;
* ) ColorConfig ;;
esac

=======
	# TODO create a function for creating game dir..? This is not critical.
	# IT MUST a) ask for permission to do so
	#		  b) ask for path
	#		  c) copy itself "biamin.sh" to the path in b)
	#		  d) change line 10 in CONFIGURATION to reflect b)
	#		  e) exit itself and launch new gamedir's biamin.sh..!
	echo "Please create $GAMEDIR/ directory before running" && exit
fi

# Color configuration
if [ -f "$GAMEDIR/color" ] ; then
	read COLOR < "$GAMEDIR/color"
	if [ "$COLOR" = "ENABLE" ] ; then
		COLOR=1
		echo "Enabling color for maps!"
	elif [ "$COLOR" = "DISABLE" ] ; then
		COLOR=0
		echo "Enabling old black-and-white version!"
	else
		rm -f "$GAMEDIR/color"
		echo "Color config is faulty. Please run biamin again to configure colors!"
		exit
	fi
else
	echo "We need to configure terminal colors for the map!"
	echo "Note: A symbol that is colored is easier to see on the world map!"
	echo "Back in a minute was designed for white text on black background."
	echo -e "Does \033[1;33mthis text appear yellow\033[0m without any funny characters?"
	echo "Hit 1 for YES (enable color) and 2 for NO (disable color)."
	COLOR_CONFIG="Enable Disable"
	select OPT in "$COLOR_CONFIG"; do
	if [ "$OPT" = "Enable" ]; then
		echo "Enabling color!"
		COLOR=1
		echo "ENABLE" > "$GAMEDIR/color" && break
	elif [ "$OPT" = "Disable" ]; then
		echo "Disabling color!"
		COLOR=0
		echo "DISABLE" > "$GAMEDIR/color" && break
	else
		echo "Bad option! Quitting.."
		exit
	fi
	done
	sleep 1
fi
>>>>>>> 1813685971b8991e5779e5ab65a6dba945314655

# Direct termination signals to CleanUp
trap CleanUp SIGHUP SIGINT SIGTERM

# Removes any stranded map files
STRANDED_MAPS=$(find "$GAMEDIR"/map.* | wc -l)
if (( STRANDED_MAPS >= 1 )); then
	rm -f "$GAMEDIR"/map.*
else
	clear # removes 'file not found' from stdout
fi

# Setup highscore file
SetupHighscore

# Create session map
MAP=$(mktemp "$GAMEDIR"/map.XXXXXX)
MapCreate

# Zombie bugfix (DO NOT REMOVE)
DEATH=0

# Run main menu
MainMenu

# Runs Intro and starts the game
Intro

# This should never happen:
exit
# .. but why be 'tardy when you can be tidy?
