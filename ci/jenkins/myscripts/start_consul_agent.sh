#!/bin/sh

#When you cannot start consul with a formal process supervisor
#start consul agent and run in backround
consul agent -config-dir /etc/consul.d/client &
