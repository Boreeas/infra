#!/bin/bash
set -euf -o pipefail

echo "Updating site"
cd /home/sunrise/sunrise

env -i git fetch --all
env -i git reset --hard origin/master

echo "Rebuilding site"
gradle assemble
rsync -r deploy/ /srv/http/sunrise
