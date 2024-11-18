#!/bin/bash
# wallpaper-set.sh
# Set wallpaper to given image file.

fname=$(realpath "$1")
if [ ! -e "$1" ]; then
    echo "Usage: ${0##*/} IMAGE_PATH"
    echo "Trys to set wallpaper to given image."
    echo "Also makes the link $HOME/.wallpaper to the image"
    exit
fi


case $XDG_CURRENT_DESKTOP in
    *gnome*|*GNOME*|*ubuntu*)
        fname_uri=$(python3 -c "import pathlib; print(pathlib.Path(input()).resolve().as_uri())" <<< "$fname")
        echo "Setting $XDG_CURRENT_DESKTOP wallpaper with gsettings"
        gsettings set org.gnome.desktop.background picture-uri "$fname_uri"
        gsettings set org.gnome.desktop.background picture-uri-dark "$fname_uri"
        ;;
    sway|labwc|wlroots)
        echo "Setting $XDG_CURRENT_DESKTOP wallpaper with swaybg"
        pkill swaybg
        swaybg -o '*' -m fit -c '#000000' -i "$HOME/.wallpaper" >/dev/null 2>&1 &
        ;;
    Hyprland)
        echo "Setting $XDG_CURRENT_DESKTOP wallpaper with hyprpaper"
        hyprctl hyprpaper preload "$fname"
        hyprctl hyprpaper wallpaper ",contain:$fname"
        hyprctl hyprpaper unload unused
        ;;
    *)
        echo "ERROR, XDG_CURRENT_DESKTOP: $XDG_CURRENT_DESKTOP"
        if [ -n "$XDG_CURRENT_DESKTOP" ]; then
            echo "Unrecognized, nothing set"
        else
            echo "Env variable unset, unsure how to set background."
        fi
        ;;
esac

ln -svf "$fname" "$HOME/.wallpaper"
