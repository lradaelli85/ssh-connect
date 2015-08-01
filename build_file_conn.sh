#!/bin/bash
#Description:script that add elements to the ssh_connect.sh configuration file
#Author: Luca Radaelli <lradaelli85@users.noreply.github.com>

file_ssh="$HOME/.ip_ssh"

add_elem(){
  if [ ! -z "$1" ] && [ ! -z "$2" ] && [ ! -z "$3" ] && [ ! -z "$4" ]  
  then 
  echo "$@" >> $file_ssh
  fi
}

if [ -e $file_ssh ] && [ $# -eq 4 ]
 then
    echo "adding $@ to file $file_ssh"
    add_elem $1 $2 $3 $4
elif [ ! -e $file_ssh ] && [ $# -eq 4 ]
   then
   echo "file $file_ssh does not exists,i'm going to create it"
   touch $file_ssh
   echo "adding $@ to file $file_ssh"
   add_elem $1 $2 $3 $4
 else
   echo "invalid parameter"
   echo "usage: $0 ipaddress logicalname username port"
fi

