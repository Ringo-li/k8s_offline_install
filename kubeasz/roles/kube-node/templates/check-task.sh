#!/bin/sh
check_task=`ps -aux | grep kubernetes-dashboard | grep -v grep | wc -l`

# if [ $check_squid -eq 1 -a $check_task -eq 1 ]; then
if [ $check_task -ge 1 ]; then
    exit 0
else
    exit 1
fi 