#!/bin/bash
# wallpaper-google-art.sh
# Fetch a random image of art from Wikimedia's Google Arts & Culture collection
# then resize and label it as wallpaper.

if [ "$1" == "-h" ]; then
    echo "USAGE: ${0##*/} "
    echo "  Download and label art from Wikimedia"
    exit
fi

artd="$HOME/Pictures/Wallpaper"
mkdir -p "$artd"
cd "$artd"

echo "Geting url of a random file from Google Arts & Culture files on wikimedia"
url=$(curl -ILs -o /dev/null -w %{url_effective} "https://commons.wikimedia.org/wiki/Special:RandomInCategory/Files_from_Google_Arts_%26_Culture")

# if you want just paintings use this:
# url=$(curl -Ls -o /dev/null -w %{url_effective} "https://commons.wikimedia.org/wiki/Special:RandomInCategory/Google_Art_Project_paintings")

urlfname="${url##*File:}"
# decode url fname for filesystem
fname=$(printf '%b' "${urlfname//%/\\x}")

if ! [[ "${fname,,}" =~ .*(jpe?g|png)$ ]]; then
    echo "urlfname: $urlfname"
    echo "!!! Failed to get image url."
    exit
fi

# if not already downloaded fetch and label
if [ ! -e "$fname" ]; then
    echo "Fetching: $fname"
    curl -o "$fname" -s -L "http://commons.wikimedia.org/w/index.php?title=Special:Redirect/file/$urlfname&width=1920&height=1080"

    wallpaper-label.sh "$fname" 
    if [ $? -eq 0 ]; then
        mv -f "labeled-$fname" "$fname"
    else
        echo "!!! Error labelling $fname"
    fi
else
    echo "Using existing: $fname"
fi

wallpaper-set.sh "$artd/$fname"

