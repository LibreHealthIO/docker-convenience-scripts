#!/bin/bash

# The script repeates docker_clone_volume.sh
# Thanks to maddin25 who provides solution in
# https://stackoverflow.com/questions/42973347/how-to-copy-docker-volume-from-one-machine-to-another

# The script is mainly useful if you are using named volumes and
# on both hosts you should have running docker diemon
# and have access to root, obviously.

# arg: $1: source volume name
# arg: $2: target host
# arg: $3: target volume name

#First check if the user provided all needed arguments
if [ "$1" = "" ]
then
        echo "Please provide a source volume name"
        exit
fi

if [ "$2" = "" ]
then
        echo "Please provide a target host (e.g. 1.1.1.1)"
        exit
fi

if [ "$3" = "" ]
then
        echo "Please provide a target volume name"
        exit
fi


#Check if the source volume name does exist
docker volume inspect $1 > /dev/null 2>&1
if [ "$?" != "0" ]
then
        echo "The source volume \"$1\" does not exist"
        exit
fi

docker run --rm \
           -v $1:/from alpine ash -c \
           "cd /from ; tar -czf - . " | \
           ssh $2 \
           "docker run --rm -i -v \"$3\":/to alpine ash -c 'cd /to ; tar -xpvzf - '"
