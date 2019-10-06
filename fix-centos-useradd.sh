#!/bin/bash
cd /etc/pam.d

cp system-auth system-auth.bak

sed -i 's/password    requisite/#password    requisite/' system-auth
sed -i 's/use_authtok//' system-auth
