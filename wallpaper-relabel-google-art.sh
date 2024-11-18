#!/bin/bash
# wallpaper-relabel-google-art.sh
if [ "$#" -ne 1 ] || [ ! -f "$1" ]; then
    echo "Usage: ${0##*/} FILENAME"
    echo "Attempts to redownload and label image from google art"
    echo "with possible translations (using translate-shell)."
    exit
fi

fname="$1"
echo "Filename: $fname"

read -p "Attempt to translate filename y/n > "
if [ "$REPLY"x == "y"x ]; then
    newfname=$(trans -b "${fname//_/ }")
    newfname="${newfname// /_}"
else
    newfname="$fname"
fi

read -e -i "$newfname" -p "Enter new filename to use > "
if [ -z "$REPLY" ]; then
    echo "No filename given, aborting"
    exit
else
    newfname="$REPLY"
fi

# create url version of fname
# convert utf8 symbols back to ascii, may still need n-/m-dashes
urlfname="${fname//’/\'}"
urlfname="${urlfname//”/\"}"
urlfname="${urlfname//＆/\&}"
# need uri encoded fname for curl
urlfname=$(urienc.py "$urlfname")
# remove the local path
urlfname="${urlfname##*/}"
curl -o "$newfname" -L "http://commons.wikimedia.org/w/index.php?title=Special:Redirect/file/$urlfname&width=1920&height=1090"
if [ $? -ne 0 ]; then
    echo "Error, curl could not fetch: $urlfname"
    exit 1
elif grep "DOCTYPE html" "$newfname"; then
    echo "!!! Error downloaded redirect page instead of jpg"
    echo "url: $urlfname" 
    exit 1
fi

wallpaper-label.sh "$newfname"
if [ $? -eq 0 ]; then
    rm "$newfname"
    rm "$fname"
    mv "labeled-$newfname" "$fname"
    ln "$fname" "$newfname"
    xdg-open "$fname"
else
    echo "Unable to rename and label $newfname"
fi
