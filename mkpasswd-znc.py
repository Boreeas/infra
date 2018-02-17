#!/bin/env python
import hashlib
import crypt
import getpass

passwd = getpass.getpass("passwd: ")
salt = crypt.mksalt()[3:]
m = hashlib.sha256()
m.update(passwd.encode('utf-8'))
m.update(salt.encode('utf-8'))
print("method: {method}\nhash: {hash}\nsalt: {salt}".format(
    method="sha256",
    hash=m.hexdigest(),
    salt=salt
))
