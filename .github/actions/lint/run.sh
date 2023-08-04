#!/bin/bash
set -e

./simulation_less/setup.sh
ament_${LINTER} src/
