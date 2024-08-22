#!/bin/bash
# google-art-wallpaper.sh should only fetch from wikimedia.
# calibre-cover-wallpaper.sh should only fetch from calibre covers.
# use this file to pick a local, google, or calibre.

artd="$HOME/Pictures/Wallpaper"

if (( RANDOM % 2 )); then 
    if (( RANDOM % 2 )); then 
        exec wallpaper-calibre.sh
    else
        fname=$(ls -1 "$artd" | shuf -n1)
        echo "Using existing file: $fname" 
        wallpaper-set.sh "$artd/$fname"
    fi
else
    exec wallpaper-google-art.sh
fi
