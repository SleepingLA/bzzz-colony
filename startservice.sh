
source utils.sh

cmd=start



echo starting mgmt node
mgmt=$(list_mgmt)
ssh ${mgmt} service beegfs-mgmtd start

sleep 2
echo starting meta nodes

liste=$(list_meta)
for node in $liste
do
	ssh ${node} service beegfs-meta start

done

sleep 2
echo starting storage nodes

liste=$(list_storage)
for node in $liste
do

	ssh ${node} service beegfs-storage $cmd
	#ssh ${node} service beegfs-client scmd
done

sleep 5
echo starting client

#START CLIENT
liste=$(list_client)
for node in $liste
do
	ssh ${node} service beegfs-helperd $cmd
	ssh ${node} service beegfs-client $cmd

done

