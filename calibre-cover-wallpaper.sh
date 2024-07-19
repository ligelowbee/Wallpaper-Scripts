#!/bin/bash
#Make labeled wallpaper from calibre covers
artd="/home/yargo/Pictures/Wallpaper/"
origc=$(find ~/Ebooks/calibre -name "cover.jpg" | shuf -n1)
fname=$(awk 'BEGIN {FS="/"};{printf "%s - %s.jpg",$(NF-2),$(NF-1)}' <<< "$origc")
cd "$artd"
cp "$origc" "$fname"
label-wallpaper.sh "$fname"
if [ $? -eq 0 ]; then
    mv -f "labeled-$fname" "$fname"
fi

cinnamon-set-wallpaper.sh "$artd/$fname"
