#!/bin/bash
set -e

vcs import < src/dependencies.repos src
vcs import < src/frtl_2023/dependencies.repos src
vcs import < src/simulation/dependencies.repos src

sudo apt-get update
sudo apt remove ros-humble-ros-gz-bridge

source /opt/ros/humble/setup.bash
rosdep update
rosdep install --from-paths src --rosdistro humble --ignore-src -y -i \
        --skip-keys="gz-transport12 gz-common5 gz-math7 gz-msgs9 gz-gui7 gz-cmake3 gz-sim7 Eigen3 opencv2 nlohmann_json qgroundcontrol"

BUILD_TYPE=RelWithDebInfo
colcon build \
        --symlink-install \
        --event-handlers console_direct+ \
        --cmake-args "-DCMAKE_BUILD_TYPE=$BUILD_TYPE" "-DCMAKE_EXPORT_COMPILE_COMMANDS=On" \
        -Wall -Wextra -Wpedantic