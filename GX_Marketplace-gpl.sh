########################################################################
#                       Marketplace-related ASCII                      #
#                             (gpl-version)                            #

GX_Marketplace() {
    clear
    echo "Several Town shoppes view'd from end o' the street"
    echo "$HR"
}

#-----------------------------------------------------------------------
# GX_Marketplace_Grocer()
# Display Grocer ASCII. If $1 and $2 also display prices for FOOD and
# TOBACCO.
# Arguments: (optional) $PRICE_FxG(float), $PRICE_FxT(float).
#-----------------------------------------------------------------------
GX_Marketplace_Grocer() {
    clear
    cat <<"EOT"
                                                                  
                                                                           
           THE GROCER                                                         
                                           ,~-~-~-~-~-~-~-~-~-~-~-~.   
    "Welcome to my humble store,           | In the flickering     |
    traveller, tell me what you need!      | light of oil lamps,   |
                                           | you see rows and rows | 
    If we don't have it, I suspect         | of assorted goods.    |
    nobody else will neither.              l_______________________;  
                                                                      
                                                                       

EOT
    echo "$HR"
    if [[ "$@" ]] ; then # if args
	tput sc                                            # save cursor position
	[[ "$1" ]] && MvAddStr 10 4 "1 FOOD costs $1 Gold" # move to y=10, x=4 ( upper left corner is 0 0 )
	[[ "$2" ]] && MvAddStr 11 4  "or $2 Tobacco.\""    # move to y=11, x=4 ( upper left corner is 0 0 )
	tput rc                                            # restore cursor position
    fi
    Marketplace_Statusline
}


#-----------------------------------------------------------------------
# GX_Marketplace_Merchant()
# GPL WORKAROUND (FOR THE tput TEXT)
# Used: Marketplace_Merchant()
#-----------------------------------------------------------------------
GX_Marketplace_Merchant() {
    clear
    cat <<"EOT"


              THE MERCHANT

                                       ,~-~-~-~-~-~-~-~-~-~-~-~.
                                       |                       |
                                       | You marvel at the     |
                                       | fine goods placed     |
                                       | around the merchant's |
                                       | feet; spices, fabrics,|
                                       | & rare items from all |
                                       | over the continent.   |
                                       l_______________________;




EOT
    echo "$HR"
}


#-----------------------------------------------------------------------
# GX_Marketplace_Beggar()
# Used: Marketplace_Beggar()
#-----------------------------------------------------------------------
GX_Marketplace_Beggar() {
    clear
    cat <<"EOT"

                                                                            
            THE OLD BEGGAR                                                  
                                                                            
                                                                            
                                           ,~-~-~-~-~-~-~-~-~-~-~-~-~.
                                           |                         |    
                                           | Barely moving his tired |    
                                           | eyes to acknowledge     |
                                           | your presence, the ol'  |    
                                           | beggar raises his cup.  |    
                                           l_________________________;   
                                                                            
                                                                            
                                                                            
EOT
    echo "$HR"
}


#                                                                      #
#                                                                      #
########################################################################

