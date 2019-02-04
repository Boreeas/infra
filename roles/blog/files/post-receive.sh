#!/bin/bash
set -e

echo "Updating site"
cd /home/blog/blog

env -i git fetch --all
env -i git reset --hard origin/master

echo "Rebuilding site"
cd site
~/.virtenvs/blog/bin/nikola build
chown -R blog:http /home/blog/blog/site/output/*
