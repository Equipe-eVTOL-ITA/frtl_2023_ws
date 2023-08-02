#!/bin/bash
set -e

#vcs import < src/ros2.repos src
sudo apt-get update
sudo apt remove ros-humble-ros-gz-bridge
source /opt/ros/humble/setup.bash
rosdep update
rosdep install --from-paths src --rosdistro humble --ignore-src -y -i \
        --skip-keys="gz-transport12 gz-common5 gz-math7 gz-msgs9 gz-gui7 gz-cmake3 gz-sim7 Eigen3 opencv2 nlohmann_json qgroundcontrol"
colcon build --event-handlers console_direct+ --cmake-args -DBUILD_TESTING=0