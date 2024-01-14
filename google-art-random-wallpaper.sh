#!/bin/bash
artd="$HOME/Pictures/Google-Art-Project"
mkdir -p "$artd"
cd "$artd"
if [ -e "$1" ]; then
    fname="$1"
else
    # Get url of a random file from Google Arts & Culture files on wikimedia
    url=$(curl -ILs -o /dev/null -w %{url_effective} "https://commons.wikimedia.org/wiki/Special:RandomInCategory/Files_from_Google_Arts_%26_Culture")

    # if you want just paintings use this:
    # url=$(curl -Ls -o /dev/null -w %{url_effective} "https://commons.wikimedia.org/wiki/Special:RandomInCategory/Google_Art_Project_paintings")

    urlfname="${url##*File:}"
    # convert url escapes to actual symbols for fname
    fname=$(printf '%b' "${urlfname//%/\\x}")
fi

if [ ! -e "$fname" ]; then
    # this returns full size original, sometimes too large for imagemagick
    # wget -q -N -c "http://commons.wikimedia.org/wiki/Special:Redirect/file/$urlfname"
    # ask for smaller version
    curl -o "$fname" -s -L "http://commons.wikimedia.org/w/index.php?title=Special:Redirect/file/$urlfname&width=1920&height=1090"

    label="${fname//_/ }"
    eol=$'\n'
    label="${label// - /$eol}"

    width=1920
    height=1090
    pts=20

    ## Resize to width x height with black borders and label
    convert "$fname" -resize "$width"x"$height" -background Black \
            -gravity center -extent "$width"x"$height" \
            -font "Noto-Sans-Regular" -pointsize "$pts" \
            -draw "gravity SouthEast fill black text 10,4 \"$label\"" \
            -draw "gravity SouthEast fill white text 8,6 \"$label\"" \
            "labeled-$fname"

    if [ $? -eq 0 ]; then
        mv -f "labeled-$fname" "$fname"
    else
        echo "Error, Convert failed for $fname, not setting background"
        exit
    fi
fi

IMM="$HOME/Desktop/wallpaper.jpg"
ln -s -f "$artd/$fname" "$IMM"
for monitor in $(xrandr --listactivemonitors|awk 'NR>1 {print $NF}'); do
    PROP="/backdrop/screen0/monitor$monitor/workspace0/last-image"
    xfconf-query --channel xfce4-desktop --property "$PROP" --set "$IMM"
done
