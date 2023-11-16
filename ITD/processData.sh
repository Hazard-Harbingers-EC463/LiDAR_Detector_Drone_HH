#!/bin/bash
# Must run as administrator

# Parameters for creating DTM and CHM
CELL_SIZE=5
XY_UNITS=m
Z_UNITS=m
COORD_SYS=0
ZONE=0
HORIZ_DATUM=0
VERT_DATUM=0

# Parameter for Tree Segmentation
MIN_HEIGHT=2


# Get LiDAR data: convert to LAS format
echo ">> Please input file path to LiDAR data: "
read filePath
fileExtension="${filePath##*.}"
if [ -e "$filePath" ]; then
    if [ "$fileExtension" = "XYZ" ]; then 
        ../LAStools/txt2las -i "$filePath" -o "${filePath%.*}.las"
        filePath="${filePath%.*}.las"
        echo ">> Converted to las file: $filePath"
    elif [ "$fileExtension" = "las" ]; then 
        echo ">> Remain as las file: $filePath"
    else
        echo ">> File has extension $fileExtension. Only XYZ or las extensions allowed."
        exit 1
    fi
else
    echo ">> File does not exist at $filePath. Make sure you are using forward slashes."
    exit 1
fi
directory=$(dirname "$filePath")
origDataFilePath=$filePath
gndPtFilePath="${directory}/ground_points.las"
dtmFilePath=${directory}/digital_terrain.dtm
chmFilePath=${directory}/canopy_height.dtm
treeSegmFilePath=${directory}/tree_segm.csv

echo ">> Filtering ground points..."
GroundFilter $gndPtFilePath $CELL_SIZE $origDataFilePath
echo ">> Filtered ground points found here: $gndPtFilePath"
sleep 3

echo ">> Creating digital terrain model (DTM)"
GridSurfaceCreate $dtmFilePath $CELL_SIZE $XY_UNITS $Z_UNITS $COORD_SYS $ZONE $HORIZ_DATUM $VERT_DATUM $gndPtFilePath
echo ">> DTM found here: $dtmFilePath"
sleep 3

echo ">> Creating canopy height model (CHM)"
CanopyModel $chmFilePath $CELL_SIZE $XY_UNITS $Z_UNITS $COORD_SYS $ZONE $HORIZ_DATUM $VERT_DATUM $origDataFilePath
#CanopyModel /ground:$dtmFilePath $chmFilePath $CELL_SIZE $XY_UNITS $Z_UNITS $COORD_SYS $ZONE $HORIZ_DATUM $VERT_DATUM $origDataFilePath
echo ">> CHM found here: $chmFilePath"
sleep 3

echo ">> Detecting trees"
TreeSeg $chmFilePath $MIN_HEIGHT $treeSegmFilePath
echo ">> Tree detection results found here: $treeSegmFilePath"
sleep 3

sleep 100