#!/bin/bash  
SSH=`which ssh`
cont=0
j=0
SSH_FILE="$HOME/.ip_ssh"

print_menu() {
until [ $cont -eq ${#vettore_ip[@]} ]; do
echo $cont"_"${vettore_ip[$cont]}"->"${vettore_host[$cont]}"->"${vettore_user[$cont]}"->"${vettore_port[$cont]}
let cont=cont+1
done
}

pop_vector() {
         
        while read ip host user port 
        do
        vettore_ip[$j]=$ip
        vettore_host[$j]=$host
        vettore_user[$j]=$user
        vettore_port[$j]=$port
        let j=j+1
        done < $SSH_FILE

}

ask(){
until [[ $id =~ ^-?[0-9]+$ ]] && [ "$id" -ge 0 ] && [ "$id" -lt "${#vettore_ip[@]}" ]; do
echo "choose the system ID you want to connect to"
read id
done
}

parse(){
if [ -e $SSH_FILE ]
then
#this is an hack,awk check if there is some line with an empty parameter
#this mean != 0000 (every zero is printed if parametr is not null).
#so if a != 0000 is reported means that at least one row has not all parameters set
#i decided to skip the port check
res=`awk '{print !$1 !$2 !$3 !$4}' $SSH_FILE |egrep -v "0000|0001" |wc -l`
if [ $res -ne 0 ]
 then 
    echo "check the addresses file,remeber you need to specify at least 3 fields in every row."
    echo "if ssh ports is not defined,22 is used"
    echo "every parameter in a row has to use the space as separator"
  exit 1;
  fi
else
echo "addresses file not found"
exit 1;
fi
}
parse
pop_vector
print_menu
ask
if [ -z ${vettore_port[$id]} ]
   then
     $SSH ${vettore_user[$id]}@${vettore_ip[$id]}
   else
     $SSH ${vettore_user[$id]}@${vettore_ip[$id]} -p ${vettore_port[$id]}
fi
