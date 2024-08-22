#!/bin/bash
# wallpaper-change.sh
# Set wall paper as either calibre cover, google art, or random existing image.
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
