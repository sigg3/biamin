# Back In A Minute created by Sigg3.net (C) 2014
# Code is GNU GPLv3 & ASCII art is CC BY-NC-SA 4.0
VERSION="1.9" # 12 items on TODO. Change to 2.0 when list is x'd out
WEBURL="http://sigg3.net/biamin/"
REPO="https://gitorious.org/back-in-a-minute/code"

########################  CONFIGURATION  ###############################
# Default dir for config, saves, etc, change at runtime                #
GAMEDIR="$HOME/.biamin" # (no trailing slash!)                         #
# Default file for config, change at runtime                           #
CONFIG="$GAMEDIR/config"                                               #
# Default file for highscore, change at runtime                        #
HIGHSCORE="$GAMEDIR/highscore"                                         #
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
