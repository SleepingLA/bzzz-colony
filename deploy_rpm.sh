#!/bin/bash

source utils.sh


liste=$(list_client)
for node in $liste
do

 scp beegfs.repo  ${node}:/etc/yum.repos.d/
 ssh ${node} yum -y install beegfs-storage  beegfs-client  beegfs-helperd

 # infiniband support 
 if [ IB -eq 1 ] ; then
  ssh ${node} yum -y install kernel-devel gcc
  ssh ${node} yum -y  groupinstall "Infiniband Support"
 fi

done

liste=$(liste_meta)
for node in $liste
do
	ssh ${node} yum -y install beegfs-meta
done

liste=$(liste_mgmt)
for node in $liste
do
	ssh ${node} yum -y install beegfs-mgmtd
done
