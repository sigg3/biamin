########################################################################
#                            Parse Console Args                        #
#                                                                      #

#-----------------------------------------------------------------------
# CLI_CreateCustomMapTemplate()
# Map template generator (CLI arg function)
#-----------------------------------------------------------------------
CLI_CreateCustomMapTemplate() {
    echo -n "Create custom map template? [Y/N]: "
    case $(Read) in
	y | Y) echo -e "\nCreating custom map template.." ;;
	*)     echo -e "\nNot doing anything! Quitting.." ;
	       Exit 0 ;;
    esac

    cat <<"EOT" > "${GAMEDIR}/CUSTOM_MAP.template"
NAME: Despriptive name of map goes here
CREATOR: Name of the map creator
DESCRIPTION: Short and not exceeding 50 chars
START LOCATION: Where person'll start?
MAP:
       A | B | C | D | E | F | G | H | I | J | K | L | M | N | O | P | Q | R
   #=========================================================================#
 1 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
 2 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
 3 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
 4 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
 5 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
 6 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
 7 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
 8 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
 9 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
10 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
11 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
12 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
13 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
14 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
15 )   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z   Z (
   #=========================================================================#
          LEGEND: x = Mountain, . = Road, T = Town, @ = Forest         N
                  H = Home (Heal Your Wounds) C = Oldburg Castle     W + E
                                                                       S
EOT
    echo "Custom map template created in $GAMEDIR/CUSTOM_MAP.template"
    echo ""
    echo "1. Change all 'Z' symbols in map area with any of these:  x . T @ H C"
    echo "   See the LEGEND in rename_to_CUSTOM.map file for details."
    echo "   Home default is $START_LOCATION. Change line 16 of CONFIG or enter new HOME at runtime."
    echo "2. Spacing must be accurate, so don't touch whitespace or add new lines."
    echo "3. When you are done, simply rename your map file to FILENAME.map"
    echo "Please submit bugs and feedback at <$WEBURL>"
    Exit 0
}

#-----------------------------------------------------------------------
# CLI_Announce()
# Simply outputs a 160 char text you can cut & paste to social media.
# TODO: Once date is decoupled from system date (with CREATION and
# DATE), create new message. E.g.  $CHAR died $DATE having fought
# $BATTLES ($KILLS victoriously) etc...
#-----------------------------------------------------------------------
CLI_Announce() {
    # Die if $HIGHSCORE is empty
    [[ ! -s "$HIGHSCORE" ]] && Die "Sorry, can't do that just yet!\nThe highscore list is unfortunately empty right now."

    echo "TOP 10 BACK IN A MINUTE HIGHSCORES"
    HighscoreRead
    ReadLine "\nSelect the highscore (1-10) you'd like to display or CTRL+C to cancel: "
    local SCORE_TO_PRINT="$REPLY"

    # Check $SCORE_TO_PRINT
    IsInt "$SCORE_TO_PRINT"                             || Die "\n${SCORE_TO_PRINT} is not int. Quitting.."
    ((SCORE_TO_PRINT < 1 || SCORE_TO_PRINT > 10 ))      && Die "\nOut of range. Please select an entry between 1-10. Quitting.."
    [[ "$(sed -n "${SCORE_TO_PRINT}"p "$HIGHSCORE")" ]] || Die "\nThere is no $(Ordial $SCORE_TO_PRINT) line in HIGHSCORE file. Quitting.."

    ANNOUNCE_ADJECTIVES=("honorable" "fearless" "courageos" "brave" "legendary" "heroic")
    ADJECTIVE=${ANNOUNCE_ADJECTIVES[RANDOM%6]}

    IFS=";" read -r highEXP highCHAR highRACE highBATTLES highKILLS highITEMS highDATE highMONTH highYEAR <<< $(sed -n "${SCORE_TO_PRINT}"p "$HIGHSCORE")
    HIGH_RACES=("" "Human" "Elf" "Dwarf" "Hobbit") # ${HIGH_RACES[0]} is dummy
    highRACE=${HIGH_RACES["$highRACE"]}

    (( highBATTLES == 1 )) && highBATTLES+=" battle" || highBATTLES+=" battles"
    (( highITEMS == 1 ))   && highITEMS+=" item"     || highITEMS+=" items"

    ANNOUNCEMENT="$(Capitalize "$highCHAR") fought $highBATTLES, $highKILLS victoriously, won $highEXP EXP and $highITEMS. This $ADJECTIVE $highRACE was finally slain the $highDATE of $highMONTH in the $highYEAR Cycle."
    GX_HighScore

    echo "ADVENTURE SUMMARY to copy and paste to your social media of choice:"
    echo -e "\n$ANNOUNCEMENT\n" | fmt
    echo "$HR"
    (( $(Strlen "$ANNOUNCEMENT") > 160)) && echo "Warning! String longer than 160 chars ($(Strlen "$ANNOUNCEMENT"))!"
    Exit 0
}

