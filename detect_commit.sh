#!/bin/bash
#set -x
set -eo pipefail

if [[ $# -ne 2 ]]; then
   echo "2 arguments required - oldhash newhash"
   echo "Example: $0 bc253616f3e49682eb556febc2b8f7cc55dbcf10 79cc3041918841ac4a05869a0970d065f0451866"
   exit
fi

beforeC=$1
afterC=$2

grepRegex="^[0-9]\.[0-9]dev$\|^[0-9]\.[0-9]stage$\|^[0-9]\.[0-9]prod$"
gitRev=`git rev-list  "$beforeC".."$afterC"`

for hashes in $gitRev
 do
   getResult=$getResult`git branch  --contains $hashes | sed s/\*//g | sed 's/ *//g' | grep "master"`$'\n'
   sortResult=`echo $getResult | xargs -n1 | sort -fu`
done

for pushes in $sortResult
do
echo  curl "http://ulautomat:2a633d89702d42e402ff6920bc313d34@ulautomation2017.abilixsoft.eu:8080/job/testGraphPrj/buildWithParameters?token=asd&vTag=$pushes"

curl "http://ulautomat:2a633d89702d42e402ff6920bc313d34@ulautomation2017.abilixsoft.eu:8080/job/idf-databaseApi/buildWithParameters?token=asd&vTag=$pushes"

done
