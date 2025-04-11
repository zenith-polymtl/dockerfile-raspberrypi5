#!/bin/bash
set -e

# Source ROS2 setup files
source /opt/ros/humble/setup.bash

# Clone the repository if it doesn't exist or is empty

cd /ros2_ws
pip3 install -r requirements.txt


# Execute the command passed to this script
exec "$@"
