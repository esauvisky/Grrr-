#!/usr/bin/env bash
#set -o errexit; set -o errtrace; set -o pipefail # Exit on errors
# Uncomment line below for debugging:
#PS4=$'+ $(tput sgr0)$(tput setaf 4)DEBUG ${FUNCNAME[0]:+${FUNCNAME[0]}}$(tput bold)[$(tput setaf 6)${LINENO}$(tput setaf 4)]: $(tput sgr0)'; set -o xtrace
__deps=( "sed" "grep" "bc" )
for dep in ${__deps[@]}; do hash $dep >& /dev/null || (echo "$dep was not found. Please install it and try again." && exit 1); done


# Original device width and height
W=1080
H=1920

# Replay device width and height (if same nothing changes)
#dWidth=1080
#dHeight=1920
dWidth=$(adb shell wm size | sed 's/..* \([0-9][0-9]*\)x..*/\1/')
dHeight=$(adb shell wm size | sed 's/..* [0-9][0-9]*x\([0-9][0-9]*\)$/\1/')

isSameAsLastOne=0

#echo "Starting clipper..."
#adb shell "am startservice ca.zgrs.clipper/.ClipboardService"
echo "Clearing clipboard..."
adb shell 'am broadcast -a clipper.set -e text ""'


function click {
    if [[ $# -lt 2 ]]; then
        echo "Must supply at least 2 arguments to click(): x y [description]"
        exit
    fi

    xx=$(echo "scale=10; x = $1 / $W; x*$dWidth " | bc | awk '{printf("%d\n",$1 + 0.5)}')
    yy=$(echo "scale=10; y = $2 / $H; y*$dHeight" | bc | awk '{printf("%d\n",$1 + 0.5)}')

    #echo "shell input tap $xx $yy"

    adb shell input tap $xx $yy

    [[ ! -z $3 ]] && echo $3 || true
}

echo "how many times? [300] "
read times


for (( i = 0; i < times; i++ )); do
    time=$(date +%s)
    click 752 1307 'tap blank spot'

    click 157 1730 'tap IV button and wait a lot'
    sleep 2

    click 909 1730 'tap menu'
    click 752 1307 'tap appraise and wait'
    sleep 1
    click 752 1307 'tap and wait a looot'
    sleep 5

    click 752 1307 'tap and wait'
    sleep 0.75

    click 752 1307 'tap and wait'
    sleep 0.75

    click 752 1307 'tap and wait'
    sleep 0.75

    click 752 1307 'tap and wait'
    sleep 0.75

    click 100 1300 'tap'

    click 100 1300 'tap'

    click 100 1300 'tap'


    click 770 650 'tap calculate IV'

    pokemon=$(adb shell am broadcast -a clipper.get)
    pokemon=$(echo ${pokemon} | sed 's/.*data\=\"\([A-Z0-9\-+][\A-Za-z0-9+-]*\).*/\1/')

    isBadClipboard=$(echo $pokemon | egrep 'PokemonId|Broadcasting|Intent' -c)

    if [ "$lastPokemon" == "$pokemon" ]; then
        isSameAsLastOne=1
    else
        isSameAsLastOne=0
    fi

    click 1000 1320 'tap close button'


    if [[ $isBadClipboard -ge "1" || $isSameAsLastOne -ge "1" ]]; then
        echo "something happened, pokemon is $pokemon, lastPokemon is $lastPokemon"
        echo isBadClipboard$isBadClipboard
        echo isSameAsLastOne$isSameAsLastOne
        echo "bye bye!"
        skipRename=1
    else
        echo "renaming pokemon $pokemon. wait a lot..."
        sleep 1.5
        skipRename=0
    fi

    lastPokemon="$pokemon"

    if [ "$skipRename" != "1" ]; then
        click 540 880 'tap name'

        adb shell input keyevent KEYCODE_PASTE
        adb shell input keyevent TAB
        adb shell input keyevent KEYCODE_ENTER
        click 520 1030 'clicking ok on pokemon'

    fi

    echo 'moving on...'
    sleep 1.2
    adb shell input swipe 900 1140 160 1140 500
    echo "The round took $(( $(date +%s) - $time )) seconds"
done
