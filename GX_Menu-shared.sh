########################################################################
#                  Menu GX used in GPL and CC versions                 #
#                                                                      #

# Horizontal ruler used almost everywhere in the game
HR="- ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ - ~ "

GX_Credits() {
    GX_BiaminTitle
    cat <<EOF

   Back in a minute is an adventure game with 4 playable races, 6 enemies,
   8 items and 6 scenarios spread across the 270 sections of the world map.
   Biamin saves character sheets between sessions and keeps a highscore!
   The game supports custom maps too! See --help or --usage for information.

   Game directory: $GAMEDIR/

   This timekiller's written entirely in BASH. It was intended for sysadmins
   but please note that it isn't console-friendly and it looks best in 80x24
   terminal emulators (white on black). Make sure it's a window you can close.

   BASH code (C) Sigg3.net GNU GPL Version 3 2014
   ASCII art (C) Sigg3.net CC BY-NC-SA 4.0 2014 (except figlet banners)

   Visit the Back in a minute website at <$WEBURL/>
   for updates, feedback and to report bugs. Thank you.
$HR
EOF
}

GX_HowTo() {
    GX_BiaminTitle
    cat <<EOF

                          HOW TO PLAY Back in a Minute

   Go to Main Menu and hit (P)lay and enter the NAME of the character you want
   to create or whose character sheet you want to load (case-sensitive).
   You enter the World of Back in a Minute. The first sector is Home.

   Each sector gives you these action alternatives:
   (C)haracter sheet: Toggle Character Sheet
   (R)est: Sleep to gain health points
   (M)ap and travel: Toggle Map to find yourself, items and to travel
   (Q)uit: Save current status and quit the world of Back in a Minute
   Use W, A, S, D keys to travel North, West, South or East directly.

   Travelling and resting involves the risk of being attacked by the creatures
   inhabiting the different scenarios. Some places are safer than others.
   For more information please visit <$WEBURL/>
$HR
                    Press any key to return to (M)ain Menu
EOF
    read -sn 1
}

GX_Races() {
    clear
    cat <<EOF

                        C H A R A C T E R   R A C E S :

      1. MAN            2. ELF              3. DWARF            4. HOBBIT

   Healing:  3/6      Healing:  4/6       Healing:  2/6        Healing:  4/6
   Strength: 3/6      Strength: 3/6       Strength: 5/6        Strength: 1/6
   Accuracy: 3/6      Accuracy: 4/6       Accuracy: 3/6        Accuracy: 4/6
   Flee:     3/6      Flee:     1/6       Flee:     2/6        Flee:     3/6


   Dice rolls on each turn. Accuracy also initiative. Healing during resting.
   Men and Dwarves start with more gold, Elves and Hobbits with more tobacco.

$HR
EOF
}

#                                                                      #
#                                                                      #
########################################################################

