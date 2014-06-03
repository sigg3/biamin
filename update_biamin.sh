#!/bin/bash
# Biamin Update Script (GNU GPL v.3+)
VERSION="0.7"
WEBURL="http://sigg3.net/biamin"
REPO_SRC="https://gitorious.org/back-in-a-minute/code/raw/biamin.sh"
WORKDIR="$HOME/.biamin"
########################################################################

HR="- ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ "

GX_BiaminTitle() { # Used in GX_Banner(), GX_Credits(), GX_HowTo() and License() !
clear
	cat <<"EOT"
            ______                                                     
          (, /    )       /)     ,                    ,               
            /---(  _   _ (/_      __     _     ___     __      _/_  _ 
         ) / ____)(_(_(__/(__  _(_/ (_  (_(_   // (__(_/ (_(_(_(___(/_
        (_/ (   
EOT
echo "$HR"
}

# Gotta catch 'em all Error function...
BiUpError() {
	# Throw $1 at BiUpError() for error message
	GX_BiaminTitle
	if [ -z "$1" ] ; then
		echo -e "\nUser interupted operation!"
	else
		echo "There was an error and we had to stop!"
		echo "Log: $1"
	fi
	echo -e "\nPlease submit bugs at <$WEBURL>"
	exit
}
trap BiUpError SIGHUP SIGINT SIGTERM

########################################################################

GX_BiaminTitle
echo "Back in a Minute Installer & Updater version $VERSION"
echo "This script installs biamin to default location $HOME/.biamin"
echo -e "If Biamin is installed it checks the official repo for updates!\n"

# Step 1. Confirm directory
echo "Default \$GAMEDIR is $WORKDIR"
echo "Is this your desired setting [Y/N]? " && read -sn1 INITIALSETUP

case "$INITIALSETUP" in
	y | Y ) echo "Keeping game dir as $WORKDIR/" ;;
	* ) # change and/or setup
		echo "Please enter path to desired folder WITHOUT trailing /"
		echo -e "Example: /home/david/Games/CLI/biamin\n"
		echo -n "PATH: " && read "WORKDIR"
		;;
esac

# Step 2. Check that dir exists, if not create it
if [ ! -d "$WORKDIR" ] ; then
	echo "No such directory exists. Create it? [Y/N] " && read -sn1 CREATEDIRPROMPT
	case "$CREATEDIRPROMPT" in
		y | Y ) mkdir -p "$WORKDIR" || BiUpError PERMISSION_ERR_couldnt_create_directory
				echo "$WORKDIR directory created!" ;;
		* ) BiUpError ABORT_User_aborted_session ;;
	esac
fi

# Step 3. Check that biamin.sh exists in $WORKDIR else wget it
if [ ! -f "$WORKDIR/biamin.sh" ] ; then
	echo "No file biamin.sh exists in $WORKDIR/"
	updateflag=0
else
	echo "Found existing biamin.sh in default $WORKDIR/biamin.sh!"
	updateflag=1
fi

# Step 4. Download biamin.sh from gitorious.org
echo -en "\nPress any key to download latest biamin.sh or CTRL+C to cancel .." && read -sn 1
GX_BiaminTitle
echo "Downloading latest biamin.sh from repo .."
wget -q -O "$WORKDIR/biamin.repo" "$REPO_SRC" || BiUpError DOWNLOAD_ERR_no-internet_or_no-wget

# Step 5. Update or install biamin.sh
if (( updateflag = 1  )) ; then
	# We're updating existing biamin.sh
	CURRENTVERSION=$( awk '{ if (NR==4) print $0 }' "$WORKDIR/biamin.sh" | sed 's/VERSION=//g' | sed 's/"//g' )
	echo "Your current version of Back in a Minute is: $CURRENTVERSION"
	REPOVERSION=$( awk '{ if (NR==4) print $0 }' "$WORKDIR/biamin.repo" | sed 's/VERSION=//g' | sed 's/"//g' )
	echo -e "The newest version of Back in a Minute is: $REPOVERSION\n"
	if [[ "$CURRENTVERSION" == "$REPOVERSION" ]] ; then # Assume repo is the latest..
		echo "You're using the latest version of Back in a Minute!"
	else
		echo "You're using an older version of Back in a Minute!"
		echo "Updating will NOT destroy character sheets, highscore or current config."
		echo -en "Do you want to update Back in a Minute? [Y/N] " && read -n1 "CONFIRMUPDATE"
		case "$CONFIRMUPDATE" in
			Y | y ) # We're gonna update!
					echo -e "\n\nUpdating Back in a Minute to version $REPOVERSION"
					mv "$WORKDIR/biamin.sh" "$WORKDIR/biamin.old"
					mv "$WORKDIR/biamin.repo" "$WORKDIR/biamin.sh"
					if [ -f "$WORKDIR/biamin.old" ] ; then
						echo "Removing old version $CURRENTVERSION biamin.sh"
						rm -f "$WORKDIR/biamin.old"
					else
						BiUpError FILE_ERROR_cant_find_old_version
					fi
					if [ ! -f "$WORKDIR/biamin.sh" ]; then
						BiUpError FILE_ERROR_cant_find_updated_version
					else
						echo "File $WORKDIR/biamin.sh updated to version $REPOVERSION!"
						chmod +x "$WORKDIR/biamin.sh" || BiUpError PERMISSION_couldnt_make_biamin-sh_executable
					fi
					;;
			* )		# We're not gonna update!	
					echo -e "\nNot touching anything!" ;;
		esac
	fi
else
	# We're installing a fresh biamin.sh from biamin.repo
	mv "$WORKDIR/biamin.repo" "$WORKDIR/biamin.sh"
	chmod +x "$WORKDIR/biamin.sh" || BiUpError PERMISSION_couldnt_make_biamin-sh_executable
	echo "Biamin.sh installed to $WORKDIR/"

	# Update .bashrc with biamin launcher
	if grep -q 'biamin' "$HOME/.bashrc" ; then
		echo "Found existing Biamin launcher in .bashrc .. skipping!"
	else
		echo "Add biamin alias to your .bashrc file? .." && read -sn1 BIAMINLAUNCH
		case "$BIAMINLAUNCH" in
			y | Y ) echo -e "\n# Back in a Minute Game Launcher (just run 'biamin')\nalias biamin='$WORKDIR/biamin.sh'" >> "$HOME/.bashrc" || BiUpError ALIAS_couldnt_update_bashrc_config
					echo -e "Done.\nRun 'source \$HOME/.bashrc' to test 'biamin' command or close/open terminal." ;;
			* ) echo "Leaving your .bashrc file alone .."
		esac
	fi
fi

# Step 6. Change biamin.sh $GAMEDIR to $WORKDIR
if [[ "$WORKDIR" != "$HOME/.biamin" ]] ; then
		echo "Changing biamin GAMEDIR variable to $WORKDIR .."
		sed -i -e "10 c\GAMEDIR=\""${WORKDIR}"\"" "$WORKDIR/biamin.sh" || BiUpError PERMISSION_couldnt_update_LINE-10_of_biamin
fi


# Step 7. Remove leftover.repo files
if [ -f "$WORKDIR/biamin.repo" ] ; then
	rm -f "$WORKDIR/biamin.repo"
fi

echo -e "We're all done here!\nThanks for playing :)"

unset WORKDIR
unset GAMEDIR
unset CURRENTVERSION

exit
