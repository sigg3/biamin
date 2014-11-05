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

