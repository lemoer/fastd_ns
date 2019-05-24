#!/bin/sh

source ./fastd.sh

sudo ip netns exec fastd_b $FASTD -c b.conf
