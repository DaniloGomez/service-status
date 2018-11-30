#!/bin/bash

file=$0
[[ -L $0 ]] && file=`readlink $0`
cd `dirname $file`

echo "unknown" > .status
watch -n ${3:-1} -c "nmap -T4 -p $2 $1 | ./color-status.awk"
