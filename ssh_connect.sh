#!/bin/bash
set -e
SSH=`which ssh`
SSH_FILE="$HOME/.ip_ssh"
SSH_KEY_PATH="$HOME/.ssh"
param="$1"

if [ $# -ne 1 ]
    then
      echo "Usage: $0 <host>"
      exit 1
fi

if [ -s $SSH_FILE ]
    then
        line=( $( grep ${param} ${SSH_FILE} |awk -F "|" '{print $1" "$2" "$3" "$4" "$5}') )
        HOST=${line[0]}
        USER=${line[2]}
        PORT=${line[3]}
        SSH_KEY=${line[4]}
        CMD=""
        if [ -z ${PORT} ]
            then
                CMD="$SSH ${USER}@${HOST}"
            else
                CMD="$SSH ${USER}@${HOST} -p ${PORT}"
        fi
        if [ ! -z ${SSH_KEY} ] && [ -f "$SSH_KEY_PATH/$SSH_KEY" ]
            then
                CMD=$CMD" -i $SSH_KEY_PATH/$SSH_KEY"
            #else
            #  exit 1
        fi
        $CMD
    else
        echo "[ERROR]: ${SSH_FILE} doesn't exists"
        exit 1
fi
