########################################################################
#                             Menu system                              #
#                                                                      #

#-----------------------------------------------------------------------
# LoadGame()
# Display chars in $GAMEDIR and load one
# Used: MainMenu()
#-----------------------------------------------------------------------
LoadGame() {
    local SHEETS FILES i=0 LIMIT=9 OFFSET=0 NUM=0 a # Declare all needed local variables
    # xargs ls -t - sort by date, last played char'll be the first in array
    for loadSHEET in $(find "$GAMEDIR/" -name '*.sheet') ; do # Find all sheets and add to array if any
	((++i))
	FILES[$i]="$loadSHEET"
   	SHEETS[$i]=$(awk '{ # Character can consist from two and more words, not only "Corum" but "Corum Jhaelen Irsei" for instance
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
                 print "\"" CHARACTER "\" the " RACE " (" HEALTH " HP, " EXPERIENCE " EXP, " ITEMS " items, sector " LOCATION ")"
                 }' "$loadSHEET")
    done
    GX_LoadGame 		# Just one time!
    tput sc
    if [[ ! "${SHEETS[@]}" ]] ; then # If no one sheet was found
    	echo " Sorry! No character sheets in $GAMEDIR/"
    	PressAnyKey " Press any key to return to (M)ain menu and try (P)lay" # St. Anykey - patron of cyberneticists :)
    	return 1   # BiaminSetup() will not be run after LoadGame()
    fi
    while (true) ; do
	tput rc 		# Restore cursor position
	tput ed			# Clear to the end of screen
    	for (( a=1; a <= LIMIT ; a++)); do [[ ${SHEETS[((a + OFFSET))]} ]] && echo "${a}. ${SHEETS[((a + OFFSET))]}" || break ; done
    	(( i > LIMIT)) && echo -en "\n You have more than $LIMIT characters. Use (P)revious or (N)ext to list," # Don't show it if there are chars < LIMIT
    	echo -en "\n Enter NUMBER of character to load or any letter to return to (M)ain Menu: "
    	read -sn 1 NUM # TODO replace to read -p after debug
    	case "$NUM" in
    	    n | N ) ((OFFSET + LIMIT < i)) && ((OFFSET += LIMIT)) ;; # Next part of list
    	    p | P ) ((OFFSET > 0))         && ((OFFSET -= LIMIT)) ;; # Previous part of list
    	    [1-9] ) NUM=$((NUM + OFFSET)); break;;                   # Set NUM = selected charsheet num
    	    *     ) break;; # NUM == 0 to prevent fall in [[ ! ${FILES[$NUM]} ]] if user press ESC, KEY_UP etc. ${FILES[0]} is always empty
    	esac
     done
    echo "" # TODO empty line - fix it later
    [[ ! "${SHEETS[$NUM]}" ]] && return 1 # BiaminSetup() will not be run after LoadGame()
    CHAR=$(awk '{if (/^CHARACTER:/) { RLENGTH = match($0,/: /); print substr($0, RLENGTH+2);}}' "${FILES[$NUM]}" );
}   # return to MainMenu()

HighscoreRead() { # Used in CLI_Announce() and HighScore()
    sort -g -r "$HIGHSCORE" -o "$HIGHSCORE"
    local i=1 HIGHSCORE_TMP=" #;Hero;EXP;Wins;Items;Entered History\n"
    # Read values from highscore file (BashFAQ/001)
    while IFS=";" read -r highEXP highCHAR highRACE highBATTLES highKILLS highITEMS highDATE highMONTH highYEAR; do
	(( i > 10 )) && break
	case "$highRACE" in
	    1 ) highRACE="Human" ;;
	    2 ) highRACE="Elf" ;;
	    3 ) highRACE="Dwarf" ;;
	    4 ) highRACE="Hobbit" ;;
	esac
	HIGHSCORE_TMP+=" $i.;$highCHAR the $highRACE;$highEXP;$highKILLS/$highBATTLES;$highITEMS/8;$highMONTH $highDATE ($highYEAR)\n"
	((i++))
    done < "$HIGHSCORE"
    echo -e "$HIGHSCORE_TMP" | column -t -s ";" # Nice tabbed output!
    unset HIGHSCORE_TMP
}

