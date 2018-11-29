#!/bin/bash

file=$0
[[ -L $0 ]] && file=`readlink $0`
cd `dirname $file`

watch -n ${3:-1} -c "nmap -p $2 $1 | ./color-status.awk"
