
#beegfs-setup-rdma
#
# faut sassurer que rdma soit installer sinon les storage nodes ne se parleront pas
#

source utils.sh

confdir=conf


mgmt=$(list_mgmt)


pushd ${confdir}
conf_list=$(ls | grep conf.template)
for file in $conf_list
do

 newname=$(basename $file .template)
 sed  's,^\(sysMgmtdHost[ ]*=\).*,\1'$mgmt',g' $file >  $newname
 sed -i 's,^\(storeMetaDirectory[ ]*=\).*,\1'/state/partition1/beegfs_meta',g' $newname
 sed -i 's,^\(storeMgmtdDirectory[ ]*=\).*,\1'/state/partition1/beegfs_mgmt',g' $newname
 sed -i 's,^\(storeStorageDirectory[ ]*=\).*,\1'/state/partition1/beegfs_storage',g' $newname
 sed -i 's,^\(tuneStorageSpaceLowLimit[ ]*=\).*,\1'50G',g' $newname
 sed -i 's,^\(tuneStorageSpaceEmergencyLimit[ ]*=\).*,\1'8G',g' $newname
 # conflict with docker?
 sed -i 's,^\(connInterfacesFile[ ]*=\).*,\1'/etc/beegfs/if.conf',g' $newname
 #sed -i 's,^\([ ]*=\).*,\1'',g' $newname
done

popd


# distribute .conf on nodes
scp ${confdir}/beegfs-mgmtd.conf  ${mgmt}:/etc/beegfs/

liste=$(list_client)
for node in $liste
do

 scp ${confdir}/beegfs-client-autobuild.conf ${node}:/etc/beegfs/ 
 scp ${confdir}/beegfs-client.conf    ${node}:/etc/beegfs/
 scp ${confdir}/beegfs-storage.conf ${node}:/etc/beegfs/
 # default interface
 ssh ${node} "echo ib0 > /etc/beegfs/if.conf"
 
 #IB
 IB=1
 if [ IB -eq 1 ] ; then
  ssh ${node} beegfs-setup-rdma -r
  ssh ${node} beegfs-setup-rdma  #symbolic link
  ssh ${node} /etc/init.d/beegfs-client rebuild
 else
  ssh ${node} beegfs-setup-rdma -i off
 fi

 #
 # conflict with docker?
 #ssh ${node} service docker stop
 #ssh ${node} ip link del docker0
done


liste=$(list_meta)
for node in $liste
do

 scp ${confdir}/beegfs-meta.conf   ${node}:/etc/beegfs/

done



# values...
# storeMetaDirectory           = /state/partition1/beegfs_meta
# storeMgmtdDirectory      = /state/partition1/beegfs_mgmt
#< tuneMetaSpaceLowLimit                  = 50G
#< tuneMetaSpaceEmergencyLimit            = 9G
#< tuneStorageSpaceLowLimit               = 50G
#< tuneStorageSpaceEmergencyLimit         = 9G
#< storeStorageDirectory        = /state/partition1/beegfs_storage

