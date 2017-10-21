
source utils.sh

cmd=start



echo demarrage du node mgmt
mgmt=$(list_mgmt)
ssh ${mgmt} service beegfs-mgmtd start

sleep 2
echo demarrage des node meta

liste=$(list_meta)
for node in $liste
do
	ssh ${node} service beegfs-meta start

done

sleep 2
echo demarrage des node storage

liste=$(list_storage)
for node in $liste
do

	ssh ${node} service beegfs-storage $cmd
	#ssh ${node} service beegfs-client scmd
done

sleep 5
echo demarrage des nodemount

#START CLIENT
liste=$(list_client)
for node in $liste
do
	#nouveau
	ssh ${node} service beegfs-helperd $cmd

	#ssh ${node} service beegfs-client scmd
	ssh ${node} /etc/init.d/beegfs-client start

done

