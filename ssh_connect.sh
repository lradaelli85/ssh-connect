#!/bin/bash

SSH=`which ssh`
SSH_FILE="$HOME/.ip_ssh"
param="$1"

validate_ip () {
local ip
not_valid=0
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
if [ ${err} == 1 ]
    then
        echo "not a valid ip"
        exit 1;
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
local cont=0
until [ $cont -eq ${#vettore_ip[@]} ]; do
echo $cont"_"${vettore_ip[$cont]}"->"${vettore_host[$cont]}
let cont=cont+1
done
}

pop_vector() {
  local j=0
  err_mess="you need to adjust parameter in your $SSH_FILE"
  if [ -e $SSH_FILE ]
    then
      while IFS="|" read ip host user port
      do
        if [[ ! "$ip" =~ ^#|$^ ]]
        then
	        [[ ${ip:?$err_mess} ]]
            vettore_ip[$j]="$ip"
	        [[ ${host:?$err_mess} ]]
            vettore_host[$j]="$host"
	        [[ ${user:?$err_mess} ]]
            vettore_user[$j]="$user"
          vettore_port[$j]="$port"
          let j=j+1
        fi
      done < $SSH_FILE
    else
      echo $SSH_FILE "does not exist"
fi
}

ask(){
until [[ "$id" =~ ^-?[0-9]+$ ]] && [ "$id" -ge 0 ] && [ "$id" -lt "${#vettore_ip[@]}" ]; do
echo "choose the system ID you want to connect to"
read id
done
}

usage
pop_vector
print_menu
ask
validate_ip ${vettore_ip[$id]}
if [ -z ${vettore_port[$id]} ]
  then
    $SSH ${vettore_user[$id]}@${vettore_ip[$id]}
  else
    $SSH ${vettore_user[$id]}@${vettore_ip[$id]} -p ${vettore_port[$id]}
fi
