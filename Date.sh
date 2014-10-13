########################################################################
#                             Date                                     #
#                                                                      #


# Load global calendar variables (used in DateFromTurn() and Almanac())
YEAR_LENGHT=365 # Gregorian calendar without leap years
YEAR_MONTHES=12 # How many monthes are in year?

MONTH_STR=(
    # Month name #Month lenght #Month total lenght  #Month trivia
    "Biamin Festival"    0  0   "Rarely happens, if ever :(" # Arrays numeration starts from 0, so we need dummy ${MONTH_LENGTH[0]}
    "After-Frost"        31 31  "1st Month of the Year\n This is the coldest and darkest month of the year. Stay in, stay warm."       
    "Marrsuckur"         28 59  "2nd Month of the Year\n \"Marrow-sucker\" is a lean month. Some nobles have a custom of fasting."     
    "Plough-Tide"        31 90  "3rd Month of the Year\n Farmers return to their ploughs. Hobbit villages celebrate Springtide."       
    "Anorlukis"          30 120 "4th Month of the Year\n The winter darkness is overwon by Anor's arrows. Holy month for Elves."       
    "Summer-Tide"        31 151 "5th Month of the Year\n Middle of year. While the heat is welcoming, watch out for orcs and goblins!" 
    "Summer-Turn"        30 181 "6th Month of the Year\n A celebration of the Turn of Anor, in which one gives thanks for any good."   
    "Merentimes"         31 212 "7th Month of the Year\n From 'Meren' (happiness). This warm month is oft celebrated by travellers."   
    "Harvest Month"      31 243 "8th Month of the Year\n Autumn is the busiest time of year. And evil grows in the wilderness."        
    "Ringorin"           30 273 "9th Month of the Year\n From 'Ringorn' (circle, life, produce). Holy month for farmers."              
    "Brew-Tasting Tide"  31 304 "10th Month of the Year\n Traditional tasting of ales begin this month. Don't venture about alone."    
    "Winter Month"       30 334 "11th Month of the Year\n By now the stocks are full of produce. Livestock & people shelter in."       
    "Midwinter Offering" 31 365 "12th Month of the Year\n The Offering is a significant and holy event for priests and people alike."  
)

MonthString()      { echo ${MONTH_STR[((  $1 * 4      ))]} ;}
MonthLength()      { echo ${MONTH_STR[(( ($1 * 4) + 1 ))]} ;}
MonthTotalLength() { echo ${MONTH_STR[(( ($1 * 4) + 2 ))]} ;}
MonthTrivia()      { echo ${MONTH_STR[(( ($1 * 4) + 3 ))]} ;}

WEEK_LENGTH=7 # How many days are in week?
WEEKDAY_STR=(
    # Weekday    # Short trivia                       # Long trivia
    "Ringday (Holiday)" "Day of Festivities and Rest" "Men and Halflings celebrate Ringday as the end and beginning of the week."   
    "Moonday"   "Mor's Day (Day of the Moon)"         "Elves and Dwarves once celebrated Moon Day as the holiest. Some still do."   
    "Brenday"   "Brenia's Day (God of Courage)"       "Visit the Temple on Brenia's Day to honor those who perished in warfare."    
    "Midweek"   "Middle of the Week (Day of Balance)" "In some places, Midweek Eve is celebrated with village dances and ale."      
    "Braigday"  "Braig's Day (God of Wilderness)"     "Historically, a day of hunting. Nobility still hunt every Braig's Day."      
    "Melethday" "Melethril's Day (God of Love)"       "Commonly considered Lovers' Day, it is also a day of mischief and trickery." 
    "Washday"   "Final Workday of the Week"           "Folk name for Lanthir's Day, the God of Water, Springs and Waterfalls."      
)

WeekdayString()      { echo ${WEEKDAY_STR[((  $1 * 3      ))]} ;}
WeekdayTriviaShort() { echo ${WEEKDAY_STR[(( ($1 * 3) + 1 ))]} ;}
WeekdayTriviaLong()  { echo ${WEEKDAY_STR[(( ($1 * 3) + 2 ))]} ;}



