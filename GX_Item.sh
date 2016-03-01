########################################################################
#                             GX_Item                                  #
#                                                                      #

#-----------------------------------------------------------------------
# GX_Item()
# Display GX for current magic item
# Arguments: $CHAR_ITEMS(int)
#-----------------------------------------------------------------------

GX_Item() {
    clear
    case "$1" in
	"$GIFT_OF_SIGHT")
	# Gift of Sight CC BY-SA (C) 2013 by Sigbjørn Smelror <biamin@sigg3.net>
	    cat <<"EOT"

                          G I F T   O F   S I G H T

                                ..............
                                ____________**:,.
                             .-'  /      \  ``-.*:,..
                         _.-*    |  .jM O |     `-..*;,,
                        `-.      :   WW   ;       .-'
                   ....    '._    \______/     _.'   .:
                      *::...  `-._ _________,;'    .:*
                          *::...                 ..:*
                               *::............::*

     You give aid to an old woman, carry her firewood and water from the
     stream, and after a few days she reveals herself as a White Witch!

     She gives you a blessing and the Gift of Sight in return for your help.
     "The Gift of Sight," she says, "will aide you as you aided me."

     Look for a ~ symbol in your map to discover new items in your travels.
     However, from the 7 remaining items only 1 is made visible at a time.

EOT
	    ;;
	"$EMERALD_OF_NARCOLEPSY")
	# Emerald CC BY-SA (C) 2013 by Sigbjørn Smelror <biamin@sigg3.net>
	    cat <<"EOT"

                  E M E R A L D   O F   N A R C O L E P S Y
                             .   .  ____  .   .
                                .  /.--.\  .
                               .  //    \\  .
                            .  .  \\    //  .  .
                                .  \\  //  .
                             .   .  \`//  .   .
                                     \/
     You encounter a strange merchant from east of all maps who joins you
     for a stretch of road. He is a likeable fellow, so when he asks if he
     could share a campfire with you and finally get some much needed rest in
     these strange lands, you comply.

     The following day he presents you with a brilliant emerald that he says
     will help you sleep whenever you need to get some rest. Or at least
     fetch you a good price at the market. Then you bid each other farewell.

     +1 Healing, Chance of Healing Sleep when you are resting.

EOT
	    ;;
	"$GUARDIAN_ANGEL")
	# Guardian Angel CC BY-SA (C) 2013 by Sigbjørn Smelror <biamin@sigg3.net>
	    cat <<"EOT"

                          G U A R D I A N   A N G E L
                        .    . ___            __ ,  .
                      .      /* * *\  ,~-.  / * *\    .
                            /*   .:.\ l`; )/*    *\
                     .     |*  /\ :-,_,' ()*  /\  *|    .
                           \* |  ||\__   ~'  |  | */
                      .     \* \/ |  / /\ \  \ / */   .
                             \*     / ^  ^ \    */
                        .     )* _  ^|^|^|^^ _ *(    .
                             /* /     |  |    \ *\
                       .    (*  \__,   | | .__/  *)   .
                             \*  *_*_ // )*_*   */
                        .     \* /.,  `-'   .\* /    .
                          .    \/    .   .   `\/
                            .     .         .     .
                              .                 .
     You rescue a magical fairy caught in a cobweb, and in return she
     promises to come to your aid when you are caught in a similar bind.

     +5 Health in Death if criticality is less than or equal to -5

EOT
	    ;;
	"$FAST_MAGIC_BOOTS")
	# Pussy Boots CC BY-SA (C) 2013 by Sigbjørn Smelror <biamin@sigg3.net>
	    cat <<"EOT"

                        F A S T   M A G I C   B O O T S
                              _______  _______
                             /______/ /______/
                              |   / __ |   / __
                             /   /_(  \'  /_(  \
                            (_________/________/

     You are taken captive by a cunning gnome with magic boots, holding you
     with a spell that can only be broken by guessing his riddles.
     After a day and a night in captivity you decide to counter his riddles
     with one of your own: "What Creature of the Forest is terribly Red and
     Whiny, and Nothing Else without the Shiny?"

     The gnome ponders to and fro, talking to himself and spitting, as he gets
     more and more agitated. At last, furious, he demands "Show me!" and
     releases you from the spell. Before he knows it you've stripped off his
     boots and are running away, magically quicker than your normal pace.

     +1 Flee

EOT
	    ;;
	"$QUICK_RABBIT_REACTION")
	# Japanese Rabbit CC BY-SA (C) 2013 by Sigbjørn Smelror <biamin@sigg3.net>
	    cat <<"EOT"

                    Q U I C K   R A B B I T   R E A C T I O N

                                   .^,^
                                __/ ; /____
                               / c   -'    `-.
                              (___            )
                                  _) .--     _')
                                  `--`  `---'

     Having spent quite a few days and nights out in the open, you have grown
     accustomed to sleeping with one eye open and quickly react to the dangers
     of the forests, roads and mountains in the old world, that seek every
     opportunity to best you.

     Observing the ancient Way of the Rabbit, you find yourself reacting more
     quickly to any approaching danger, whether it be day or night.

     +1 Initiative upon enemy attack

EOT
	    ;;
	"$FLASK_OF_TERRIBLE_ODOUR")
	# Weird Puppy Dragon CC BY-SA (C) 2013 by Sigbjørn Smelror <biamin@sigg3.net>
	    cat <<"EOT"

                  F L A S K   O F   T E R R I B L E   O D O U R
                        /  /    * *  /    _\ \       ___ _
                        ^ /   /  *  /     ____)     /,- \ \
                         /      __*_     / / _______   \ \ \
                 ,_,_,_,_ ^_/  (_+ _) ,_,_/_/       ) __\ \_\___
                /          /  / |  |/     /         \(   \7     \
           ,   :'      \    ^ __| *|__    \    \  ___):.    ___) \____/)
          / \  :.       |    / +      \  __\    \      :.              (\
        _//^\\  ;.      )___(~~~~~~~*~~)_\_____  )_______:___            }
        \ |  \\_) ) _____,)  \________/   /_______)          vvvVvvvVvvvV
         \|   `-.,'
     Under a steep rock wall you encounter a dragon pup's undiscovered carcass.
     You notice that its rotten fumes curiously scare away all wildlife and
     lowlife in the surrounding area.
     You are intrigued and collect a sample of the liquid in a small flask that
     you carry, to sprinkle on your body for your own protection.

     +1 Chance of Enemy Flee

