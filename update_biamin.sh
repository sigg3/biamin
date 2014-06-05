#!/bin/bash
# Biamin Update Script (GNU GPL v.3+)
UPDATERVERSION="0.8"
BIAMINWEB="http://sigg3.net/biamin/bugs"
REPO_SRC="https://gitorious.org/back-in-a-minute/code/raw/biamin.sh"
WORKDIR="$HOME/.biamin"
CURRENT="$WORKDIR/biamin.sh"

########################### FUNCTIONS BLOCK  ###########################

GX_BiaminUpdaterTitle() { # Updater Title Banner
clear
	cat <<"OXFORD"
            ______                                                     
          (, /    )       /)     ,                    ,               
            /---(  _   _ (/_      __     _     ___     __      _/_  _ 
         ) / ____)(_(_(__/(__  _(_/ (_  (_(_   // (__(_/ (_(_(_(___(/_
        (_/ (   
OXFORD
echo "                            UPDATER VERSION $UPDATERVERSION"
echo "- ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ "
}

BiUpError() {	# Error function
	# Throw $1 at BiUpError() for error message
	GX_BiaminUpdaterTitle
	if [ -z "$1" ] ; then
		echo "User interupted operation!"
	else
		echo "There was an error and we had to stop!"
		echo "Log: $1" | tr '_' ' '
	fi
	if [ -f "$REPO" ]; then
		rm -f "$REPO" # Remove temporary files.
	fi	
	echo -e "\nPlease submit questions/bugs to <$BIAMINWEB>"
	exit
}
# Trap interrupt signals
trap BiUpError SIGHUP SIGINT SIGTERM

ChBiaminPath() { # Change biamin.sh path
	echo -e "\nPlease enter path to desired directory WITHOUT trailing /"
	echo -e "Example: $HOME/.biamin\n"
	echo -n "Path: " && read "WORKDIR"
}

ConfirmBiaminPath() { # Confirm biamin.sh path
echo -en "Confirm that the directory is correct [Y/N]: " && read -n1 CONFIRMWORKDIR && echo " "
case "$CONFIRMWORKDIR" in
	Y | y ) CURRENT="$WORKDIR/biamin.sh" ;;
	* ) ChBiaminPath ;;
esac
}

DownLatestBiamin() { # Download latest biamin.sh
GX_BiaminUpdaterTitle
echo "Retrieving $REPO_SRC .." | sed 's/https:\/\///g'
REPO=$( mktemp $WORKDIR/repo.XXXXXX )
if [[ $(which wget 2>/dev/null) ]]; then # Try wget, automatic redirect
    wget -q -O "$REPO" "$REPO_SRC" || BiUpError DOWNLOAD_ERR__No_internet_with_wget
elif [[ $(which curl 2>/dev/null) ]]; then # Try curl, -L - for redirect
    curl -s -L -o "$REPO" "$REPO_SRC" || BiUpError DOWNLOAD_ERR__No_internet_with_curl
else
    BiUpError DOWNLOAD_ERR__No_curl_or_wget_available
fi
}

UpdateGamedirVar() { # Change GAMEDIR var (LINE 10) in biamin.sh
echo "Changing biamin.sh GAMEDIR variable LINE 10 to $WORKDIR"
sed -i -e "10 c\GAMEDIR=\""${WORKDIR}"\"" "$CURRENT" || BiUpError PERMISSION__Couldnt_update_LINE_10
}

UpgradeBiamin() { # Upgrades biamin to latest version, assuming repo is newer
	REPOVERSION=$( sed -n -r '/^VERSION=/s/^VERSION="([^"]*)".*$/\1/p' "$REPO" )
	CURRENTVERSION=$( sed -n -r '/^VERSION=/s/^VERSION="([^"]*)".*$/\1/p' "$CURRENT" )
	echo "Your current Back in a Minute game is version $CURRENTVERSION"

	if [[ "$CURRENTVERSION" == "$REPOVERSION" ]] ; then
		echo "This is the latest version ($CURRENTVERSION) of Back in a Minute!" && rm -f "$REPO" 
	else
		echo "Newer version $REPOVERSION is available!"
		echo "Updating will NOT destroy character sheets, highscore or current config."
		echo "Update to Biamin version $REPOVERSION? [Y/N] " && read -sn1 CONFIRMUPDATE
		case "$CONFIRMUPDATE" in
			y | Y ) echo "Updating Back in a Minute from $CURRENTVERSION to $REPOVERSION .."
					rm -f "$CURRENT" && mv "$REPO" "$CURRENT"
					chmod +x "$CURRENT" || BiUpError PERMISSION__Couldnt_make_biamin_executable
					;;
			* )		echo "Not updating! Removing temporary file .." && rm -f "$REPO" ;;
		esac
	fi
}

###########################  RUNTIME BLOCK  ############################
GX_BiaminUpdaterTitle && echo -en "Locating biamin.sh .. "

# Locate biamin.sh..
if [ -f "$CURRENT" ]; then
	echo "found: $CURRENT!"	# UPDATE
	ConfirmBiaminPath
else
	echo "couldn't find biamin.sh in default location!"	# INSTALL
	ChBiaminPath
	ConfirmBiaminPath
	if [ ! -d "$WORKDIR" ] ; then
		mkdir -p "$WORKDIR" || BiUpError PERMISSION__Couldnt_make_dir_$WORKDIR
	fi
	if [ ! -f "$CURRENT" ] ; then
		echo "Still no biamin.sh found in $WORKDIR/!"
		echo -en "Type DOWNLOAD to dl latest biamin.sh to the dir : " && read CONFIRMDL
		case "$CONFIRMDL" in
			DOWNLOAD | download | Download ) DownLatestBiamin
				mv "$REPO" "$CURRENT"
				chmod +x "$CURRENT" || BiUpError PERMISSION__Couldnt_make_biamin_executable
				UpdateGamedirVar
				echo "Latest version installed to $CURRENT"
				echo "Run 'sh $CURRENT --install' to add launcher!"
				echo "Thanks for playing!" && exit ;;
			* ) rm -f "$WORKDIR" # Let's clean up after ourselves
				BiUpError CONFUSED_USER__Consider_cup_of_hot_chocolate ;;
		esac
	fi
fi
DownLatestBiamin  # Retrieve latest biamin.sh to $REPO
UpgradeBiamin     # Upgrade to latest
UpdateGamedirVar  # Fix GAMEDIR var
echo "Run 'sh $CURRENT --install' to add launcher!" && echo "Done. Thanks for playing :)"
exit
