#!/bin/bash


EXEC_FUNC=${1}

function _help {
    echo "========================================================="
    echo "# Description: Help Function"
    echo "========================================================="
    echo "----------------------------------------------------"
    echo "EX       : ${0} help"
    echo "         : ${0} build"
    echo "         : ${0} all"
    echo "----------------------------------------------------"
}

function _build {
    dpkg-buildpackage -rfakeroot -b
    cd ..
    mv -f sonic-platform-ingrasys-s9100_*_amd64.deb platform-driver/build/.
}

function _main {
    tart_time_str=`date`
    start_time_sec=$(date +%s)

    if [ "${EXEC_FUNC}" == "help" ]; then
        _help
    elif [ "${EXEC_FUNC}" == "build" ]; then
        _build
    elif [ "${EXEC_FUNC}" == "all" ]; then
        _build
    else
        _build
    fi

    end_time_str=`date`
    end_time_sec=$(date +%s)
    diff_time=$[ ${end_time_sec} - ${start_time_sec} ]
    echo "Start Time: ${start_time_str} (${start_time_sec})"
    echo "End Time  : ${end_time_str} (${end_time_sec})"
    echo "Total Execution Time: ${diff_time} sec"

    echo "done!!!"
}

_main
