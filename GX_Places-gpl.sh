########################################################################
#                          ASCII places                                #
#                          (cc-version)                                #

#-----------------------------------------------------------------------
# GX_Place()
# Display scenario GFX and define place name for MapNav() and DisplayCharsheet()
# Arguments: $SCENARIO(char)
# Used: NewSector(), MapNav()
#-----------------------------------------------------------------------
GX_Place() {     
    clear
    case "$1" in
	H ) PLACE="Home" ;
	    cat <<"EOT"
                              MY HOME IS MY CASTLE

                      You are safe here, and fully healed.

EOT
	    ;;
	x ) PLACE="Mountain" ;
	    cat <<"EOT"
                        YOU'RE TRAVELLING IN THE MOUNTAINS
                   
               The calls of the wilderness turn your blood to ice!

EOT
	    ;;
	. ) PLACE="Road" ;
	    cat <<"EOT"
                                ON THE ROAD AGAIN

             The roads are safer than the woods, but beware of robbers!

EOT
	    ;;
	T ) PLACE="Town" ;
	    cat <<"EOT"
                     YOU HAVE REACHED A PEACEFUL LITTLE TOWN

          A hot bath, warm ale and a cozy bed awaits the weary traveller

EOT
	    ;;
	@ ) PLACE="Forest" ;
	    cat <<"EOT"
                              YOU'RE IN THE WOODS
                            
                   It feels like something is watching you...

EOT
	    ;;
	C ) PLACE="Oldburg Castle" ;
	    cat <<"EOT"
                                OLDBURG CASTLE
                                
                 Welcome to the Home of the King, the Royal Court
                           and other silly persons.

EOT
	    ;;
	Z | * ) CustomMapError;;
    esac
    echo "$HR"
}
#                                                                      #
#                                                                      #
########################################################################