#----------------------------------------------------------------------
# PrepareLicense()
# Gets licenses and concatenates into "LICENSE" in $GAMEDIR
# TODO: add option to use wget if systen hasn't curl (Debian for
# instance) -kstn
# TODO: I'm not sure. I was told to use curl because it has greater
# compatibility than wget..? - s3
#-----------------------------------------------------------------------
PrepareLicense() {
    echo " Download GNU GPL Version 3 ..."
    GPL=$(curl -s "$REPO/raw/licenses/GPL" || "" ) # TODO test these
#   GPL=$(curl -s "http://www.gnu.org/licenses/gpl-3.0.txt" || "") # I did not know we could do that :)
    echo " Download CC BY-NC-SA 4.0 ..."
	CC=$(curl -s "$REPO/raw/licenses/CC" || "" )   # TODO test these
#   CC=$(curl -s "http://creativecommons.org/licenses/by-nc-sa/4.0/legalcode.txt" || "")
	# TODO Check md5sums of files :
	# d32239bcb673463ab874e80d47fae504  GPL
	# 6991e89af15ce0d1037ddd018f05029e  CC
    if [[ $GPL && $CC ]] ; then
	echo -e "\t\t   BACK IN A MINUTE BASH CODE LICENSE:\t\t\t(Q)uit\n
$HR
$GPL
\n$HR\n\n\t\t   BACK IN A MINUTE ARTWORK LICENSE:\n\n
$CC"  > "$GAMEDIR/LICENSE"
	Die "Licenses downloaded and concatenated!"
    else
	Die "Couldn't download license files :( Do you have Internet access?"
    fi
}

#-----------------------------------------------------------------------
# License()
# Displays license if present or runs PrepareLicense && then display it..
# Used: Credits()
#-----------------------------------------------------------------------
License() {
    GX_BiaminTitle
    if [[ ! -f "$GAMEDIR/LICENSE" ]]; then
	ReadLine "\n License file currently missing in $GAMEDIR/ !\n To DL licenses, about 60kB, type YES (requires internet access): "
	case "$REPLY" in
	    YES ) PrepareLicense ;;
	    *    )   echo -e "
Code License:\t<http://www.gnu.org/licenses/gpl-3.0.txt>
Art License:\t<http://creativecommons.org/licenses/by-nc-sa/4.0/legalcode.txt>
More info:\t<${WEBURL}about#license>
Press any key to go back to main menu!";
		     read -sn 1;
		     return 0;;
	esac
    fi
    [[ "$PAGER" ]] && "$PAGER" "$GAMEDIR/LICENSE" || { echo -e "\n License file available at $GAMEDIR/LICENSE" ; PressAnyKey ;} # ShowLicense()
}   # Return to Credits()


CleanUp() { # Used in MainMenu(), NewSector(),
    GX_BiaminTitle
    echo -e "\n$HR"
    if ((FIGHTMODE)); then #  -20 HP -20 EXP Penalty for exiting CTRL+C during battle!
	((CHAR_HEALTH -= 20))
    	((CHAR_EXP -= 20))
    	echo -e "PENALTY for CTRL+Chickening out during battle: -20 HP -20 EXP\nHEALTH: $CHAR_HEALTH\tEXPERIENCE: $CHAR_EXP"
    fi
    [[ "$CHAR" ]] && SaveCurrentSheet # Don't try to save if we've nobody to save :)
    echo -e "\nLeaving the realm of magic behind ....\nPlease submit bugs and feedback at <$WEBURL>"
    Exit 0
}

#-----------------------------------------------------------------------
# MainMenu()
# Defines $CHAR or show misc options
#-----------------------------------------------------------------------
MainMenu() {
    while [[ ! "$CHAR" ]] ; do # Until $CHAR is defined
	GX_Banner
	MakePrompt '(P)lay;(L)oad game;(H)ighscore;(C)redits;(Q)uit'
	case $(Read) in
	    p | P ) ReadLine "${CLEAR_LINE} Enter character name (case sensitive): ";
 		    CHAR="$REPLY" ;;
	    l | L ) LoadGame ;;
	    h | H ) GX_HighScore ; # HighScore
		    echo "";
		    # Show 10 highscore entries or die if Highscore list is empty
		    [[ -s "$HIGHSCORE" ]] && HighscoreRead || echo -e " The highscore list is unfortunately empty right now.\n You have to play some to get some!";
		    echo "" ; # empty line TODO fix it
		    PressAnyKey 'Press the any key to go to (M)ain menu';;
	    c | C ) GX_Credits ; # Credits
		    MakePrompt '(H)owTo;(L)icense;(M)ain menu';
		    case $(Read) in
			L | l ) License ;;
			H | h ) GX_HowTo ;;
		    esac ;;
	    q | Q ) CleanUp ;;
	esac
done
}

#                                                                      #
#                                                                      #
########################################################################

