
#beegfs-setup-rdma
#
# faut sassurer que rdma soit installer sinon les storage nodes ne se parleront pas
#

source utils.sh

liste=$(list_client)
for node in $liste
do

 scp beegfs/beegfs-client-autobuild.conf ${node}:/etc/beegfs/ 
 scp beegfs/beegfs-client.conf    ${node}:/etc/beegfs/
 scp beegfs/beegfs-storage.conf ${node}:/etc/beegfs/
 ssh ${node} /etc/init.d/beegfs-client rebuild

done


liste=$(liste_meta)
for node in $liste
do

 scp beegfs/beegfs-meta.conf   ${node}:/etc/beegfs/

done


mgmt=$(liste_mgmt)
scp beegfs/beegfs-mgmtd.conf  ${mgmt}:/etc/beegfs/
