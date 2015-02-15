########################################################################
#                             GX_DiceGame                              #
#                   GX for MiniGameDice (gpl-version)                  #

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
                       
                       
                                             
                        DICE GAME AT THE TAVERN                     
                                             
                        There's no one at the             
                        table, come back later            
                                                           
                                                           
                                                           
EOT
        ;;
	* )
	    cat <<"EOT"
                       
                       
                                             
                        DICE GAME AT THE TAVERN                     
                                             
                        There is someone at the
                        game table. Prepare your
                        gold and lucky charms!
                                                           
                                                                                             
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

