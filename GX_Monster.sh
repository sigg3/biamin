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
	*)
	    Die "Bug in GX_Monster() with enemy >>>$1<<<"
	    ;;
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
