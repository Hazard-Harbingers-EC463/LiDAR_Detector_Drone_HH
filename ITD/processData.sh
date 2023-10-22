#!/bin/bash

# Get LiDAR data
echo "Please input file path to LiDAR data: "
read filePath
fileExtension="${filePath##*.}"
if [ -e "$filePath" ]; then
    if [ "$fileExtension" = "XYZ" ]; then 
        ../LAStools/txt2las -i "$filePath" -o "${filePath%.*}.las"
        filePath="${filePath%.*}.las"
        echo "Converted to las file: $filePath"
    elif [ "$fileExtension" = "las" ]; then 
        echo "Remain as las file: $filePath"
    else
        echo "File has extension $fileExtension. Only XYZ or las extensions allowed."
        exit 1
    fi
else
    echo "File does not exist at $filePath. Make sure you are using forward slashes."
    exit 1
fi
directory=$(dirname "$filePath")

# Filtering ground points
echo "Filtering ground points..."
groundPtFilePath="${directory}/groundPts.las"
../LAStools/lasground_new -i "$filePath" -o "${groundPtFilePath}"
echo "Filtered ground points found here: $groundPtFilePath"

# Generating DTM model
