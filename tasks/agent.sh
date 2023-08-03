#!/bin/bash
set -e

if [ -f install/setup.bash ]; then source install/setup.bash; fi
MicroXRCEAgent udp4 -p 8888