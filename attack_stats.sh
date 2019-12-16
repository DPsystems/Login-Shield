#!/bin/bash
#
# Script to analyze login-shield blocked attack attemps and generate
# statistics identifying the most aggressive sources of attacks
#
# OPTIONAL: add parameter "lookup" to display country associated with top attacks

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
START=`head -n 1 $BL_LOGFILE | tr -s ' ' | cut -d ' ' -f 1-3`
echo "From: $START"
END=`tail -n 1 $BL_LOGFILE | tr -s ' ' | cut -d ' ' -f 1-3`
echo "To  : $END"
echo

cat $BL_LOGFILE  | grep -i "$BL_GREP" | tr -s ' ' > temp.txt
FAILS=`cat temp.txt | wc -l`

echo "-- Number of blocked attacks in log files  : $FAILS"

# version without ports
cat temp.txt  | cut -d ' ' -f 9 | sed -e 's/SRC=//g' | sed -e 's/DPT=//g' | sed -e 's/ /:/g' > temp2b.txt
sort temp2b.txt | uniq -c > temp3b.txt
sort -r -n temp3b.txt > ip_rankings.txt

UNIQUE_IPS=`cat ip_rankings.txt | wc -l`
ATKPERIP=`awk "BEGIN { printf \"%d\", $FAILS / $UNIQUE_IPS }"`

TOP5=`head -n 5 ip_rankings.txt | awk '{s+=$1} END {printf "%.0f", s}'`
TOP5PCT=`awk "BEGIN { printf \"%.1f\", $TOP5 / $FAILS * 100 }"`

TOP10=`head -n 10 ip_rankings.txt | awk '{s+=$1} END {printf "%.0f", s}'`
TOP10PCT=`awk "BEGIN { printf \"%.1f\", $TOP10 / $FAILS * 100 }"`

TOP50=`head -n 50 ip_rankings.txt | awk '{s+=$1} END {printf "%.0f", s}'`
TOP50PCT=`awk "BEGIN { printf \"%.1f\", $TOP50 / $FAILS * 100 }"`

echo "-- Number of unique IP addresses attacking : $UNIQUE_IPS"
echo "   Average # of attacks per IP             : $ATKPERIP"
echo "   Percentage of attacks from top 50 IPs   : $TOP50PCT%"
echo "   Percentage of attacks from top 10 IPs   : $TOP10PCT%"
echo "   Percentage of attacks from top 5 IPs    : $TOP5PCT%"
echo

COUNT=20
echo "      Top $COUNT:"

if [ "$1" == "lookup" ]; then

echo "Attacks:  IP Address:  Country:"
echo "-------------------------------"
IFS=''
head -n $COUNT ip_rankings.txt | while read line
do
        echo -n $line
        IP=`echo $line | tr -s ' ' | cut -d ' ' -f 3`
        COUNTRY_LINE=`whois $IP | grep -m 1 'country:'`
        COUNTRY=`echo $COUNTRY_LINE | tr -s ' ' | cut -d ' ' -f 2`
        echo -e -n '\t'
        echo "$COUNTRY"

done

else
	echo "Attacks:  IP Address:"
	echo "---------------------"
	head -n $COUNT ip_rankings.txt
fi
