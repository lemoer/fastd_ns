#!/bin/sh

sudo ip netns add fastd_b

sudo ip link add lower-a type veth peer name lower-b
sudo ip link set netns fastd_b dev lower-b

sudo ip link set lower-a up

sudo ip netns exec fastd_b ip link set lower-b up

sudo ip addr add fd8b:e174:b4e4::a/48 dev lower-a
sudo ip netns exec fastd_b ip addr add fd8b:e174:b4e4::b/48 dev lower-b
