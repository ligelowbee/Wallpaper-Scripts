#!/bin/bash
# Set cinnamon wallpaper given a file path
fname="$1"
if [ ! -e "$1" ]; then
    echo "Usage: ${0##*/} IMAGE_PATH"
    exit
fi

fname="$1"
echo "Setting as cinnamon wallpaper"
fname_uri=$(python3 -c "import pathlib; print(pathlib.Path(input()).resolve().as_uri())" <<< "$fname")
gsettings set org.cinnamon.desktop.background picture-uri "$fname_uri"
