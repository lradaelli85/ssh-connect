#!/bin/bash
#Description:script that add elements to the ssh_connect.sh configuration file
#Author: Luca Radaelli <lradaelli85@users.noreply.github.com>

file_ssh="$HOME/.ip_ssh"

add_elem(){
  if [ ! -z "$1" ]
  then
  echo "$1" >> $file_ssh
  fi
}


if [ ! -e $file_ssh ]
   then
   echo "file $file_ssh does not exists,i'm going to create it"
   touch $file_ssh
fi
if [ $# -eq 4 ]
 then
  echo "adding $@ to file $file_ssh"
  var="$1|$2|$3|$4"
  add_elem ${var}
  else
    echo "invalid parameter"
    echo "usage: $0 ipaddress logicalname username port"
fi
