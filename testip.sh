#!/bin/bash
#
# This can be used to test to see if a specified IP address
# is in any of your ipste blacklists.
#
# Be sure to edit the file ipsets.lst to list any ipset list
# names you want to check
#
# Note this script doesn't have any input filtering 
# Future updates: add filtering to $1 so that only 0-9. and / are allowed
#
echo ''
file="./ipsets.lst"
#
if [ -z "$1" ]
then
  echo "Usage: $0 <IP address[/CIDR]>"
  exit;
fi
echo "## Testing IP: $1 against IP blacklists..."
while read -r line; do
    [[ "$line" =~ ^#.*$ ]] && continue
    [[ "$line" =~ ^$ ]] && continue
    ipset test ${line} $1
done < "$file"
echo "## end."


