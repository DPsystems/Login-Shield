#!/bin/bash
#
# Script to analyze login-shield blocked attack attemps and generate
# statistics identifying the most aggressive sources of attacks
#

# filespec of logfile containing invalid login attempts
BL_LOGFILE=/var/log/messages
BL_GREP="WINDOW"

echo '  _                 _             _____ _     _      _     _'
echo ' | |               (_)           / ____| |   (_)    | |   | |'
echo ' | |     ___   __ _ _ _ __ _____| (___ | |__  _  ___| | __| |'
echo ' | |    / _ \ / _` | | ^_ \______\___ \|  _ \| |/ _ \ |/ _` |'
echo ' | |___| (_) | (_| | | | | |     ____) | | | | |  __/ | (_| |'
echo ' |______\___/ \__, |_|_| |_|    |_____/|_| |_|_|\___|_|\__,_|'
echo '               __/ |'
echo '              |___/'
echo '======= Attack Statistics based on current log files ======='
echo " Using: $BL_LOGFILE"
echo
START=`head -n 1 $BL_LOGFILE | cut -d ' ' -f 1-4`
echo "From: $START"
END=`tail -n 1 $BL_LOGFILE | cut -d ' ' -f 1-4`
echo "To  : $END"
echo

cat $BL_LOGFILE  | grep -i "$BL_GREP" > temp.txt
FAILS=`cat temp.txt | wc -l`

echo "-- Number of blocked attacks in log files  : $FAILS"

# version without ports
cat temp.txt  | cut -d ' ' -f 10 | sed -e 's/SRC=//g' | sed -e 's/DPT=//g' | sed -e 's/ /:/g' > temp2b.txt
sort temp2b.txt | uniq -c > temp3b.txt
sort -r -n temp3b.txt > ip_rankings.txt

UNIQUE_IPS=`cat ip_rankings.txt | wc -l`
echo "-- Number of unique IP addresses attacking : $UNIQUE_IPS"
echo 
echo "      Top 20:"
echo "Attacks:  IP Address:"
echo "---------------------"
head -n 20 ip_rankings.txt

