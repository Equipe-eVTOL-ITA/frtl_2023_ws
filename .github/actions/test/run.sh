#!/bin/bash
set -e

export GIT_CREDENTIALS=$GIT_CREDENTIALS
git config --global credential.helper "store --file=/github/home/.git-credentials"
echo "${GIT_CREDENTIALS}" > /github/home/.git-credentials

./tasks/setup.sh "with simulation" parallel
./tasks/build.sh all parallel
#./tasks/test.sh
