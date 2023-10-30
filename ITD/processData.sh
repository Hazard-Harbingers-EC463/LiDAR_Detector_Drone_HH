#!/bin/bash
# Must run as administrator

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

# Filtering ground points using lasground_new
echo "Filtering ground points..."
groundPtFilePath="${directory}/groundPts.las"
## Add some parameters for this:
../LAStools/lasground_new -i "$filePath" -o "${groundPtFilePath}"
echo "Filtered ground points found here: $groundPtFilePath"

# Generating DTM model using FUSION/LDV: GridSurfaceCreate
dtmFilePath="${directory}/gnd.dtm"
## Parameters:
dtm_cellsize=1
dtm_xyunits="m"
dtm_zunits="m"
dtm_coordsys="1"
dtm_zone="10"
dtm_horizdatum="2"
dtm_vertdatum="2"
GridSurfaceCreate $dtmFilePath $dtm_cellsize $dtm_xyunits $dtm_zunits $dtm_coordsys $dtm_zone $dtm_horizdatum $dtm_vertdatum $groundPtFilePath

# Height aboveground normalization using FUSION/LDV: ClipData
heightNormalizedFilePath=${directory}/height_normalized.las
ClipData /ground:$dtmFilePath $filePath $heightNormalizedFilePath 6188142 1811147 6288542 1883547

# Generating CHM using FUSION/LDV: CanopyModel
canopySurfaceFilePath=${directory}/canopy_surface.dtm
## Parameters
chm_cellsize=5
chm_xyunits="m"
chm_zunits="m"
chm_coordsys="1"
chm_zone="10"
chm_horizdatum="2"
chm_vertdatum="2"
CanopyModel /ground:$dtmFilePath $canopySurfaceFilePath $chm_cellsize $chm_xyunits $chm_zunits $chm_coordsys $chm_zone $chm_horizdatum $chm_vertdatum $heightNormalizedFilePath

sleep 20