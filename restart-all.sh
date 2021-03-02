# this script should be run in whatever directory login-shield is installed.
# This will run through all the steps to reinstate the blacklist - this is interactive
#
./create-blacklist.sh
./blacklist-main-nonUS.sh
./blacklist-others.sh
./blacklist-proxies.sh
./blacklist-US-hosting.sh
./set-iptables.sh

