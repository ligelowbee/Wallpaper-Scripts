#!/bin/bash
# google-art-wallpaper.sh should only fetch from wikimedia.
# calibre-cover-wallpaper.sh should only fetch from calibre covers.
# use this file to pick a local, google, or calibre.

artd="$HOME/Pictures/Wallpaper"

if (( RANDOM % 3 )); then 
    # 2/3 the time (when mod not 0) use a local file
    if (( RANDOM % 2 )); then 
        # 1/2 the time use a book cover
        exec calibre-cover-wallpaper.sh
    else
        fname=$(ls -1 "$artd" | shuf -n1)
        echo "Using existing file: $fname" 
        cinnamon-set-wallpaper.sh "$artd/$fname"
    fi
else
    exec google-art-wallpaper.sh
fi
