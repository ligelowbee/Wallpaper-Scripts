`wallpaper-label.sh` resizes and labels images for use as wallpaper. Uses `imagemagick`. Resizes to 1920x180 keeping aspect, padding with black, adds a 20pt drop shadowed label to the bottom right using the Ubuntu font.

`wallpaper-set.sh` sets an image as wallpaper (for gnome, adjust as needed for other desktops).

`wallpaper-cover.sh` selects a random cover image from my calibre library and uses above scripts to label and set as wallpaper.

`wallpaper-google-art.sh` uses `curl` to fetch a random art image from wikimedia's google arts collection. Then uses above scripts to label and set as wallpaper.

`wallpaper-change.sh` changes wallpaper to either some fresh google art, already fetched google art, or a calibre book cover. Uses above scripts to do everything.
