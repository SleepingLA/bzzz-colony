#!/bin/bash

source utils.sh

localdrive=/state/partition1


###liste=$(list_storage)
liste=$(list_client)
for node in $liste
do
	echo $node
	ssh ${node} rm -fr ${localdrive}/beegfs_meta
	ssh ${node} rm -fr ${localdrive}/beegfs_mgmt
	ssh ${node} rm -fr ${localdrive}/beegfs_storage
done

