########################################################################
#                             GX_DiceGame                              #
#                   GX for MiniGameDice (cc-version)                   #


# BACKUP
# GX_DiceGame_Table() {
# 	clear
# 	cat <<"EOT"
#                              __,"#`._
#                            <' ;_   _; `>                                    
#                             `-_______~'              
#                            .~';;,_;; ~.      ____                        
#                           /    ;:;'    \    `----'                 
#                    ______(  (   ' __,7  )___ )  ( _________    
#                   :\  __  \__\   (/____/ _  (____) _____   \     
#                   ':\  ____ (_7  * *    ___________    ___  \
#                    ':\_______________________________________\ 
#                     'L.______________________________________]
# EOT
# 	echo "$HR"
# }

GX_DiceGame_Table() {
    clear
    case "$1" in
	0 ) # Empty table
	    cat <<"EOT"
                                      
                                                                            
                                                     
                                                                         
                                                                   
                   ________________________________________    
                  :\  __   __  _   ____  _   ____  _____   \     
                  ':\  ____  _   ____   ___________    ___  \
                   ':\_______________________________________\ 
                    'L.______________________________________]
EOT
	    ;;
	* )
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

