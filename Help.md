<h1>Help Document</h1>

# Installation Guide


## System Requirements:
1. MacOS with terminal and afplay media player.
2. Working audio hardware to play sound.

## Install Homebrew:
Run the commands below in terminal:


```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew analytics off

brew update

brew tap caskroom/cask
```
## Install rbenv:

Run the commands below in terminal:
```bash
brew install rbenv
rbenv
```
Close terminal for changes to take effect.

## Install Ruby:
Run the commands below in terminal:
```bash
rbenv install 2.7.0
```

## Install dependency of this program (gems):
Run the commands below in terminal:
```bash
gem install colorize
gem install tty-font
gem install tty-prompt
gem install wavefile
```

## Download source code from github:
<a href="https://github.com/bcehmu/improv-freestyle/archive/master.zip">Source Code : improv-freestyle</a>

Extract to a loal folder where you enter for running the program. 
Run the command below in terminal after entering the folder:
```bash
ruby main.rb
```

## To customize samples, replace any wav files in the folders below:
\audio-samples\lib-drum\

\audio-samples\lib-drum\

\audio-samples\lib-melodic\

* files should be named sample1.wav or sample2.wav or sample3.wav
* files should be of format wav, (44100HZ, PCM 16 bits, stereo)

# How to Play

## Two ways to use the main.rb program

### 1. Directly generate a wave file of track using command-line arguments. 

Append first argument 1 or 2 or 3 as the sample library to use (1 for drum, 2 for bass, 3 for melodic), second argument as the tempo in bpm, third argument is the text to be interpreted to a wave file. For example, command below generate a drum track at 100 bpm.
```bash
ruby main.rb 1 100 s-ssd-ddf-ff
```

### 2. Enter the menu without argument.

Run the command below in terminal after entering the folder of local copy:
```bash
ruby main.rb
```
## Navigate through menu

* Use ↑/↓ arrow keys to navigate along the menu, press Enter to select.

* Select "Tutorial" or "Listen to sample files" anytime for reference.

## Improvise by typing

### Choose a library(samples set) to work on or mix them into one wave file:

In the "Improvise by typing" session, select any of "Drum", "Bass", "Melodic" for a library you want to work with. Selecting "Synth!" if you want to combine all the three track together. For each track (drum/bass/melodic), only the last editing is saved to be combined.

### Editing of score
#### No worry about typo:

Only the effective keys you typed affect the result, other keys are ignored. So non-effective keys could be used as decoration for readability. For example, if you type "s-d-f vbnm 67890 sdf-" is the same as "s-d-fsdf-".

#### Effective keys:

1. a, s, d
are sample1, sample2, sample3, which are wave files to be used here.
2. dash - is the rest,which is emptyness occupying time of certain duration.
3. Duration of following notes could be specified using keys y, u, i, o, p for evenly-divided-beats (1,1/2,1/4,1/8,1/16 respectively), keys h, j, k for triplets (1/3,1/6,1/12 respectively).

#### No Limitation for multi-lines input

1. Add more instructions if you want after one line. Enter key changes line but doesn't affect the result.
2. Add a ']' at last and press Enter if finished, the last line containing ']' will still be concatenated to the instructions sequence.

## Wave files saved locally

Exported wave files are saved in the same directory. 


