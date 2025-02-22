#!/bin/bash

# Set the URL of the file to download
PLAYLIST_URL="https://www.youtube.com/watch?v=ufsIA5NARIo&list=PLPNW_gerXa4Pc8S2qoUQc5e8Ir97RLuVW"
#PLAYLIST_URL= "https://www.youtube.com/watch?v=oZ9uW-rFSo8&list=PLfSdLxXHrKiRRY9ADBn4EeZlcocngGbs"

# Set the path to the directory where the file should be saved
save_dir="C:/Users/dell/Desktop/vtt"

# Create the directory if it doesn't exist
if [ ! -d "$save_dir" ]; then
  mkdir -p "$save_dir"
fi

# Download the file and save it to the specified directory
yt-dlp  --write-sub --sub-lang en -- --sub-format srt --skip-download -- --output "$save_dir/%(title)s" $PLAYLIST_URL

# Download the vedio and save it to the specified directory
#yt-dlp  --write-sub --sub-lang en --sub-format srt --output "$save_dir/%(title)s.org" $PLAYLIST_URL