DateFromTurn() { # Some vars used in Almanac(
    # Find out which YEAR we're in
    YEAR=$( bc <<< "( $TURN / $YEAR_LENGHT ) + 1" )
    local REMAINDER=$( bc <<< "$TURN % $YEAR_LENGHT" )           # month and days
    (( REMAINDER == 0 )) && ((YEAR--)) && REMAINDER=$YEAR_LENGHT # last day of year fix
    (( YEAR > 99 )) && YEAR=$( bc <<< "$YEAR % 100" ) # FIX for year > 100
    # # Determine Century, used in Almanac() calculations
    # # The thought was originally: century, cycle, age.. Table it for now
    CENTURY=$( bc <<< "(($YEAR+200)/100)*100" ) # We start in year 2nn, actually :)
#    YEAR=$(Ordial "$YEAR") # Add year postfix
    # Find out which MONTH we're in
    for ((i=1; i <= YEAR_MONTHES; i++)); do ((REMAINDER <= $(MonthTotalLength "$i") )) && MONTH_NUM=$i && break; done
    MONTH=$(MonthString "$MONTH_NUM")
    # Find out which DAY we're in
    DAY_NUM=$( bc <<< "$REMAINDER - $(MonthTotalLength $((MONTH_NUM - 1)) )" ) # Substract PREVIOUS months length # DAY_NUM used in Almanac
    DAY=$(Ordial "$DAY_NUM") # Add day postfix
    # Find out which WEEKDAY we're in
    WEEKDAY_NUM=$( bc <<< "$TURN % $WEEK_LENGTH" )
    WEEKDAY=$(WeekdayString "$WEEKDAY_NUM")
    # Find out which MOON cycle we're in
    case $( bc <<< "( $TURN % 31 )" ) in		 # TODO Add instructions Not sure how this works
    	0 | 1 )             MOON="New Moon"         ;;
    	2 | 3 | 4 | 5 )     MOON="Growing Crescent" ;;
    	6 | 7 | 8 | 9 )     MOON="First Quarter"    ;;
    	10 | 11 | 12 | 13 ) MOON="Growing Gibbous"  ;;
    	14 | 15 | 16 | 17 ) MOON="Full Moon"        ;;
    	18 | 19 | 20 | 21 ) MOON="Waning Gibbous"   ;;
    	22 | 23 | 24 | 25 ) MOON="Third Quarter"    ;;
    	26 | 27 | 28 | 29 ) MOON="Waning Crescent"  ;;
    	* )                 MOON="Old Moon"         ;; # Same as New Moon
    esac
    # Output example "3rd of Year-Turn in the 13th cycle"
    BIAMIN_DATE_STR="$DAY of $MONTH in the $(Ordial $YEAR) Cycle"
}

TurnFromDate() { # Creation() ?
    local TODAYS_YEAR TODAYS_MONTH TODAYS_DATE
    read -r "TODAYS_YEAR" "TODAYS_MONTH" "TODAYS_DATE" <<< "$(date '+%-y %-m %-d')"
    local TURN=$(bc <<< "($TODAYS_YEAR * $YEAR_LENGHT) + $(MonthLength $TODAYS_MONTH) + $TODAYS_DATE")
    echo $TURN
}

TodaysDate() {
    # An adjusted version of warhammeronline.wikia.com/wiki/Calendar
    # Variables used in DisplayCharsheet () ($TODAYS_DATE_STR), and
    # in FightMode() ($TODAYS_DATE_STR, $TODAYS_DATE, $TODAYS_MONTH, $TODAYS_YEAR)

    # if [[ $CREATION == 0 ]] ; then # first run
    read -r "TODAYS_YEAR" "TODAYS_MONTH" "TODAYS_DATE" <<< "$(date '+%-y %-m %-d')"
    # else
    # just increment date, month and/or year..
    # fi
    # TODO: Add CREATED or CREATION + DATE in charsheets:) Would be nice to have them after the char name..
    # NOTE: We probably shouldn't use $DATE but $BIAMIN_DATE or $GAMEDATE.
    
    TODAYS_DATE=$(Ordial "$TODAYS_DATE")        # Adjust date
    TODAYS_MONTH=$(MonthString "$TODAYS_MONTH") # Adjust month
    TODAYS_YEAR=$(Ordial "$TODAYS_YEAR")        # Adjust year
    # Output example "3rd of Year-Turn in the 13th cycle"
    TODAYS_DATE_STR="$TODAYS_DATE of $TODAYS_MONTH in the $TODAYS_YEAR Cycle"
}


#                                                                      #
#                                                                      #
########################################################################

