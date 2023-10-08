#!/bin/bash
set -e

if [ -f install/setup.bash ]; then source install/setup.bash; fi
bash ./src/simulation/scripts/run.sh "$1"