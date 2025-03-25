#!/bin/bash
set -e

# Source ROS2 setup files
source /opt/ros/humble/setup.bash


# Verify configuration files exist - Added for debugging
echo "Checking if XML file exists:"
ls -la /connections/server_configuration.xml || echo "ERROR: Configuration file not found!"

# Clone the repository if it doesn't exist or is empty
if [ ! -d "/ros2_ws/.git" ]; then
  echo "Cloning repository..."
  rm -rf /ros2_ws/* /ros2_ws/.[!.]*
  git clone https://github.com/zenith-polymtl/ros2-mission-2 /ros2_ws
  cd /ros2_ws
  pip3 install -r requirements.txt
else
  cd /ros2_ws
  git pull
fi

# # Start FastDDS Discovery Server - Added this section
echo "Starting FastDDS Discovery Server..."
fastdds discovery -i 0 -l 192.168.30.247 -p 11869 -b > /tmp/discovery_server.log 2>&1 &
echo "Discovery Server started with PID: $!" &
server_pid=$!
sleep 3  # Give it time to start up

# Check if server is running
if ps -p $server_pid > /dev/null; then
  echo "FastDDS Discovery Server is running with PID $server_pid"
else
  echo "WARNING: FastDDS Discovery Server failed to start!"
fi

# Test ROS 2 communication - Added for debugging
echo "Testing ROS 2 discovery..."
ros2 topic list || echo "WARNING: ROS 2 discovery may not be working!"

# Execute the command passed to this script
exec "$@"
