**Grrr!** - GoIV remote recorded renamer
=====

_A shell script for renaming pokémons in Pokémon Go using GoIV, adb shells and a recorded macro._

## What does it do?

**Grrr!** renames your pokémons in PGO programatically, i.e.: without manual intervention.

After each pokémon, it swipes *left to right*, and starts again.

### Important note

**Grrr!**'s reliability is prioritized against speed, so take a long sit if you're thinking in renaming all your Pokémons at once.

In average, it takes from **20 to 50 seconds per pokémon,** depending on the device's overall "speed", temperature _(yeah...),_ and other factors.

Because of this, **Grrr!** takes a user input in time format, so you can rename while you're in cooldown, or doing something else.


## How to use

- If you're rooted, download and install [clipper](https://github.com/majido/clipper) in your device.

- Connect the device via `adb` to the computer

- Open GoIV

- Open Pokémon Go

- Open your pokémon list and select a pokémon to begin with

- Dim your screen as much as possible

- Run **Grrr!** on your computer:
        $ ./Grrr

    - If you don't have **clipper** installed, run:
            $ ./Grrr --no-clipper

- Type for how long would you like to run it:
    - Valid formats:
            16 minutes
            2hours
            90 seconds
            16              (if no unit is given it's an alias to minutes)

- Press Enter, watch and relax! :D