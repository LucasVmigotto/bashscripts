#!/usr/bin/env bash

print_info () {
    echo "$(date +'%D %T')"
    echo "Day of the year: $(date +%j)"
    echo "Day of the week: $(date +%u)"
    echo "Week number of the year: $(date +%W)"
    echo "Four moth period: $(date +%q)"
    echo "Time zone: $(date +%:Z)"
    echo "Century: $(date +%C)"
}

while [[ 1 ]]; do
    printf "\033c"
    print_info
    sleep 1
done

exit $?