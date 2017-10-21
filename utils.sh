#/bin/bash

nodefile=nodes.txt

#todo init
#nodefile=$1

list_lines() {
 cat $1 | grep -v "#" | grep $2 | awk '{print $1 }'
}

list_client(){
 list_lines $nodefile CLIENT
}

list_mgmt(){
 list_lines $nodefile MGMT
}

list_storage(){
 list_lines $nodefile STORAGE
}

list_meta(){
 list_lines $nodefile META
}
