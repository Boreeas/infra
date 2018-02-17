#!/bin/bash -ex
read -p "User: " user
read -s -p "Pass: " pass

hashed=$(echo -n "${pass}${user}" | md5sum | cut -d' ' -f1)
echo "md5${hashed}"
