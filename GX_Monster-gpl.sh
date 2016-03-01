########################################################################
#                           GX_Monster                                 #
#                          (gpl-version)                               #

#-----------------------------------------------------------------------
# GX_Monster()
# Display enemy's GX
# Arguments: ${enemy[name]} (string)
#-----------------------------------------------------------------------
GX_Monster() {
    clear
    case "$1" in
	"chthulu" ) cat <<"EOT"
                     THE WRATH OF MIGHTY CHTHULU IS UPON YOU

EOT
	    ;;
	"orc" ) cat <<"EOT"

                     AN ANGRY ORC APPEARS, BLOCKING YOUR WAY!

                          "Prepare to die", it growls.

EOT
	    ;;
	"varg" ) cat <<"EOT"

                          YOU ENCOUNTER A TERRIBLE VARG!

                                 It looks hungry.

EOT
	    ;;
	"mage" ) cat <<"EOT"
                        A FIERCE MAGE STANDS IN YOUR WAY!

               Before you know it, he begins his evil incantations..
                          "Lorem ipsum dolor sit amet..."

EOT
	    ;;
	"goblin" ) cat <<"EOT"

                              A GOBLIN JUMPS YOU!

                         He raises his club to attack..

EOT
	    ;;
	"bandit" ) cat <<"EOT"
                   YOU ARE AMBUSHED BY A LOWLIFE CRIMINAL!

           "Hand over your expensive stuffs, puny poncer, or have your
           skull cracked open by the mighty club!"

EOT
	    ;;
	"boar" ) cat <<"EOT"
                         A WILD BOAR CROSSES YOUR PATH

              Careful, this beast is not as peaceful as it looks.

EOT
	    ;;
	"dragon" ) cat <<"EOT"
                              A DRAGON SWOOPS IN!

                       There is nowhere to hide or run.
                             Fight for your life!
EOT
	    ;;
	"bear" ) cat <<"EOT"
                     SUDDENLY, A MIGHTY CAVE BEAR APPEARS

               It kicks the ground and charges. Brace yourself.
EOT
	    ;;
	"imp" ) cat <<"EOT"
                             AN YMPE SWOOPS DOWN!

                 The imp is a common nuisance for travellers.
                      Luckily, they are easily defeated.
EOT
	    ;;
	*)  Die "${FUNCNAME}(): Bad ARG >>>$1<<<" ;;
    esac
    echo "$HR"
}

#                                                                      #
#                                                                      #
########################################################################
