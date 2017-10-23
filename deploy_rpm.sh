#!/bin/bash

source utils.sh

IB=1

liste=$(list_client)
for node in $liste
do

 scp beegfs.repo  ${node}:/etc/yum.repos.d/
 ssh ${node} yum -y install beegfs-storage  beegfs-client  beegfs-helperd beegfs-utils

 # infiniband support 
 if [ $IB -eq 1 ] ; then
  ssh ${node} yum -y install kernel-devel gcc
  #ssh ${node} yum -y  groupinstall "Infiniband Support"
  ssh ${node} yum -y  groupinstall "Infiniband"
  #recompile module?
  ssh ${node} yum -y install gcc-c++ libibverbs-devel librdmacm-devel
  #ssh ${node} yum -y install  beegfs-opentk-lib beegfs-admon
 fi

done

liste=$(list_meta)
for node in $liste
do
	ssh ${node} yum -y install beegfs-meta
done

liste=$(list_mgmt)
for node in $liste
do
	ssh ${node} yum -y install beegfs-mgmtd
done
