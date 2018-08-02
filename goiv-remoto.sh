#!/usr/bin/env bash
set -o errexit; set -o errtrace; set -o pipefail # Exit on errors
# Uncomment line below for debugging:
#PS4=$'+ $(tput sgr0)$(tput setaf 4)DEBUG ${FUNCNAME[0]:+${FUNCNAME[0]}}$(tput bold)[$(tput setaf 6)${LINENO}$(tput setaf 4)]: $(tput sgr0)'; set -o xtrace
__deps=( "sed" "grep" )
for dep in ${__deps[@]}; do hash $dep >& /dev/null || (echo "$dep was not found. Please install it and try again." && exit 1); done


# Original device width and height
W=1080
H=1920

# Replay device width and height (if same nothing changes)
dWidth=1080
dHeight=1920

function click {
    if [[ $# -lt 2 ]]; then
        echo "Must supply at least 2 arguments to click(): x y [description]"
        exit
    fi

    xx=$(echo "scale=10; x = $1 / $W; x*$dWidth " | bc | awk '{printf("%d\n",$1 + 0.5)}')
    yy=$(echo "scale=10; y = $2 / $H; y*$dHeight" | bc | awk '{printf("%d\n",$1 + 0.5)}')

    echo "shell input tap $xx $yy"

    adb shell input tap $xx $yy

    [[ ! -z $3 ]] && echo $3 || true
}

echo "how many times? [300] "
read times


for (( i = 0; i < times; i++ )); do
    click 752 1307 'tap blank spot'
    click 157 1730 'tap IV button'
    click 909 1730 'tap menu'
    click 752 1307 'tap appraise'

    click 752 1307 'tap and wait'
    sleep 0.8

    click 752 1307 'tap and wait'
    sleep 0.8

    click 752 1307 'tap and wait'
    sleep 0.8

    click 752 1307 'tap and wait'
    sleep 0.8

    click 100 1300 'tap'

    click 100 1300 'tap'

    click 100 1300 'tap'


    click 770 650 'tap calculate IV'

    pokemon=$(adb shell am broadcast -a clipper.get)
    pokemon=$(adb shell am broadcast -a clipper.get)
    pokemon=$(echo ${pokemon} | sed 's/.*data\=\"\([A-Z0-9\-+][\A-Za-z0-9+-]*\).*/\1/')

    isBadClipboard=$(echo $final | grep 'PokemonId' -c)


    if [ -z $isSameAsLastOne ]; then
        isSameAsLastOne=0
    fi

    if [ "$lastPokemon" == "$pokemon" ]; then
        isSameAsLastOne=1
    fi

    click 1000 1320 'tap close button'


    #if [ "$isBadClipboard" => "1" ] | [ "$isSameAsLastOne" == "1" ]
    if [[ $isBadClipboard -ge "1" || $isSameAsLastOne -ge "1" ]]; then
        echo "something happened, pokemon is $pokemon, lastPokemon is $lastPokemon"
        echo "bye bye!"
        skipRename=1
    else
        echo "renaming pokemon $pokemon"
        skipRename=0
    fi
    lastPokemon="$pokemon"


    if [ "$skipRename" != "1" ]
    then
        click 540 880 'tap name'

        adb shell input keyevent KEYCODE_PASTE
        click 970 1200 'tap ok and wait'
        sleep 0.3
        click 520 1030 'clicking ok on pokemon and wait'
        sleep 0.3

    fi

    echo 'moving on...'
    sleep 1.2
    adb shell input swipe 900 1140 160 1140 500
done
