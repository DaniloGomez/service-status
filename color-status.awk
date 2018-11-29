#!/usr/bin/awk -f

function red(s) {
    printf "\033[1;31m" s "\033[0m "
}

function green(s) {
    printf "\033[1;32m" s "\033[0m "
}

function blue(s) {
    printf "\033[1;34m" s "\033[0m "
}

function status(cur_status) {
    "date +%s" | getline cur_date
    if (prev_status == cur_status) {
        "date -r " STATUS_FILE " +%s" | getline prev_date
        delta = cur_date - prev_date
        "date -u -d @" delta " +'%-Hh %-Mm %-Ss'" | getline timelapse
        printf blue("since " timelapse)
    } else {
        printf cur_status > STATUS_FILE
    }
}


BEGIN {
    STATUS_FILE = ".status"
    getline prev_status < STATUS_FILE
}

/[[:digit:]]+\/(udp|tcp|stcp) open/ {
    print green($0)
    status("open")
    next
}

/[[:digit:]]+\/(udp|tcp|stcp) closed/ {
    print red($0)
    status("closed")
    next
}

{
    print $0
}
