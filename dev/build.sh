#! /bin/sh

packer build packer.json 2>&1 | tee build.txt
AMI=$(tail -2 build.txt | head -2 | awk 'match($0, /ami-.*/) { print substr($0, RSTART, RLENGTH) }')
printf "%s" "$NGINX_AMI" > AMI.txt
rm build.txt
TF_VAR_AMI_ID=$(cat AMI.txt) terraform apply  