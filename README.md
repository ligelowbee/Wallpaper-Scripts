`wallpaper-label.sh` resizes and labels images for use as wallpaper. Uses `imagemagick`. Resizes to 1920x180 keeping aspect, padding with black, adds a 20pt drop shadowed label to the bottom right using Noto-Sans-Regular.

`wallpaper-set.sh` sets an image as wallpaper. Trys to use the right tool for the current desktop.

`wallpaper-calibre.sh` selects a random cover image from my calibre library and uses above scripts to label and set as wallpaper.

`wallpaper-google-art.sh` uses `curl` to fetch a random art image from wikimedia's google arts collection. Then uses above scripts to label and set as wallpaper.

`wallpaper-change.sh` Uses above scripts to change current wallpaper to one of: fresh google art, already fetched google art, or a calibre ebook cover. 

`wallpaper-relabel-google-art.sh` will redownload and relabel a google-art image. Optionaly using `translate-shell` to translate filename to an english label and filename.
