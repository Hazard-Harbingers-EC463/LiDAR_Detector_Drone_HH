#!/usr/bin/env python
import pdb as pdb

import time
import errno
from socket import error as socket_error

import rospy 
from laser_assembler.srv import AssembleScans2
from sensor_msgs.msg import PointCloud2
#pdb.set_trace()

ros_master_available = False
while not rospy.is_shutdown() and not ros_master_available:
    try:  
        # query ROS Master for published topics   
        rospy.get_published_topics()  
        ros_master_available = True
    except socket_error as serr:  
        if serr.errno != errno.ECONNREFUSED:               
            raise serr  # re-raise error if its not the one we want     
        else:    
            print("YOUR STATUS MSG / Waiting for roscore")  
    time.sleep(0.1)  # sleep for 0.1 seconds   
pub = rospy.Publisher("/laser_pointcloud", PointCloud2, queue_size=100)
rospy.init_node("assemble_scans_to_cloud")
rospy.wait_for_service("assemble_scans2")
assemble_scans = rospy.ServiceProxy('assemble_scans2', AssembleScans2)


r = rospy.Rate (1)

while not rospy.is_shutdown():
    try:
        resp = assemble_scans(rospy.Time(0,0), rospy.get_rostime())
        print("Ropsy time ",rospy.Time(0,0),"gettime ",rospy.get_rostime())
        print("Got cloud with %u points" % len(resp.cloud.data))
        #pdb.set_trace()
        pub.publish(resp.cloud)
    except (rospy.ServiceException, e):
        print("Service call failed: %s"%e)

    r.sleep()
