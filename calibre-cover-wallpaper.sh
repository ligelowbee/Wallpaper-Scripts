#!/bin/bash
#Make labeled wallpaper from calibre covers
calibred="$HOME/Ebooks/calibre"
artd="$HOME/Pictures/Wallpaper/"
origc=$(find "$calibred" -name "cover.jpg" | shuf -n1)
fname=$(awk 'BEGIN {FS="/"};{printf "%s - %s.jpg",$(NF-2),$(NF-1)}' <<< "$origc")
cd "$artd"
if [ ! -e "$fname" ]; then
    cp "$origc" "$fname"
fi

label-wallpaper.sh "$fname"
if [ $? -eq 0 ]; then
    mv -f "labeled-$fname" "$fname"
fi

cinnamon-set-wallpaper.sh "$artd/$fname"
