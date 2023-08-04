#!/bin/bash
set -e

./tasks/simulation_less/setup.sh
ament_${LINTER} src/
