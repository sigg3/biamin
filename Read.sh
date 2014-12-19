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

