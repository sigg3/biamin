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


#                                                                      #
#                                                                      #
########################################################################

