########################################################################
#                             Date                                     #
#                                                                      #

# Year has 360 days ( 12 monthes x 30 days)
# Weekday has 7 days
# One moon phase has 4 days
# Moon has 8 phases
# Moon month has 32 days

# Declare global calendar variables (used in DateFromTurn(),Almanac() and MakeCalendar())
declare -r YEAR_LENGHT=360                       # How many days are in year?
declare -r YEAR_MONTHES=12                       # How many monthes are in year?
declare -r MONTH_LENGTH=30                       # How many days are in month?
declare -r MOON_PHASE_LENGTH=4                   # How many days one Moon Phase lenghts
declare -r MOON_CYCLE=$((MOON_PHASE_LENGTH * 8)) # How many days are in moon month? (8 phases * $MOON_PHASE_LENGTH) ATM == 32.

# Moon Phases names
declare -r MOON_STR=("New Moon" "Growing Crescent" "First Quarter" "Growing Gibbous" "Full Moon" "Waning Gibbous" "Third Quarter" "Waning Crescent")

# Month names and trivia
declare -r -a MONTH_STR=(
    # Month name         # Month trivia
    "Biamin Festival"    "Rarely happens, if ever :(" # Arrays numeration starts from 0, so we need dummy ${MONTH_LENGTH[0]}
    "After-Frost"        "1st Month of the Year\n This is the coldest and darkest month of the year. Stay in, stay warm."       
    "Marrsuckur"         "2nd Month of the Year\n \"Marrow-sucker\" is a lean month. Some nobles have a custom of fasting."     
    "Plough-Tide"        "3rd Month of the Year\n Farmers return to their ploughs. Hobbit villages celebrate Springtide."       
    "Anorlukis"          "4th Month of the Year\n The winter darkness is overwon by Anor's arrows. Holy month for Elves."       
    "Summer-Tide"        "5th Month of the Year\n Middle of year. While the heat is welcoming, watch out for orcs and goblins!" 
    "Summer-Turn"        "6th Month of the Year\n A celebration of the Turn of Anor, in which one gives thanks for any good."   
    "Merentimes"         "7th Month of the Year\n From 'Meren' (happiness). This warm month is oft celebrated by travellers."   
    "Harvest Month"      "8th Month of the Year\n Autumn is the busiest time of year. And evil grows in the wilderness."        
    "Ringorin"           "9th Month of the Year\n From 'Ringorn' (circle, life, produce). Holy month for farmers."              
    "Brew-Tasting Tide"  "10th Month of the Year\n Traditional tasting of ales begin this month. Don't venture about alone."    
    "Winter Month"       "11th Month of the Year\n By now the stocks are full of produce. Livestock & people shelter in."       
    "Midwinter Offering" "12th Month of the Year\n The Offering is a significant and holy event for priests and people alike."  
)

#-----------------------------------------------------------------------
# Month*()
# Returns $MONTH name and trivia. 
# Arguments: $MONTH(int [0-11])
# TODO: add check for $1 size
#-----------------------------------------------------------------------
MonthString()      { echo ${MONTH_STR[((  $1 * 2      ))]} ;} # Return month $1 name
MonthTrivia()      { echo ${MONTH_STR[(( ($1 * 2) + 1 ))]} ;} # Return month $1 trivia

declare -r WEEK_LENGTH=7 # How many days are in week?
declare -r -a WEEKDAY_STR=(
    # Weekday           # Short trivia                        # Long trivia
    "Ringday (Holiday)" "Day of Festivities and Rest"         "Men and Halflings celebrate Ringday as the end and beginning of the week."   
    "Moonday"           "Mor's Day (Day of the Moon)"         "Elves and Dwarves once celebrated Moon Day as the holiest. Some still do."   
    "Brenday"           "Brenia's Day (God of Courage)"       "Visit the Temple on Brenia's Day to honor those who perished in warfare."    
    "Midweek"           "Middle of the Week (Day of Balance)" "In some places, Midweek Eve is celebrated with village dances and ale."      
    "Braigday"          "Braig's Day (God of Wilderness)"     "Historically, a day of hunting. Nobility still hunt every Braig's Day."      
    "Melethday"         "Melethril's Day (God of Love)"       "Commonly considered Lovers' Day, it is also a day of mischief and trickery." 
    "Washday"           "Final Workday of the Week"           "Folk name for Lanthir's Day, the God of Water, Springs and Waterfalls."      
)

