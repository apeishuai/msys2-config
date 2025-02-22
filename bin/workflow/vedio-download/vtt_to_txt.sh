#!/bin/bash

# Set the directory path
dir_path="C:/Users/whens/Desktop/vtt"

# Loop through the VTT files in the directory
for file in "$dir_path"/*.vtt; do
    # Remove timecode and number lines
    sed -i '/^[0-9]\+$/d; /^[0-9]\+:[0-9]\+:[0-9]\+.[0-9]\+ --> [0-9]\+:[0-9]\+:[0-9]\+.[0-9]\+$/d' "$file"

    # Replace newlines with spaces
    tr '\n' ' ' < "$file" > "${file%.vtt}.txt"

    # Convert the txt file to PDF using 2printer and "Bullzip PDF Printer"
    #2printer -src "$file" -prn "Bullzip PDF Printer" -options alerts:no /copies 1

    # Delete the original VTT file
    rm "$file"

done

