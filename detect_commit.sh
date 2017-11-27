#!/bin/bash
#set -x
beforeC=$1
afterC=$2

#grepRegex="^[0-9]\.[0-9]dev$\|^[0-9]\.[0-9]stage$\|^[0-9]\.[0-9]prod$"
gitRev=$(git rev-list  "$beforeC".."$afterC")
echo $gitRev

for branches in $gitRev
 do
   getResult=`git branch  --contains $branches`
   sortResult=$sortResult `echo "$getResult" | sort -fu | grep -e "$grepRegex"`
done

for pushes in $sortResult
do
echo  curl "http://ulautomat:2a633d89702d42e402ff6920bc313d34@ulautomation2017.abilixsoft.eu:8080/job/idf-databaseApi/buildWithParameters?token=asd&$pushes"
done
