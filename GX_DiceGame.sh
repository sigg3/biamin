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
	0 ) # Empty Table CC BY-SA (C) 2014 by Sigbjørn Smelror <biamin@sigg3.net>
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
	* ) # Dice Player's Table CC BY-SA (C) 2014 by Sigbjørn Smelror <biamin@sigg3.net>
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

