#!/bin/bash

f=$(mktemp).json
remote=fde9:0727:326e::b

min_bw=499
step_bw=10
max_bw=500
pktlen=500 # byte

get_epoll() {
	wc -l meas/epoll | cut -d " " -f 1
}

xtra_args=""

if [ -z "$rev" ] || [ "$rev" == 0 ]; then
	echo FWD
	log=meas/bw_udp_pktlen_${pktlen}.log
else
	echo REV
	log=meas/bw_rev_udp_pktlen_${pktlen}.log
	xtra_args="$xtra_args -R"
fi

rm -f $log
touch $log

for bw in $(seq $min_bw $step_bw $max_bw); do
	epoll_before=$(get_epoll)
	iperf3 -c ${remote} -b ${bw}M -u -J -l ${pktlen} ${xtra_args} > ${f}
	epoll_after=$(get_epoll)

	lost_packets=$(jq .end.sum.lost_packets ${f})
	packets=$(jq .end.sum.packets ${f})
	seconds=$(jq .end.sum.seconds ${f})

	res_bw=$(bc -l <<< "8*$pktlen*($packets-$lost_packets)/$seconds")
	res_epoll=$(bc -l <<< "$epoll_after-$epoll_before")

	echo $bw,$res_bw,$res_epoll >> $log
done
