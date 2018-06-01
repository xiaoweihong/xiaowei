#!/bin/bash

SHELL_NAME="INFO"
shell_log(){
    LOG_INFO=$1
    echo "$(date "+%Y-%m-%d") $(date "+%H:%M:%S") : ${SHELL_NAME} : ${LOG_INFO}" >> ${0}.log
}
shell_log $*                                                                                          