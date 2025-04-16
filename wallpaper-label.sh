#!/bin/bash
# wallpaper-label.sh
# Label and resize and image for use as wallpaper
usage() {
    cat <<EOF
Usage: wallpaper-label.sh [-h] [-o OUTFILE] [-l LABEL] INFILE
    If no OUTFILE given will use: labeled-INFILE
    If no LABEL string given info from the INFILE filename
        (eg: artist_name - title_of_picture.jpg)
EOF
    exit 1
}

[ $# -eq 0 ] && usage

while getopts ":ho:l:" opt; do
    case $opt in
        h) usage ;;
        o) outfile="$OPTARG" ;;
        l) label="$OPTARG" ;;
        *) usage ;;
    esac
done
shift $(( OPTIND - 1 ))

err=0
while [ -e "$1" ]; do
    infile="$1"
    fbase=$(basename "$infile")
    if [ -z "$outfile" ]; then
        outfile="labeled-${fbase}"
    fi

    # Generate label
    if [ -n "$label" ]; then
        echo "Using label: $label"
    else
        label="${fbase%.*}"
        # underscore to space
        label="${label//_/ }"
        # replace system marks with safe utf8 versions 
        label="${label//\'/’}"
        label="${label//\"/”}"
        label="${label//\&/＆}"
        # replace m-dash and n-dash
        label="${label//—/-}"
        label="${label//–/-}"
        # remove unwanted info
        label="${label/ - Google Art Project*/}"
        label="${label/ - Google Arts ＆ Culture*/}"
        # dashes to newline
        eol=$'\n'
        label="${label// - /$eol}"
    fi

    width=1920
    height=1080
    pts=20

    echo "Resizing and labeling: $infile"
    ## Resize to width x height with black borders and label
    magick "$infile" -resize "$width"x"$height" -background Black \
            -gravity center -extent "$width"x"$height" \
            -font "Noto-Sans-Regular" -pointsize "$pts" \
            -draw "gravity SouthEast fill black text 10,4 \"$label\"" \
            -draw "gravity SouthEast fill white text 8,6 \"$label\"" \
            "$outfile"

    if [ $? -eq 0 ]; then
        echo "Created: $outfile"
    else
        echo "!!! Error labeling: $infile"
        err=1
    fi
    shift
    unset infile fbase outfile label
done
exit $err