#-----------------------------------------------------------------------
# Weekday*()
# Returns $WEEKDAY name, short and long trivia. 
# Arguments: $WEEKDAY(int [0-6])
# TODO: add check for $1 size
#-----------------------------------------------------------------------
WeekdayString()      { echo ${WEEKDAY_STR[((  $1 * 3      ))]} ;} # Return weekday $1 name 
WeekdayTriviaShort() { echo ${WEEKDAY_STR[(( ($1 * 3) + 1 ))]} ;} # Return weekday $1 short trivia
WeekdayTriviaLong()  { echo ${WEEKDAY_STR[(( ($1 * 3) + 2 ))]} ;} # Return weekday $1 long trivia

#-----------------------------------------------------------------------
# TurnFromDate()
# Get $TURN from current (real) date
# IDEA: rename to Creation() ?
#-----------------------------------------------------------------------
TurnFromDate() { 
    local YEAR MONTH DAY
    read -r "YEAR" "MONTH" "DAY" <<< "$(date '+%-y %-m %-d')"
    bc <<< "($YEAR * $YEAR_LENGHT) + ($MONTH_LENGTH * $MONTH) + $DAY"
}

#-----------------------------------------------------------------------
# DateFromTurn()
# Arguments: $TURN(int)
#-----------------------------------------------------------------------
DateFromTurn() { # Some vars used in Almanac(
    # The thought was originally: century, cycle, age.. Table it for now (sigge)
    # By atm age == cycle as I understand it. Isn't it right? (kstn)

    # get date
    YEAR=$(bc <<< "$TURN / $YEAR_LENGHT")                       # Find out which YEAR we're in
    CENTURY=$(bc <<< "($YEAR / 100) + 200" )                    # Find out which CENTURY we're in (We start in year 2nn, actually :) )
    ((YEAR >= 100)) && YEAR=$(bc <<< "$YEAR % 100")             # Cut down years more than 100 
    local REMAINDER=$(bc <<< "$TURN % $YEAR_LENGHT")            # Month + days
    MONTH=$(bc <<< "$REMAINDER / $MONTH_LENGTH")                # Find out which MONTH we're in   # 0-11
    DAY=$(bc <<< "$REMAINDER % $MONTH_LENGTH")                  # Find out which DAY we're in     # 0-29
    WEEKDAY=$( bc <<< "$TURN % $WEEK_LENGTH" )                  # Find out which WEEKDAY we're in # 0-6
    MOON=$(bc <<< "($TURN % $MOON_CYCLE) / $MOON_PHASE_LENGTH") # Find out current Moon Phase     # 0-7
    
    # Fix date (AFTER getting MONTH, DAY, etc !!!)
    ((DAY++))
    ((MONTH++))
    ((YEAR++))

    # Output example "3rd of Year-Turn in the 13th cycle"
    BIAMIN_DATE_STR="$(Ordial $DAY) of $(MonthString $MONTH) in the $(Ordial $YEAR) Cycle"
}


# Global variable for calendar
CALENDAR=()

#-----------------------------------------------------------------------
# MakeCalendar()
# Full calendar array like
# ---
# CALENDAR=(
#     "                 1  2"
#     "  3  4  5  6  7  8  9"
#     " 10 11 12 13 14 15 16"
#     " 17 18 19 20 21 22 23"
#     " 24 25 26 27 28 29 30"
# )
# ---
# Array can be displayed this way:
# ---
# i=0
# while [[ "${CALENDAR[i]}" ]]; do
#     echo "${CALENDAR[$((i++))]}"
# done
# ---
# or
# ---
# for ((i = 0; ; i++)) ; do
#     [[ "${CALENDAR[i]}" ]] || break
#     MvAddStr $(($y + $i)) $x "${CALENDAR[i]}"
# done
# ---
#-----------------------------------------------------------------------
MakeCalendar() {
    local a=0 i
    CALENDAR=()                                                                # Reset old calendar
    local FIRSTDAY=$((TURN - DAY + 1))                                         # Find 1st day of month. NB DAYS are 0-29
    FIRSTDAY=$( bc <<< "$FIRSTDAY % $WEEK_LENGTH" )                            # Find which day of week is FIRSTDAY. NB 0 is Sunday !!!
    ((FIRSTDAY == 0)) && FIRSTDAY=7                                            # Fix Sunday from 0 to 7 
    ((FIRSTDAY > 1)) && CALENDAR[a]=$(printf "%$(((FIRSTDAY - 1) * 3 ))c" " ") # Add spaces if FIRSDAY is not Monday
    for ((i = 1; i <= MONTH_LENGTH; i++)) ; do                                 #  and fill Calendar array 
	CALENDAR[a]+=$(printf " %2i" "$i")
	(( $(Strlen "${CALENDAR[a]}") == 21)) && ((a++))
    done
}

#                                                                      #
#                                                                      #
########################################################################

