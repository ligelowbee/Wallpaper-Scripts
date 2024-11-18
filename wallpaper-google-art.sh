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

use_existing() {
    echo "Picking a local exisiting file..."
    fname=$(ls -1 "$artd" | shuf -n1)
    exec wallpaper-set.sh "$artd/$fname"
}

# if you want just paintings use this:
# url=$(curl -Ls -o /dev/null -w %{url_effective} "https://commons.wikimedia.org/wiki/Special:RandomInCategory/Google_Art_Project_paintings")

echo "Geting url of a random file from Google Arts & Culture files on wikimedia"
url=$(curl -ILs -o /dev/null -w %{url_effective} "https://commons.wikimedia.org/wiki/Special:RandomInCategory/Files_from_Google_Arts_%26_Culture")

if ! [[ "${url,,}" =~ .*(jpe?g|png)$ ]]; then
    echo "!!! Failed to get image url"
    use_existing
fi

urlfname="${url##*File:}"
# decode url encoded hex 
fname=$(printf '%b' "${urlfname//%/\\x}")
# replace system marks with safe utf8 versions  
fname="${fname//\'/’}"
fname="${fname//\"/”}"
fname="${fname//\&/＆}"
# replace m-dashes and n-dash
fname="${fname//—/-}"
fname="${fname//–/-}"

# Check if previously downloaded or local file picked
if [ -e "$fname" ]; then
    echo "Using previously downloaded file: $fname" 
    exec wallpaper-set.sh "$artd/$fname"
fi

# Try to fetch new image
echo "Fetching: $fname"
curl -o "$fname" -s -L "http://commons.wikimedia.org/w/index.php?title=Special:Redirect/file/$urlfname&width=1920&height=1080"
if [ "$?" -ne 0 ]; then
    echo "!!! Failed to fetch image: $fname"
    use_existing
fi

# Try to label new image
wallpaper-label.sh "$fname" 
if [ $? -eq 0 ]; then
    mv -vf "labeled-$fname" "$fname"
else
    echo "!!! Error labelling $fname"
fi
exec wallpaper-set.sh "$artd/$fname"

