########################################################################
#                                                                      #
#                                                                      #

Announce() {
    # Simply outputs a 160 char text you can cut & paste to social media.
    
    # TODO: Once date is decoupled from system date (with CREATION and DATE), create new message. E.g.
    # $CHAR died $DATE having fought $BATTLES ($KILLS victoriously) etc...

    # Die if $HIGHSCORE is empty
    [[ ! -s "$HIGHSCORE" ]] && Die "Sorry, can't do that just yet!\nThe highscore list is unfortunately empty right now."

    echo "TOP 10 BACK IN A MINUTE HIGHSCORES"
    HighscoreRead
    echo -en "\nSelect the highscore (1-10) you'd like to display or CTRL+C to cancel: "
    read SCORE_TO_PRINT

    ((SCORE_TO_PRINT < 1)) && ((SCORE_TO_PRINT > 10 )) && Die "\nOut of range. Please select an entry between 1-10. Quitting.."

    case $(RollDice2 6) in
	1 ) ADJECTIVE="honorable" ;;
	2 ) ADJECTIVE="fearless" ;;
	3 ) ADJECTIVE="courageos" ;;
	4 ) ADJECTIVE="brave" ;;
	5 ) ADJECTIVE="legendary" ;;
	6 ) ADJECTIVE="heroic" ;;
    esac

    ANNOUNCEMENT_TMP=$(sed -n "${SCORE_TO_PRINT}"p "$HIGHSCORE")
    IFS=";" read -r highEXP highCHAR highRACE highBATTLES highKILLS highITEMS highDATE highMONTH highYEAR <<< "$ANNOUNCEMENT_TMP"

    case "$highRACE" in
	1 ) highRACE="Human" ;;
	2 ) highRACE="Elf" ;;
	3 ) highRACE="Dwarf" ;;
	4 ) highRACE="Hobbit" ;;
    esac

    (( highBATTLES == 1 )) && highBATTLES+=" battle" || highBATTLES+=" battles"
    (( highITEMS == 1 ))   && highITEMS+=" item"     || highITEMS+=" items"

    highCHAR=$(Capitalize "$highCHAR") # Capitalize
    
    if [[ "$highMONTH" ]] ; then # fix for "Witching Day", etc
	ANNOUNCEMENT="$highCHAR fought $highBATTLES, $highKILLS victoriously, won $highEXP EXP and $highITEMS. This $ADJECTIVE $highRACE was finally slain the $highDATE of $highMONTH in the $highYEAR Cycle."
    else
	ANNOUNCEMENT="$highCHAR fought $highBATTLES, $highKILLS victoriously, won $highEXP EXP and $highITEMS. This $ADJECTIVE $highRACE was finally slain at the $highDATE in the $highYEAR Cycle."
    fi
    ANNOUNCEMENT_LENGHT=$(awk '{print length($0)}' <<< "$ANNOUNCEMENT" ) 
    GX_HighScore

    echo "ADVENTURE SUMMARY to copy and paste to your social media of choice:"
    echo -e "\n$ANNOUNCEMENT\n" | fmt
    echo "$HR"

    ((ANNOUNCEMENT_LENGHT > 160)) && echo "Warning! String longer than 160 chars ($ANNOUNCEMENT_LENGHT)!"
    exit 0
}

CreateBiaminLauncher() {
    grep -q 'biamin' "$HOME/.bashrc" && Die "Found existing launcher in $HOME/.bashrc.. skipping!" 
    BIAMIN_RUNTIME=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ) # TODO $0 is a powerful beast, but will sometimes fail..
    echo "This will add $BIAMIN_RUNTIME/biamin to your .bashrc"
    read -n 1 -p "Install Biamin Launcher? [Y/N]: " LAUNCHER 2>&1
    case "$LAUNCHER" in
	y | Y ) echo -e "\n# Back in a Minute Game Launcher (just run 'biamin')\nalias biamin='$BIAMIN_RUNTIME/biamin.sh'" >> "$HOME/.bashrc";
	        echo -e "\nDone. Run 'source \$HOME/.bashrc' to test 'biamin' command." ;;
	* ) echo -e "\nDon't worry, not changing anything!";;
    esac
    exit 0
}

