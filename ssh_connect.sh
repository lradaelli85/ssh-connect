#!/bin/bash

SSH=`which ssh`
SSH_FILE="$HOME/.ip_ssh"
param="$1"

validate_ip () {
local ip
not_valid=0

#Strip the "." and check if chars are all numbers
if [[ ${1//.} =~ ^[[:digit:]]+$ ]]
then
ip=($(echo $1 |awk -F'.' '{print $1" "$2" "$3" "$4}'))
if [ ${#ip[@]} -eq 4 ]
    then
          for i in ${ip[@]}
               do
                    if [[ ! "${i}" =~ ^[0-9]{1,3}$ ]] || [ "${i}" -lt 0 ] || [ "${i}" -gt 255 ]
                        then
                            not_valid=1
                    fi
               done
    else
        not_valid=1
fi
if [ ${not_valid} -eq 1 ]
    then
        echo "not a valid ip"
        exit 1;
fi
fi
}

usage() {
local n_param="$#"
if [ $n_param -gt 0 ]
then
case $param in
-h) echo "script usage: $0"
    exit;
    ;;
*)  echo "invalid option,try with $0 -h"
    exit 1;
    ;;
esac
fi
}

print_menu() {
#clear
local menu_file="none"
if [ ${#vettore_ip[@]} -gt 20 ]
then
  local menu_file=$(mktemp /tmp/connect.XXXXX)
  local echo_opt=">> \$menu_file"
fi

local cont=0
until [ $cont -eq ${#vettore_ip[@]} ]; do
eval echo "$cont\) ${vettore_ip[$cont]} --\> ${vettore_host[$cont]}" $echo_opt
let cont=cont+1
done

if [ -f $menu_file ]
then
less -e -n $menu_file
rm $menu_file
fi
}

pop_vector() {
  local j=0
  err_mess="you need to adjust parameter in your $SSH_FILE"
  if [ -e $SSH_FILE ]
    then
      while IFS="|" read ip host user port ssh_key
      do
        if [[ ! "$ip" =~ ^#|$^ ]]
        then
	        [[ ${ip:?$err_mess} ]]
            vettore_ip[$j]="$ip"
	        [[ ${host:?$err_mess} ]]
            vettore_host[$j]="$host"
	        [[ ${user:?$err_mess} ]]
            vettore_user[$j]="$user"
          [[ ${port:="22"} ]]
            vettore_port[$j]="$port"
          if [ -f ${ssh_key} ]
            then
              vettore_key[$j]="$ssh_key"
            else
              echo "ssh key ${ssh_key} for host \"${host}\" doesn't exists,exiting now!"
              exit 1;
          fi
          let j=j+1
        fi
      done < $SSH_FILE
    else
      echo $SSH_FILE "does not exist"
fi
}

ask(){
until [[ "$id" =~ ^-?[0-9]+$ ]] && [ "$id" -ge 0 ] && [ "$id" -lt "${#vettore_ip[@]}" ]; do
echo
read -p "choose the system ID you want to connect to: " id
done
}


usage
pop_vector
print_menu
ask
validate_ip ${vettore_ip[$id]}

if [ -z ${vettore_key[$id]} ]
  then
    $SSH ${vettore_user[$id]}@${vettore_ip[$id]} -p ${vettore_port[$id]}
  else
    $SSH -i ${vettore_key[$id]} ${vettore_user[$id]}@${vettore_ip[$id]} -p ${vettore_port[$id]}
fi  
