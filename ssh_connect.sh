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
      
      if [ -e $SSH_FILE ]   
        then
        while read ip host user port 
        do
        if [ -z $ip ] || [ -z $host ] || [ -z $user ]
         then       
           echo "you need to set: ip address or hostname or user in your "$SSH_FILE
           echo "please correct this line "$j" of your "$SSH_FILE 
           exit 1;
        else
        vettore_ip[$j]=$ip
        vettore_host[$j]=$host
        vettore_user[$j]=$user
        vettore_port[$j]=$port
        let j=j+1
        fi
        done < $SSH_FILE
       else
       echo $SSH_FILE "does not exist"
fi

}

ask(){
until [[ $id =~ ^-?[0-9]+$ ]] && [ "$id" -ge 0 ] && [ "$id" -lt "${#vettore_ip[@]}" ]; do
echo "choose the system ID you want to connect to"
read id
done
}

pop_vector
print_menu
ask
if [ -z ${vettore_port[$id]} ]
   then
     $SSH ${vettore_user[$id]}@${vettore_ip[$id]}
   else
     $SSH ${vettore_user[$id]}@${vettore_ip[$id]} -p ${vettore_port[$id]}
fi
