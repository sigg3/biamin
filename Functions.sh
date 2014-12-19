########################################################################
#          Small functions which are used throughout the game          #
#                                                                      #

Die()        { echo -e "$1" && exit 1 ;}                                           # Display $1 and exit script.
Capitalize() { awk '{ print substr(toupper($0), 1,1) substr($0, 2); }' <<< "$*" ;} # Capitalize $1.
Toupper()    { awk '{ print toupper($0); }' <<< "$*" ;}                            # Convert $* to uppercase.
Strlen()     { awk '{print length($0);}' <<< "$*" ;}                               # Return lenght of string $*.
MvAddStr()   { tput cup "$1" "$2"; printf "%s" "$3"; }                             # Move cursor to $1 $2 and print $3.
IsInt()      { grep -E '^[0-9]+$' <<< "$1" && return 0 || return 1; }              # Checks if $1 is int.

#-----------------------------------------------------------------------
# Read()
# Flush 512 symbols readed before and read one symbol
#-----------------------------------------------------------------------    
Read() {
    read -s -t 0 -n 512 	# Flush 512 symbols in in buffer
    read -s -n 1		# Read only one symbol (to default variable, $REPLY)
    echo "$REPLY"		# And echo it
}

#-----------------------------------------------------------------------
# Sleep()
# Works like usual sleep but can be abortet by hitting key
# Arguments: $SECONDS(int)
#-----------------------------------------------------------------------    
Sleep() {
    read -n 1 -t "$1"
}

#-----------------------------------------------------------------------
# Ordial()
# Add postfix to $1 (NUMBER)
# Arguments: $1(int)
#-----------------------------------------------------------------------
Ordial() { 
    grep -Eq '[^1]?1$'  <<< "$1" && echo "${1}st" && return 0
    grep -Eq '[^1]?2$'  <<< "$1" && echo "${1}nd" && return 0
    grep -Eq '[^1]?3$'  <<< "$1" && echo "${1}rd" && return 0
    grep -Eq '^[0-9]+$' <<< "$1" && echo "${1}th" && return 0
    Die "Bug in Ordial with ARG $1"
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
    read -sn 1
} 

#                                                                      #
#                                                                      #
########################################################################

