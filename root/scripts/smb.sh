#!/bin/bash

#THIS FILE IS EXECUTED ONLY IF YOUR CONTAINER IS PRIVILEGIED AND YOU SET ENV LOAD_SMB="true"
#SYNTAX :
#mount -t cifs -o username=shareuser,password=shareuserpassword //path/to/share /path/to/local