#-----------------------------------------------------------------------
# CLI_CheckUpdate()
# Update function
#-----------------------------------------------------------------------
CLI_CheckUpdate() {
    # Removes stranded repo files before proceeding..
    STRANDED_REPO_FILES=$(find "$GAMEDIR"/repo.* | wc -l)
    (( STRANDED_REPO_FILES > 0 )) && rm -f "$GAMEDIR/repo.*"
    REPO_SRC="$REPO/raw/biamin.sh"
    GX_BiaminTitle
    echo "$HR"
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
    CompareVersions $VERSION $REPOVERSION
    case "$?" in
	0)  echo "This is the latest version ($VERSION) of Back in a Minute!" ; rm -f "$REPO";;
	1)  echo "Your version ($VERSION) is newer than $REPOVERSION" ; rm -f "$REPO";;
	2)  echo "Newer version $REPOVERSION is available!"
	    echo "Updating will NOT destroy character sheets, highscore or current config."
 	    echo "Update to Biamin version $REPOVERSION? [Y/N] "
	    case $(Read) in
		y | Y ) echo -e "\nUpdating Back in a Minute from $VERSION to $REPOVERSION .."
			BIAMIN_RUNTIME=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
			BIAMIN_RUNTIME+="/"
			BIAMIN_RUNTIME+=$( basename "${BASH_SOURCE[0]}")
			mv "$BIAMIN_RUNTIME" "${BIAMIN_RUNTIME}.bak" # backup current file
			mv "$REPO" "$BIAMIN_RUNTIME"
			chmod +x "$BIAMIN_RUNTIME" || Die "PERMISSION ERROR! Couldn't make biamin executable"
			echo "Run 'sh $BIAMIN_RUNTIME --install' to add launcher!"
			echo "Current file moved to ${BIAMIN_RUNTIME}.bak"
			;;
		* ) echo -e "\nNot updating! Removing temporary file ..";
		    rm -f "$REPO" ;;
	    esac
	    ;;
    esac
    echo "Done. Thanks for playing :)"
    Exit 0
}

#-----------------------------------------------------------------------
# CreateBiaminLauncher()
# Add alias for biamin in $HOME/.bashrc
#-----------------------------------------------------------------------
CLI_CreateBiaminLauncher() {
    grep -q 'biamin' "$HOME/.bashrc" && Die "Found existing launcher in $HOME/.bashrc.. skipping!"
    BIAMIN_RUNTIME=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
    echo -en "This will add $BIAMIN_RUNTIME/biamin to your .bashrc\nInstall Biamin Launcher? [Y/N]: "
    case "$(Read)" in
	y | Y ) echo -e "\n# Back in a Minute Game Launcher (just run 'biamin')\nalias biamin='$BIAMIN_RUNTIME/biamin.sh'" >> "$HOME/.bashrc";
	        echo -e "\nDone. Run 'source \$HOME/.bashrc' to test 'biamin' command." ;;
	*     ) echo -e "\nDon't worry, not changing anything!";;
    esac
    Exit 0
}

CLI_Help() {
    echo "Run BACK IN A MINUTE with '-p', '--play' or 'p' argument to play!"
    echo "For usage: run biamin --usage"
    echo "Current dir for game files: $GAMEDIR/"
    echo "Change at runtime or on line 10 in the CONFIGURATION of the script."
    Exit 0
}

CLI_Version() {
    echo "BACK IN A MINUTE VERSION $VERSION Copyright (C) 2014 Sigg3.net"
    echo "Game SHELL CODE released under GNU GPL version 3 (GPLv3)."
    echo "This is free software: you are free to change and redistribute it."
    echo "There is NO WARRANTY, to the extent permitted by law."
    echo "For details see: <http://www.gnu.org/licenses/gpl-3.0>"
    echo "Game ARTWORK released under Creative Commons CC BY-NC-SA 4.0."
    echo "You are free to copy, distribute, transmit and adapt the work."
    echo "For details see: <http://creativecommons.org/licenses/by-nc-sa/4.0/>"
    echo "Game created by Sigg3. Submit bugs & feedback at <$WEBURL>"
    Exit 0
}

CLI_Usage() {
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
    Exit 0
}


#-----------------------------------------------------------------------
# CLI_ParseArguments()
# Parse CLI arguments if any
#-----------------------------------------------------------------------
CLI_ParseArguments() {
    [[ ! "$@" ]] && CLI_Usage 	# emulation '(NO ARGUMENTS)      display this usage text and exit'
                                # Sigge, do we need it? It's not typical for unix-way. #kstn
    while [[ "$@" ]]; do
	case "$1" in
	    -a | --announce ) CLI_Announce ;;
	    -i | --install  ) CLI_CreateBiaminLauncher ;;
	    --map           ) CLI_CreateCustomMapTemplate ;;
	    -h | --help     ) CLI_Help ;;
	    -p | --play | p ) if [[ "$2" ]] && ! grep -Eq '^-' <<< "$2" ; then # if next argument is not key
	    		      	  shift  		                       # remove $1 from $@ (array of biamin.sh arguments)
	    		      	  CHAR="$1"                                    # long names as "Corum Jhaelen Irsei" should be double or single quoted
	    		      fi
			      echo "Launching Back in a Minute.." ;;
	    -v | --version  ) CLI_Version ;;
	    --update        ) CLI_CheckUpdate ;;
	    --usage         ) CLI_Usage ;;
	    -d | --debug    ) DEBUG=1;;                                        # set DEBUG mode 
	    -l | --log      ) if [[ "$2" ]] && ! grep -Eq '^-' <<< "$2" ; then # if next argument is not key
	    			  shift                                        # remove $1 from $@ (array of biamin.sh arguments)
	    			  exec 2<>"$1"                                 # redirect STDERR to $1
	    		      else
				  exec 2<>"/tmp/biamin_log_$(date "+%s")"      # or redirect STDERR to default log file
			      fi
 			      set -x                                           # set BASH's debugger 
			      ;;
	    *               ) echo "$0: unrecognized option '$1'";
			      echo "$0: use the --help or --usage options for more information";
			      Exit 0;;
	esac
	shift
    done 
}

#                                                                      #
#                                                                      #
########################################################################
