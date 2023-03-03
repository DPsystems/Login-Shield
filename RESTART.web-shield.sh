# This script is used for when you have login-shield already running and have done a
# git pull and retrived an updated list
# this will flush the existing config and rebuild the system

# remove iptables reference
./set-iptables.sh del
# clear existing list
ipset flush login-shield
# reload the whole system (NOTE: replace this with whatever startup command you're using if different)
./START.login-shield.sh