ParseCLIarguments() {
    # Parse CLI arguments if any # TODO use getopts ?
    case "$1" in
	-a | --announce )     Announce ;;
	-i | --install ) CreateBiaminLauncher ;;
	-h | --help )
	    echo "Run BACK IN A MINUTE with '-p', '--play' or 'p' argument to play!"
	    echo "For usage: run biamin --usage"
	    echo "Current dir for game files: $GAMEDIR/"
	    echo "Change at runtime or on line 10 in the CONFIGURATION of the script."
	    exit 0;;
	--map )
	    read -n1 -p "Create custom map template? [Y/N]: " CUSTOM_MAP_PROMPT 2>&1
	    case "$CUSTOM_MAP_PROMPT" in
		y | Y) echo -e "\nCreating custom map template.." ; MapCreateCustom ;;
		*)     echo -e "\nNot doing anything! Quitting.."
	    esac
	    exit 0 ;;
	-p | --play | p ) echo "Launching Back in a Minute.." ;;
	-v | --version )
	    echo "BACK IN A MINUTE VERSION $VERSION Copyright (C) 2014 Sigg3.net"
	    echo "Game SHELL CODE released under GNU GPL version 3 (GPLv3)."
	    echo "This is free software: you are free to change and redistribute it."
	    echo "There is NO WARRANTY, to the extent permitted by law."
	    echo "For details see: <http://www.gnu.org/licenses/gpl-3.0>"
	    echo "Game ARTWORK released under Creative Commons CC BY-NC-SA 4.0."
	    echo "You are free to copy, distribute, transmit and adapt the work."
	    echo "For details see: <http://creativecommons.org/licenses/by-nc-sa/4.0/>"
	    echo "Game created by Sigg3. Submit bugs & feedback at <$WEBURL>"
	    exit 0 ;;
	--update ) # Update function
	    # Removes stranded repo files before proceeding..
	    STRANDED_REPO_FILES=$(find "$GAMEDIR"/repo.* | wc -l)
	    (( STRANDED_REPO_FILES > 0 )) && rm -f "$GAMEDIR/repo.*"
	    REPO_SRC="https://gitorious.org/back-in-a-minute/code/raw/biamin.sh"
	    GX_BiaminTitle;
	    echo "Retrieving $REPO_SRC .." | sed 's/https:\/\///g'
	    REPO=$( mktemp $GAMEDIR/repo.XXXXXX ) 
	    if [[ $(which wget 2>/dev/null) ]]; then # Try wget, automatic redirect
		wget -q -O "$REPO" "$REPO_SRC" || Die "DOWNLOAD ERROR! No internet with wget"
	    elif [[ $(which curl 2>/dev/null) ]]; then # Try curl, -L - for redirect
		curl -s -L -o "$REPO" "$REPO_SRC" || Die  "DOWNLOAD ERROR! No internet with curl"
	    else
		Die "DOWNLOAD ERROR! No curl or wget available"
	    fi

	    REPOVERSION=$( sed -n -r '/^VERSION=/s/^VERSION="([^"]*)".*$/\1/p' "$REPO" )
	    echo "Your current Back in a Minute game is version $VERSION"

	    # Compare versions $1 and $2. Versions should be [0-9]+.[0-9]+.[0-9]+. ...
	    # Return 0 if $1 == $2, 1 if $1 > than $2, 2 if $2 < than $1
	    if [[ "$VERSION" == "$REPOVERSION" ]] ; then
		RETVAL=0  
	    else
		IFS="\." read -a VER1 <<< "$VERSION"
		IFS="\." read -a VER2 <<< "$REPOVERSION"
		for ((i=0; ; i++)); do # until break
		    [[ ! "${VER1[$i]}" ]] && { RETVAL=2; break; }
		    [[ ! "${VER2[$i]}" ]] && { RETVAL=1; break; }
		    (( ${VER1[$i]} > ${VER2[$i]} )) && { RETVAL=1; break; }
		    (( ${VER1[$i]} < ${VER2[$i]} )) && { RETVAL=2; break; }
		done
		unset VER1 VER2
	    fi
	    case "$RETVAL" in
		0)  echo "This is the latest version ($VERSION) of Back in a Minute!" ; rm -f "$REPO";;
		1)  echo "Your version ($VERSION) is newer than $REPOVERSION" ; rm -f "$REPO";;
		2)  echo "Newer version $REPOVERSION is available!"
		    echo "Updating will NOT destroy character sheets, highscore or current config."
 		    read -sn1 -p "Update to Biamin version $REPOVERSION? [Y/N] " CONFIRMUPDATE 2>&1
		    case "$CONFIRMUPDATE" in
			y | Y ) echo -e "\nUpdating Back in a Minute from $VERSION to $REPOVERSION .."
				# TODO make it less ugly
				BIAMIN_RUNTIME=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ) # TODO $0 is a powerful beast, but will sometimes fail.
				BIAMIN_RUNTIME+="/"
				BIAMIN_RUNTIME+=$( basename "${BASH_SOURCE[0]}")
				mv "$BIAMIN_RUNTIME" "${BIAMIN_RUNTIME}.bak" # backup current file
				mv "$REPO" "$BIAMIN_RUNTIME"
				chmod +x "$BIAMIN_RUNTIME" || Die "PERMISSION ERROR! Couldnt make biamin executable"
				echo "Run 'sh $BIAMIN_RUNTIME --install' to add launcher!" 
				echo "Current file moved to ${BIAMIN_RUNTIME}.bak"
				;;
			* ) echo -e "\nNot updating! Removing temporary file .."; rm -f "$REPO" ;;
		    esac
		    ;;
	    esac
	    echo "Done. Thanks for playing :)"
	    exit 0;;
	--usage | * )
	    echo "Usage: biamin or ./biamin.sh"
	    echo "  (NO ARGUMENTS)      display this usage text and exit"
	    echo "  -p --play or p      PLAY the game \"Back in a minute\""
	    echo "  -a --announce       DISPLAY an adventure summary for social media and exit"
	    echo "  -i --install        ADD biamin.sh to your .bashrc file"
	    echo "     --map            CREATE custom map template with instructions and exit"
	    echo "     --help           display help text and exit"
	    echo "     --update         check for updates"
	    echo "     --usage          display this usage text and exit"
	    echo "  -v --version        display version and licensing info and exit"
	    exit 0;;
    esac
}



#                                                                      #
#                                                                      #
########################################################################
