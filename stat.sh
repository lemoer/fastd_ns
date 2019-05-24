#!/bin/sh

pid_a=$(pgrep -a fastd | grep a.conf | cut -d' ' -f 1)
pid_b=$(pgrep -a fastd | grep b.conf | cut -d' ' -f 1)
