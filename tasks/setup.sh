#!/bin/bash
set -e

if [ $# -ne 2 ]; then
    echo "Usage: $0 <simulation option> <parallel/sequential>"
    exit 1
fi

vcs import < src/dependencies.repos src
vcs import < src/frtl_2023/dependencies.repos src

if [ "$1" = "with simulation" ]
then
    vcs import < src/simulation/dependencies.repos src
    sudo apt-get update
    sudo apt remove ros-humble-ros-gz-bridge
elif [ "$1" = "without simulation" ]
then
    sudo rm -r src/simulation
    sudo apt-get update
else
    echo "Possible options: \"with simulation\", \"without simulation\""
    exit 1
fi

if [ $2 = sequential ]
then
    SEQUENTIAL_BUILD="--executor sequential"
elif [ $2 = parallel ]
then
    SEQUENTIAL_BUILD=""
else
    echo "Possible options: sequential, parallel"
    exit 1
fi

source /opt/ros/humble/setup.bash
rosdep update
rosdep install --from-paths src --rosdistro humble --ignore-src -y -i \
        --skip-keys="gz-transport12 gz-common5 gz-math7 gz-msgs9 gz-gui7 gz-cmake3 gz-sim7 Eigen3 opencv2 nlohmann_json qgroundcontrol"

BUILD_TYPE=RelWithDebInfo
colcon build \
        --symlink-install \
        --event-handlers console_direct+ \
        --cmake-args "-DCMAKE_BUILD_TYPE=$BUILD_TYPE" "-DCMAKE_EXPORT_COMPILE_COMMANDS=On" \
        -Wall -Wextra -Wpedantic \
        $SEQUENTIAL_BUILD