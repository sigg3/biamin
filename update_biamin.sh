#!/bin/bash
# Biamin Update Script (GNU GPL v.3+)
VERSION="0.5"
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

# Error "function" lol..
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
echo "Back in a Minute update script version $VERSION"
echo "This script checks the official Biamin repo for updates using wget!"
echo -e "Please submit bugs and feedback @ <$WEBURL>\n"

# Discover and confirm working directory
if [ ! -f "$WORKDIR/biamin.sh" ] ; then
	echo "No file biamin.sh in default $WORKDIR/"
	echo "Please enter path to folder containing biamin.sh WITHOUT trailing /"
	echo -e "Example: /home/david/Games/CLI/biamin\n"
	echo -n "PATH: " && read "WORKDIR"
	if [ ! -d "$WORKDIR" ] ; then
		BiUpError DIRECTORY_ERROR_no_such_folder
	fi
else
	echo "Found existing biamin.sh in default $WORKDIR/biamin.sh!"
fi

echo -e "Working directory: $WORKDIR/\n"
echo -n "Press any key to continue or CTRL+C to cancel .." && read -sn 1



# Download biamin.sh from gitorious.org
GX_BiaminTitle
echo "Downloading latest biamin.sh from repo .."
wget -q -O "$WORKDIR/biamin.repo" "$REPO_SRC" || error DOWNLOAD_ERR_no-internet_or_no-wget

# Compare and update biamin.sh
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
				echo -e "\nUpdating Back in a Minute to version $REPOVERSION"
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

# Remove leftover.repo files in case of previous error
if [ -f "$WORKDIR/biamin.repo" ] ; then
	rm -f "$WORKDIR/biamin.repo"
fi

echo "Thanks for playing!"

unset WORKDIR
unset GAMEDIR
unset CURRENTVERSION

exit
