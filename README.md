# Hazard Harbinger: Precise Prescription Burning Area Localization via a LiDAR-mounted Drone and System of Embedded Nodes

## Introduction  
Wildfires are major environmental disasters with far-reaching consequences on 
the environment and human mortality. A common practice to prevent wildfires is 
prescribed burning, which requires thorough planning. To aid these burn plans, we 
propose a novel system that integrates an airborne LiDAR system and deployable sensor 
nodes. This system will result in 3D models and relevant environmental data.

Our final product is a land inspection system to collect and process both topographical and environmental data, resulting in a 3D fuel map featuring all gathered information. Our system has two components. The first uses an airborne LiDAR system (ALS), which scans a forest region to provide a 3D point cloud of the land and vegetation. Then, the 3D point cloud is processed to produce the final 3D fuel map. The second component is the embedded sensor nodes. These nodes are cheap and energy-efficient pieces of hardware that can be simply placed across the forest floor, and passively collect environmental data. Our system enables fire managers to efficiently prescribe controlled burns without onsite human investigation.

Please find the documentation on each relevant topic related to our product in the User Manual under Reports folder in this repository.

For a quick reference guide to the software, please refer to the Software README which details all the commands for each functionality in the software. For a quick reference guid to the hardware, please refer to the Hardware README. 

## Top-level directory layout
.  
├── Reports	# Information about our system  
├── Models	# 3D models and 2D heat maps    
├── LAStools	# Executables used to produce models    
├── ALS # Aerial LiDAR system: collecting data    
├── lidarLaserAssembler/laser_to_pcl # Preprocessing LiDAR data  
├── Figures  
├── .gitignore  
├── README.md	# Engineering Addendum   
├── README_Hardware.md # Description about hardware    
└── README_Software.md # Description about software    


## System specifications
### Mounted LiDAR drone system specifications
1. Minimum Flight Time: >20 minutes   
2. Data Storage: 128GB microSD to hold all data   
3. SICK LiDAR multiScan100 mounted using custom 3D printed mount   
4. Jetson Orin Nano 8GB with RAM for live data processing and collection   
5. DJI Inspire 1 Pro V2.0 with TB48 Battery (~25.6V nominal voltage)  

### Embedded node system specifications
1. Battery Life: >1 year (typ. usage)   
2. BME688 Sensor Measuring:   
    a. Temperature (-40 – 85 °C, ± 3°C)   
    b. Humidity (0 – 100 %, ± 3%)   
    c. Pressure (300 – 1100 hPa, ± 0.25%)   
    d. Gas (Raw Resistance of Heater kΩ) – Additional Estimated Outputs:   
        i. Index for Air Quality (IAQ)   
        ii. Biogenic Volatile Organic Compounds (bVOC) (ppm)   
        iii. CO2 equivalents (ppm)   
3. Operating Temperature Range: -20C to 50C   
4. Wireless Data Transmission via Hope RFM95W LoRa modem   

### Software system specifications
1. LiDAR scan in ROSBAG format can be converted to a LAS file.   
2. 3D models of DTM, CHM, tree clusters, canopy cover, and vegetation density can be produced.   
3. 2D heat maps of the tree clusters, canopy cover, and vegetation density can be produced.  

## Required Materials
### Hardware: Aerial LiDAR System
* DJI Inspire 1 Pro V2 Drone   
* SICK multiScan100 LiDAR   
* Jetson Orin Nano Development Board (Jetpack 5 / Ubuntu 20.04)

### Hardware: Embedded Nodes System
* SparkFun Atmel-SAMD21 Pro RF   
* HopeRF RMF95W 915MHz Transceiver   
* Bosch Sensortech BME688 Sensor Board
* 128GB microSD Card
* SPI SD Card Breakout

### Software 
* Scripts to preprocess LiDAR data: lidarLaserAssembler/laser_to_pcl
* Shell script to process LiDAR data: processData.sh 
    * FUSION/LDV library: GroundFilter, GridSurfaceCreate, CanopyModel, TreeSeg, DTM2XYZ, Cover 
    * LAStools library: txt2las 
    * density.bat script 
    * Python program: visualize2D.py 
* ROS1 and Sick libraries installed with rviz on Linux device 
* SOPAS ET software on windows device 
* ROS package laser_assembler 
* PDAL package
