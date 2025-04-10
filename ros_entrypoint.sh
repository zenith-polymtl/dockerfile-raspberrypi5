#!/bin/bash
set -e

# Source ROS2 setup files
source /opt/ros/humble/setup.bash


# Verify configuration files exist - Added for debugging
echo "Checking if XML file exists:"
ls -la /connections/cycloneDDS_profile.xml || echo "ERROR: Configuration file not found!"

cd /ros2_ws
pip3 install -r requirements.txt


# Test ROS 2 communication - Added for debugging
echo "Testing ROS 2 discovery..."
ros2 topic list || echo "WARNING: ROS 2 discovery may not be working!"

# Execute the command passed to this script
exec "$@"
