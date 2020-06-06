#!/bin/bash
#
# This script compiles stats from the logfiles on attacks and blocks 
# (assuming you added the rule to log iptables blocks for login-shield)
#
BL_LOGFILE=/var/log/messages
# keyword we're grep'ing to ID a blocked hack attempt
#BL_GREP="WINDOW"
# New grep versions as of v 0.10b
# all *-shield blacklists
BL_GREP="ShD-"



# filespec of logfile containing invalid login attempts
AUTH_LOGFILE=/var/log/secure
# keyword we're grep'ing to ID an auth attemp
AUTH_GREP="authentication failure"

echo '  _                 _             _____ _     _      _     _'
echo ' | |               (_)           / ____| |   (_)    | |   | |'
echo ' | |     ___   __ _ _ _ __ _____| (___ | |__  _  ___| | __| |'
echo ' | |    / _ \ / _` | | ^_ \______\___ \|  _ \| |/ _ \ |/ _` |'
echo ' | |___| (_) | (_| | | | | |     ____) | | | | |  __/ | (_| |'
echo ' |______\___/ \__, |_|_| |_|    |_____/|_| |_|_|\___|_|\__,_|'
echo '               __/ |'
echo '              |___/'
echo '============= Login-Shield Statistics based on current log files ==========='
echo " Using: $BL_LOGFILE and $AUTH_LOGFILE"
FAILS=`cat $AUTH_LOGFILE | grep -i "$AUTH_GREP" | wc -l`
echo "-- Number of login failures in log files: $FAILS"
echo -n "Start: "
head -n 1 /var/log/secure
echo -n "End  : "
tail -n 1 /var/log/secure
echo "===================================== "
BLOCKS=`cat $BL_LOGFILE | grep -i $BL_GREP | wc -l`
echo "--        Number of filtered connections: $BLOCKS"
echo -n "Start: "
head -n 1 /var/log/messages
echo -n "End  : "
tail -n 1 /var/log/messages
echo "============================================================================"
TOTAL=`expr $FAILS + $BLOCKS`
UNCAUGHTPCT=`awk "BEGIN { print $FAILS / $TOTAL }"`
CAUGHTPCT=`awk "BEGIN { print 100 - (100*$UNCAUGHTPCT) }"`

echo "Total system attacks: $TOTAL"
echo "Blocked attempts    : $BLOCKS"
echo "Attacks got through : $FAILS"
echo "---------------------------------"
echo "% Of Attacks Blocked: $CAUGHTPCT% "
echo "============================================================================"


