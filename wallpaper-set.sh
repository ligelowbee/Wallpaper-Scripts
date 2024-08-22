#!/bin/bash
fname="$1"
if [ ! -e "$1" ]; then
    echo "Usage: ${0##*/} IMAGE_PATH"
    exit
fi

fname="$1"
fname_uri=$(python3 -c "import pathlib; print(pathlib.Path(input()).resolve().as_uri())" <<< "$fname")

echo "Setting as gnome wallpaper"
gsettings set org.gnome.desktop.background picture-uri "$fname_uri"
gsettings set org.gnome.desktop.background picture-uri-dark "$fname_uri"

# echo "Setting as cinnamon wallpaper"
# gsettings set org.cinnamon.desktop.background picture-uri "$fname_uri"
