#!/bin/bash
set -e

if [ $# -ne 2 ]; then
    echo "Usage: $0 <targets> <parallel/sequential>"
    exit 1
fi

# Check if the argument is equal to "a"
if [ $1 = all ]
then
    BUILD_PATH=""
elif [ $1 = dependencies ]
then
    BUILD_PATH="--paths src/json/ src/Micro-XRCE-DDS-Agent/ src/px4_msgs/ src/ros_gz/*"
elif [ $1 = frtl_2023 ]
then
    BUILD_PATH="--paths src/frtl_2023/*"
elif [ $1 = fsm ]
then
    BUILD_PATH="--paths src/fsm/*"
elif [ $1 = simulation ]
then
    BUILD_PATH="--paths src/simulation/*"
elif [ $1 = fase1 ]
then
    BUILD_PATH="--paths src/frtl_2023/frtl_2023_fase1"
elif [ $1 = fase2 ]
then
    BUILD_PATH="--paths src/frtl_2023/frtl_2023_fase2"
elif [ $1 = fase3 ]
then
    BUILD_PATH="--paths src/frtl_2023/frtl_2023_fase3"
elif [ $1 = fase4 ]
then
    BUILD_PATH="--paths src/frtl_2023/frtl_2023_fase4"
else
    echo "Possible options: all, dependencies, frtl_2023, fsm, simulation"
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

# Set the default build type
BUILD_TYPE=RelWithDebInfo
colcon build \
        --symlink-install \
        --cmake-args "-DCMAKE_BUILD_TYPE=$BUILD_TYPE" "-DCMAKE_EXPORT_COMPILE_COMMANDS=On" \
        -Wall -Wextra -Wpedantic \
        $BUILD_PATH $SEQUENTIAL_BUILD