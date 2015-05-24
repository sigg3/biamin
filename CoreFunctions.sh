########################################################################
#          Small functions which are used throughout the game          #
#                                                                      #

Die()         { echo -e "$1" >&2 && Exit 1 ; }                                      # Display $1 (to STDERR) and exit script.
Sleep()       { read -s -n 1 -t "$1" ; }                                            # Works like usual sleep but can be abortet by hitting key
Capitalize()  { awk '{ print substr(toupper($0), 1,1) substr($0, 2); }' <<< "$*" ;} # Capitalize $1.
Toupper()     { awk '{ print toupper($0); }' <<< "$*" ; }                           # Convert $* to uppercase.
Strlen()      { awk '{ print length($0); }' <<< "$*" ; }                            # Return lenght of string $*.
MvAddStr()    { tput cup "$1" "$2"; printf "%s" "$3"; }                             # Move cursor to $1 $2 and print $3.
IsInt()       { grep -Eq '^[0-9]+$' <<< "$1" && return 0 || return 1; }             # Checks if $1 is int.
IsInstalled() { [[ $(which "$1" 2>/dev/null) ]] && return 0 || return 1 ; }         # Checks if $1(string) installed
Float()       {  bc <<< "scale=2; ${@}" ; }                                         # Float math. Usage var=$(Float "${CHAR_GOLD} * 2.25")

#-----------------------------------------------------------------------
# Exit()
# Makes cursor visible, than exit
# Arguments: (optional) $EXIT_CODE(int [0-255])
#-----------------------------------------------------------------------
Exit() {
    tput cnorm			      # Make cursor visible (to prevent leaving player without cursor)
    [[ "$1" ]] && exit "$1" || exit 0 # If $EXIT_CODE then 'exit $EXIT_CODE' else 'exit 0'
}

#-----------------------------------------------------------------------
# Read()
# Flush 512 symbols readed before and read one symbol
#-----------------------------------------------------------------------
Read() {
    read -s -t 0.01 -n 512 	# Flush 512 symbols in in buffer
    read -s -n 1		# Read only one symbol (to default variable, $REPLY)
    echo "$REPLY"		# And echo it
}

#-----------------------------------------------------------------------
# ReadLine()
# Flush 512 symbols readed before, makes cursor visible and read one
# line, than makes cursor unvisible
# NB to get answer you need to use $REPLY variable !!!
# Arguments: (optional) $PROMPT
#-----------------------------------------------------------------------
ReadLine() {
    [[ "$1" ]] && echo -en "$1" # Display prompt if any (like read -p, but to STDOUT and with '\n', '\t', colors, etc)
    read -s -t 0.01 -n 512 	# Flush 512 symbols in in buffer
    tput cnorm			# Make cursor visible
    read		        # Read one line (to default variable, $REPLY)
    tput civis			# Make cursor unvisible
}

#-----------------------------------------------------------------------
# Ordial()
# Add postfix to $1 (NUMBER)
# Arguments: $1(int)
#-----------------------------------------------------------------------
Ordial() {
    grep -Eq '^([0-9]*[^1])?1$'  <<< "$1" && echo "${1}st" && return 0
    grep -Eq '^([0-9]*[^1])?2$'  <<< "$1" && echo "${1}nd" && return 0
    grep -Eq '^([0-9]*[^1])?3$'  <<< "$1" && echo "${1}rd" && return 0
    grep -Eq '^[0-9]+$' <<< "$1" && echo "${1}th" && return 0
    Die "Bug in Ordial() with ARG >>>$1<<<"
}

#-----------------------------------------------------------------------
# MakePrompt()
# Make centered to 79px promt from $@ (WITHOUT '\n' at the end of
# string!). Arguments should be separated by ';'
# Arguments: $PROMPT(string)
#-----------------------------------------------------------------------
MakePrompt() {
    awk '   BEGIN { FS =";" }
        {   MAXLEN = 79;
            COUNT = NF;
            for ( i=1; i<= NF; i++ ) { STRLEN += length($i); }
            if ( STRLEN > MAXLEN ) { exit 1 ; }
            SPACES = MAXLEN - STRLEN;
            REMAINDER = SPACES % (NF + 1 ) ;
            SPACER = (SPACES - REMAINDER ) / (NF + 1) ;
            if ( REMAINDER % 2  == 1 ) { REMAINDER -= 1 ; }
            SPACES_IN = REMAINDER / 2 ;
            while (SPACES_IN-- > 0 ) { INTRO = INTRO " "; }
            while (SPACER-- > 0 ) { SEPARATOR = SEPARATOR " " }
            STR = INTRO;
            for ( i=1; i<=NF; i++ ) { STR = STR SEPARATOR $i; }
            STR = STR SEPARATOR INTRO }
            END { printf STR; }' <<< "$@" || Die "Too long promt >>>$*<<<"
}

#-----------------------------------------------------------------------
# CompareVersions()
# Compare versions $1 and $2. Versions should be [0-9]+.[0-9]+.[0-9]+. ...
# Return : 0 if $1 == $2,
#          1 if $1 > than $2,
#          2 if $2 < than $1
# Arguments: $VERSION1, $VERSION2
# Used: CLI_CheckUpdate()
#-----------------------------------------------------------------------
CompareVersions() {
    [[ "$1" == "$2" ]] && return 0
    IFS="\." read -a VER1 <<< "$1"
    IFS="\." read -a VER2 <<< "$2"
    for ((i=0; ; i++)); do         # until break
	[[ ! "${VER1[$i]}" ]] && { RETVAL=2; break; }
	[[ ! "${VER2[$i]}" ]] && { RETVAL=1; break; }
	(( ${VER1[$i]} > ${VER2[$i]} )) && { RETVAL=1; break; }
	(( ${VER1[$i]} < ${VER2[$i]} )) && { RETVAL=2; break; }
    done
    unset VER1 VER2
    return $RETVAL
}

#-----------------------------------------------------------------------
# PressAnyKey()
# Make centered prompt $1 (or default) and read anykey
# Arguments: (optional) $PROMPT(string)
#-----------------------------------------------------------------------
PressAnyKey() {
    if [[ "$1" ]]; then
	MakePrompt "$1"
    else
	MakePrompt 'Press (A)ny key to continue..'
    fi
    read -s -t 0.01 -n 512 	# Flush 512 symbols in in buffer
    read -sn 1
}

#-----------------------------------------------------------------------
# ReseedRandom()
# Reseed random numbers generator by date or to $1 if it.
# Used: CoreRuntime.sh
# Arguments: (optional) $SEED(int)
#-----------------------------------------------------------------------
# TODO:
#  ? Make separate file with system-depended things
#  ? Use /dev/random or /dev/urandom
#-----------------------------------------------------------------------
# Suggestion from: http://tldp.org/LDP/abs/html/randomvar.html
# RANDOM=$(head -1 /dev/urandom | od -N 1 | awk '{ print $2 }'| sed s/^0*//)
#-----------------------------------------------------------------------
ReseedRandom() {
    if [[ "$1" ]]; then
	RANDOM="${1}"
    else
	case "$OSTYPE" in
	    openbsd* ) RANDOM=$(date '+%S') ;;
	    *)         RANDOM=$(date '+%N') ;;
	esac
    fi
}

#-----------------------------------------------------------------------
# Echo() - test, EchoRight etc
#-----------------------------------------------------------------------
Echo() {
    # TODO check for total lenght < 79 !!!
    echo -en "$1"
    tput hpa $(( 78 - $(Strlen "$2") )) # Move cursor to column #1
    echo -en "$2"
}

#                                                                      #
#                                                                      #
########################################################################
