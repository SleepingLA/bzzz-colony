#! /bin/bash
source utils.sh
cmd=stop


#STOP CLIENT
liste=$(list_client)
for node in $liste
do

	#ssh ${node} service beegfs-client scmd
	ssh ${node} /etc/init.d/beegfs-client stop

        ssh ${node} service beegfs-helperd stop

done



#STOP SERVER

mgmt=$(list_mgmt)
ssh ${mgmt} service beegfs-mgmtd stop


liste=$(list_meta)
for node in $liste
do
	ssh ${node} service beegfs-meta stop

done



liste=$(list_storage)
for node in $liste
do

	ssh ${node} service beegfs-storage $cmd

done

