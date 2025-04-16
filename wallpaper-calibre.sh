#!/bin/bash
# wallpaper-calibre.sh
# Make a labeled wallpaper from a calibre cover

calibred="$HOME/Ebooks/calibre"
artd="$HOME/Pictures/Wallpaper/"

origc=$(find "$calibred" -name "cover.jpg" | shuf -n1)
label=$(awk 'BEGIN {FS="/"};{printf "%s\n%s",$(NF-2),$(NF-1)}' <<< "$origc")
fname="calibre-ebook-cover.jpg"

cd "$artd"
cp "$origc" "$fname"

wallpaper-label.sh -l "$label" "$fname"
if [ $? -eq 0 ]; then
    mv -f "labeled-$fname" "$fname"
fi

wallpaper-set.sh "$artd/$fname"
