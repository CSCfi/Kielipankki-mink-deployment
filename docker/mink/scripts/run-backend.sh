#!/bin/sh

/etc/init.d/ssh start
/etc/init.d/memcached start
cd mink-backend
mkdir -p instance/logs
#/usr/sbin/sshd -D &
venv/bin/python run.py &
venv/bin/python queue_manager.py &
cd ../mink-frontend
yarn dev
