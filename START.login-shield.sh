# Rename this to S.login-shield.sh after customizing
# run as root
#
# specify the location of your login shield installation
PATH=/path-to-your/installation
#
#
cd $PATH
echo "This script creates and intializes the login-shield blacklist"
echo ""
# create the ipset list
./create-blacklist.sh
#
# Edit or comment out any lists you don't want added
#
./blacklist-main-nonUS.sh
./blacklist-others.sh
./blacklist-proxies.sh
./blacklist-US-hosting.sh
#
./set-iptables.sh
#
echo "## Done."

