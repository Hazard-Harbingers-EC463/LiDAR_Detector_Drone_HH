# Hazard Harbinger: Precise Prescription Burning Area Localization via a LiDAR-mounted Drone and System of Embedded Nodes

## Introduction  
Wildfires are major environmental disasters with far-reaching consequences on 
the environment and human mortality. A common practice to prevent wildfires is 
prescribed burning, which requires thorough planning. To aid these burn plans, we 
propose a novel system that integrates an airborne LiDAR system and deployable sensor 
nodes. This system will result in 3D models and relevant environmental data.

Our final product is a land inspection system to collect and process both topographical and environmental data, resulting in a 3D fuel map featuring all gathered information. Our system has two components. The first uses an airborne LiDAR system (ALS), which scans a forest region to provide a 3D point cloud of the land and vegetation. Then, the 3D point cloud is processed to produce the final 3D fuel map. The second component is the embedded sensor nodes. These nodes are cheap and energy-efficient pieces of hardware that can be simply placed across the forest floor, and passively collect environmental data. Our system enables fire managers to efficiently prescribe controlled burns without onsite human investigation.

Please find the documentation on each relevant topic related to our product in the User Manual under Reports folder in this repository.

For a quick reference guide to the software, please refer to the Software README which details all the commands for each functionality in the software.

## Top-level directory layout
.  
├── Reports	# Information about our system  
├── Models	# 3D models and 2D heat maps  
├── LAStools	# Executables used to produce models  
├── ALS # Aerial LiDAR system: collecting and preprocessing data
├── README.md  
├── README_Hardware.md # Description about hardware  
└── README_Software.md # Description about software  
