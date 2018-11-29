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
        "date -r ./status +%s" | getline prev_date
        delta = cur_date - prev_date
        "date -u -d @" delta " +'%-Hh %-Mm %-Ss'" | getline timelapse
        printf blue("since " timelapse)
    } else {
        printf cur_status > "./status"
    }
}


BEGIN {
    getline prev_status < "./status"
}

/3128\/tcp open/ {
    print green($0)
    status("open")
    next
}

/3128\/tcp closed/ {
    print red($0)
    status("closed")
    next
}

{
    print $0
}
