# Make sure ip addresses are correct
roslaunch sick_scan_xd sick_multiscan.launch hostname:=192.168.0.2 udp_receiver_ip:=192.168.0.3
rosbag record /cloud_all_fields_fullframe