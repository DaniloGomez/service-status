#!/usr/bin/gawk -f

function red(s) {
    printf "\033[1;31m" s "\033[0m "
}

function green(s) {
    printf "\033[1;32m" s "\033[0m "
}

function blue(s) {
    printf "\033[1;34m" s "\033[0m "
}

function set_status(status) {
    STATUS = status
    print status > STATUS_FILE
}

function log_status(status) {
    getline STATUS < STATUS_FILE
    "date +%s" | getline cur_date

    if (status == STATUS) {
        "date -r " STATUS_FILE " +%s" | getline prev_date
        delta = cur_date - prev_date
        "date -u -d @" delta " +'%-Hh %-Mm %-Ss'" | getline timelapse
        printf blue("since " timelapse)
    } else {
        set_status(status)
    }
}


BEGIN {
    STATUS_FILE = ".status"
    STATUS = ""
}

/[[:digit:]]+\/(udp|tcp|stcp) open/ {
    print green($0)
    log_status("open")
    next
}

/[[:digit:]]+\/(udp|tcp|stcp) closed/ {
    print red($0)
    log_status("closed")
    next
}

{
    print $0
}

END {
    if (STATUS == "") {
        set_status("unknown")
    }
}
