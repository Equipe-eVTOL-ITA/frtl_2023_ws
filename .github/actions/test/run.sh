#!/bin/bash
set -e

export GIT_CREDENTIALS=$GIT_CREDENTIALS
git config --global credential.helper "store --file=/github/home/.git-credentials"
echo "${GIT_CREDENTIALS}" > /github/home/.git-credentials

./tasks/setup.sh
./tasks/build.sh
#./tasks/test.sh
