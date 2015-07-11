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
	# Homestead CC BY-SA (C) 2013 by Sigbjørn Smelror <biamin@sigg3.net>
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
	# Mountains CC BY-SA (C) 2013 by Sigbjørn Smelror <biamin@sigg3.net>
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
	# On the Road Again CC BY-SA (C) 2013 by Sigbjørn Smelror <biamin@sigg3.net>
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
	# RPG Village CC BY-SA (C) 2013 by Sigbjørn Smelror <biamin@sigg3.net>
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
	# Walking the woods CC BY-SA (C) 2013 by Sigbjørn Smelror <biamin@sigg3.net>
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
	# Oldburg Castle CC BY-SA (C) 2013 by Sigbjørn Smelror <biamin@sigg3.net>
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
#-----------------------------------------------------------------------
# GX_CaveEntrance()
# Display cave entrance graphic, along with prompt to enter or avoid.
# Used: NewSector()
#-----------------------------------------------------------------------
GX_CaveEntrance() {
	clear
	# Cave Entrance CC BY-SA (C) 2015 by Sigbjørn Smelror <biamin@sigg3.net>
	cat <<"EOT" 
          
                                      ______,-.__               ___
 /\  , ^  ,  /\                 _____/           `-.____   ,-.,'   `---.
/\\\^/\ /\^/\ \/\ /\          _/                     ,  \,'             `~._
 || /\\\ \\ /\/\\\\\\ _______/_        \\     \/       ,'                   `-
     || || /\\\|| '__/          \  \\              / ,'            ,~         l
  `         ||    /    // ,.-.    \ ,-`-.   //   ,~-';     .    \  \//^,..     |
   . `           /  /  , :    | \ _// ^  \      / /  |   `\ `~-.7  (_./ ,..   ;
    .  `       ,'________`.  ;   // ^     |_  //_____`.    `~._ ;   ___/     ;
   ,     `      ""         ||  `"                      \       )   /        ,
 ,                                                      `~^~~~ |  7 ~^~~..~'
                                                               ;  l 
        YOU HAVE STUMBLED UPON                               ,'    \
        THE ENTRANCE OF A CAVE                             "'"  " '" ' "
                                                             
        The Underworld is Home to many 
        Dangerous Creatures & Thieves .. as well as treasures.
        
EOT
	echo "$HR"
} 


#                                                                      #
#                                                                      #
########################################################################

