#!/bin/bash




echo $a
jq -r -M '.nodes |to_entries[] | [.key] | .[0] ' ./nodes.json | \
while read -r key; do 
    if [[ ${key} != *"puppet"* ]];then
        echo "host = $key"
        echo "vagrant ssh "${key}" -c 'sudo puppet agent --test' --waitforcert 5; "
        vagrant ssh "${key}" -c "sudo puppet agent --test --waitforcert 5" & 
    fi
done;

sleep 30
vagrant ssh puppet.example.com -c "puppet cert --sign --all"
#jq -r '.nodes |to_entries[] | [.key] | .[0] ' ./nodes.json; while read -r {key} ;
# do
# done
exit 0