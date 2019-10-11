#!/bin/bash
#
#
####
SET_NAME=login-shield
FILE="./ipset-proxies.lst"

if [[ $1 = @(del|delete|DELETE) ]]; then
  PARM="del"
else
  PARM=""
fi

echo '#######'
echo '#'
if [[ $PARM == "del" ]]; then
  echo -n "Removing entries from $FILE in the $SET_NAME blacklist, which contains "
else
  echo -n "Adding $FILE to the $SET_NAME blacklist, which contains "
fi
echo `cat $FILE | grep '^[[:blank:]]*[^[:blank:]#;]' | wc -l` "IP blocks."

head -n 6 $FILE

read -p "Continue (Y/n)?" CONT

if [[ $CONT =~ ^(y|Y|$) ]]; then # this also accept ENTER, to default to No remove the |$
  echo "Yes";

  # this will not reject non proper lines - Expects: a.b.c.d/cidr
  while read -r line; do
    [[ "$line" =~ ^#.*$ ]] && continue
    [[ "$line" =~ ^$ ]] && continue

    if [[ $PARM == "del" ]]; then
      echo "  UN-Blacklisting ${line}"
      ipset del $SET_NAME ${line}
    else
      echo "  Blacklisting ${line}"
      ipset add $SET_NAME ${line}
    fi
  done < "$FILE"
  echo "## end."


else
  echo "Operation Cancelled";
  exit;
fi


