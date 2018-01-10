#! /bin/env python
import crypt
import getpass

salt = crypt.mksalt(crypt.METHOD_SHA512)
pw = getpass.getpass("passwd: ")
print(crypt.crypt(pw, salt))
