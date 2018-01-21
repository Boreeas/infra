#!/bin/bash -ex
git submodule update --init --recursive
mkdir -p library

ln -s ../deps/ansible-aur/aur library/aur
