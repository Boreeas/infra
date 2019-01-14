#!/bin/bash -ex
cd $(git rev-parse --show-toplevel)
git submodule update --init --recursive
mkdir -p library

ln -s ../deps/ansible-aur/aur.py library/aur
