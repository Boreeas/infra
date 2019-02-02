#! /bin/env python
import crypt
import getpass

salt = crypt.mksalt(crypt.METHOD_SHA512)
pw = getpass.getpass("passwd: ")
if not pw:
    print("PW cannot be empty")
else:
    print(crypt.crypt(pw, salt))
