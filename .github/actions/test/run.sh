#!/bin/bash
set -e

./tasks/simulation_less/setup.sh
./tasks/build.sh
./tasks/test.sh
