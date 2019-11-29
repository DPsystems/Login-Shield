#!/bin/bash
#
# This script
#
# filespec of logfile containing blacklist entries from kernel (assuming you added the rule to log iptables blocks for login-shield)
BL_LOGFILE=/var/log/messages
# keyword we're grep'ing to ID a blocked hack attempt
BL_GREP="WINDOW"
# filespec of logfile containing invalid login attempts
AUTH_LOGFILE=/var/log/secure
# keyword we're grep'ing to ID an auth attemp
AUTH_GREP="authentication failure"


echo "Number of login failures in log files: "
cat $AUTH_LOGFILE | grep -i "$AUTH_GREP" | wc -l
head -n 1 /var/log/secure
tail -n 1 /var/log/secure
echo "===================================== "
echo "Number of filtered connections: "
cat $BL_LOGFILE | grep -i $BL_GREP | wc -l
head -n 1 /var/log/messages
tail -n 1 /var/log/messages