EOT
	    ;;
	"$TWO_HANDED_BROADSWORD")
	# And My Two-Handed Broadsword CC BY-SA (C) 2013 by Sigbjørn Smelror <biamin@sigg3.net>
	    cat <<"EOT"

                   T W O - H A N D E D    B R O A D S W O R D
                       .   .   .  .  .  .  .  .  .  .  .  .
                  .  .   /]______________________________   .
                .  ,~~~~~|/_____________________________ \
                .  `=====|\______________________________/  .
                  .  .   \]   .  .  .  .  .  .  .  .  .   .
                        .  .
     From the thickest of forests you come upon and traverse a huge unmarked
     marsh and while crossing, you stumble upon trinkets, shards of weaponry
     and old equipment destroyed by the wet. Suddenly you realize that you are
     standing on the remains of a centuries old, long forgotten battlefield.

     On the opposite side, you climb a mound only to find the wreckage of a
     chariot, crashed on retreat, its knight pinned under one of its wheels.
     You salvage a beautiful piece of craftmanship from the wreckage;
     a powerful two-handed broadsword, untouched by time.

     +1 Strength

EOT
	    ;;
	"$STEADY_HAND_BREW")
	# That Ale CC BY-SA (C) 2013 by Sigbjørn Smelror <biamin@sigg3.net>
	    cat <<"EOT"

                      S T E A D Y   H A N D   B R E W
                              ___
                             (___)            _  _  _ _
                              | |           ,(  ( )  ) )
                             /   \         (. ^ ( ^) ^ ^)_
                            |     |        ( ~( _)- ~ )-_ \
                            |-----|         [_[[ _[[ _{  } :
                            |X X X|         [_[[ _[[ _{__; ;
                            |-----|         [_[[ _[[ _)___/
              ______________|     |   _____ [_________]
             |     | >< |   \___ _| _(     )__
             |     | >< |    __()__           )_
             |_____|_><_|___/     (__          _)
                                    (_________)

     Through the many years of travel you have found that your acquired taste
     of a strong northlandic brew served cool keeps you on your toes.

     +1 Accuracy and Initiative

EOT
	    ;;
	*)  Die "${FUNCNAME}(): Bad ARG >>>$1<<<" ;;
    esac
    echo "$HR"
}

#                                                                      #
#                                                                      #
########################################################################
