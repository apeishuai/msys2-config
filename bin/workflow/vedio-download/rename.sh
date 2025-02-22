#!/bin/bash

# Set the directory path
dir_path="C:/Users/dell/Desktop/vtt"

# Loop through the files and rename them
for file in "$dir_path"/*; do
    # Get the new file name with underscores instead of spaces
    new_name=$(echo "$file" | tr ' ' '_')
    new_name=$(echo "$new_name" | sed 's/\.en//g')

    # Rename the file
    mv "$file" "$new_name"
done
echo "rename finished"
