#!/bin/bash
# Must run as administrator

# General Parameters
CELL_SIZE=5
XY_UNITS=m
Z_UNITS=m
COORD_SYS=0
ZONE=0
HORIZ_DATUM=0
VERT_DATUM=0

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
outPath="${directory}/outputs"
mkdir -p $outPath
origDataFilePath=$filePath
gndPtFilePath="${directory}/ground_points.las"
dtmFilePath=${outPath}/digital_terrain.dtm
dsmFilePath=${outPath}/digital_surface.dtm
chmFilePath=${outPath}/canopy_height.dtm
treeSegmFilePath=${outPath}/tree_segm.csv
canopyCoverFilePath=${outPath}/cover.dtm
densityFilePath=${outPath}/density

echo ">> Filtering ground points..."
GroundFilter $gndPtFilePath $CELL_SIZE $origDataFilePath
echo ">> Filtered ground points found here: $gndPtFilePath"
sleep 3

# ========= DTM =========
echo ">> Creating digital terrain model (DTM)"
GridSurfaceCreate $dtmFilePath $CELL_SIZE $XY_UNITS $Z_UNITS $COORD_SYS $ZONE $HORIZ_DATUM $VERT_DATUM $gndPtFilePath
echo ">> DTM found here: $dtmFilePath"
sleep 3

# ========= DSM/CSM =========
echo ">> Creating digital surface model (DSM)/canopy surface model (CSM)"
CanopyModel $dsmFilePath $CELL_SIZE $XY_UNITS $Z_UNITS $COORD_SYS $ZONE $HORIZ_DATUM $VERT_DATUM $origDataFilePath
echo ">> DSM found here: $dsmFilePath"
sleep 3

# ========= CHM =========
echo ">> Creating canopy height model (CHM)"
CanopyModel /ground:$dtmFilePath $chmFilePath $CELL_SIZE $XY_UNITS $Z_UNITS $COORD_SYS $ZONE $HORIZ_DATUM $VERT_DATUM $origDataFilePath
echo ">> CHM found here: $chmFilePath"
sleep 3

# ========= Tree Segmentation =========
echo ">> Detecting trees"
MIN_HEIGHT=2
TreeSeg $chmFilePath $MIN_HEIGHT $treeSegmFilePath
echo ">> Tree detection results found here: $treeSegmFilePath"
sleep 3

# ========= Canopy Cover =========
echo ">> Canopy cover"
HEIGHT_BRK=8
OP_CELL_SZ=50
Cover $dtmFilePath $canopyCoverFilePath $HEIGHT_BRK $OP_CELL_SZ $XY_UNITS $Z_UNITS $COORD_SYS $ZONE $HORIZ_DATUM $VERT_DATUM $origDataFilePath
echo ">> Canopy cover model found here: $canopyCoverFilePath"
sleep 3

# ========= Vegetation Density for Various Height Strata =========
echo ">> Vegetation density"
BTM_HT=0
TOP_HT=15
STEP=3
for ((i=BTM_HT; i<=TOP_HT; i+=STEP)); do
    UPPER_HT=$((i+STEP))
    densityFile=${densityFilePath}_${i}_${UPPER_HT}.dtm

    ./density.bat /upper:$UPPER_HT $dtmFilePath $densityFile $i $OP_CELL_SZ $XY_UNITS $Z_UNITS $COORD_SYS $ZONE $HORIZ_DATUM $VERT_DATUM $origDataFilePath
    echo ">> Density in the range of $i and $UPPER_HT above the ground can be found here: $densityFile"
done
sleep 3

sleep 100