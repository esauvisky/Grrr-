doneRecording() {
    killall eventrec 2>/dev/null
}
trap doneRecording SIGINT

n=0
while [ -f recording$n ]; do
    n=$((n+1))
done

# if [ ! -f ./bin/eventrec ]; then
#     echo "Error, eventrec is not present on ./bin"
# elif [ ! -f /system/bin/eventrec ]; then
#     su
#     cp ./bin/eventrec
# fi

echo "Press Ctrl+Z anytime to exit the script."

echo -n "What's the Pokémon? "
read name
echo -n "What's the width from screen's left margin to the circle (in pixels)?: "
read pokWidth
echo -n "What's the height from the top of the screen to the bottom of the circle (i.e.: the Pokémon height from the ground)?: "
read pokHeight

echo
echo "OK! Now adjust circle, press Enter to begin recording and wait for it to attack."
echo "Do not touch anything else! As soon as the Pokémon attacks, throw the pokeball."
echo "Then, press Ctrl+C to finish the recording."
read

while [ -z $score ]; do
    echo "!! RECORDING !!"
    eventrec -r recording$n
    echo 'Was it good? If you want to save it, type which score you got (Nice, Great or Excellent).'
    echo 'Otherwise leave it empty and try again! :)'
    read score
    if [ ! -z $score ]; then
        echo "Moving recording to ./Saved/W$pokWidth-H$pokHeight-$name-$score..."
        cp ./recording$n "./Saved/W$pokWidth-H$pokHeight-$name-$score"
    else
        echo "Trashing recording..."
        mv ./recording$n "./Trashed/$name-recording$n"
    fi
done
