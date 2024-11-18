#!/bin/bash
# wallpaper-change.sh
# Set wall paper as either calibre cover, google art, or random existing image.
artd="$HOME/Pictures/Wallpaper"
if [[ "$1" == "-q" ]]; then
    #restart quiet
    exec "$0" >/dev/null 2>&1
fi

# half the time use a local existing file
if (( RANDOM % 2 )); then 
    # a third of those times pick a book cover (true when 0)
    if ! (( RANDOM % 3 )); then 
        exec wallpaper-calibre.sh
    else
        fname=$(ls -1 "$artd" | shuf -n1)
        echo "Using existing file: $fname" 
        exec wallpaper-set.sh "$artd/$fname"
    fi
else
    exec wallpaper-google-art.sh
fi
