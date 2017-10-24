#!/bin/bash

source utils.sh

liste=$(list_client)
for node in $liste
do

 scp beegfs.repo  ${node}:/etc/yum.repos.d/
 ssh ${node} yum -y install beeond

done
echo
echo Start command
echo
echo beeond start -n nodefile  -d /state/partition1/beeond -c /state/partition1/mntbeond
