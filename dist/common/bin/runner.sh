#!/bin/bash

# Usage:
# runner.sh mode /path/to/solver /path/to/input/dir /path/to/output/dir
# mode = quiet|verbose|file

mode="$1"
prob_name=$4
solver=$3/$4
data_d=../../data/$2
output_d=$3/$2
ostream=/dev/null

command_exists () {
    type "$1" > /dev/null 2>&1 ;
}

timeit () {
    if command_exists /usr/bin/time ; then
        if [ $? -eq 0 ]; then
            /usr/bin/time "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" > $ostream
            return
        fi
    elif [ $mode = 'verbose' ]; then
        if command_exists time ; then
            time "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9"
            return
        fi
    fi
    "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9"
}

puts () {
    echo "$1" > $ostream
}

write () {
    echo -n "$1" > $ostream
}

view_file () {
    filename="$1"    
    write '<'
    cat "$filename" > $ostream
    puts '>'
}

report_case () {
    write '    Input: '
    view_file "$data_d/$test_case.in"
    write '    Expected: '
    view_file "$data_d/$test_case.out"
    write '    Received: '
    view_file "$output_d/$test_case.out"
}

init () {
    export TIME="Time: %es - Memory: %MK"
    export TIMEFORMAT=%3lR

    if [ ! -d "$output_d" ]; then
        mkdir "$output_d"
    fi 

    if [ "$mode" = 'verbose' ]; then
        ostream=/dev/stdout
    elif [ "$mode" = 'file' ]; then
        ostream=log
    fi

    dir=`dirname $0`
    #if [ ! -x "$checker" ]; then
	undo=`pwd`
	cd "../../util/check"
	make
	cd "$undo"
    #fi
} 

main () {
    cases=0

    fails=0

    errors=0
    failstr=''

    errorstr=''
    for input in "$data_d"/*.in; do 
        if [ -f "$input" ]; then
            cases=$(( cases + 1 ))

            test_case=`basename "$input"` 
            test_case=${test_case%.in}

            write "Check $test_case ... "
            timeit "$solver" "$data_d/$test_case.in" "$output_d/$test_case.out"
			checker="$dir/../../build/"$prob_name"/check" 
            "$checker" "$data_d/$test_case.out" "$output_d/$test_case.out" > $ostream
            retcode=$?

            if [ $retcode -eq 0 ]; then
                puts 'Passed'

            elif [ $retcode -eq 1 ]; then
                fails=$(( fails + 1 ))
                failstr="$failstr $test_case"
                puts 'Failed'
                report_case "$test_case"

            else 
                errors=$(( errors + 1 ))
                errorstr="$errorstr $test_case"
                puts 'Error'
                report_case "$test_case"
            fi
        fi
    done
    echo "$cases cases checked, $fails failed, $errors errored"
    if [ $fails -gt 0 ]; then
        echo "Failed cases:${failstr}"
    fi
    if [ $errors -gt 0 ]; then
        echo "Errored cases:${errorstr}"
    fi

}

init
main
