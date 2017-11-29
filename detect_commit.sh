#!/bin/bash
set -x
set -eo pipefail
#source /home/graphbuildertmp/ULAutomation.jenkins/install/include.sh
REPOPATH="$HOME/ULAutomation.jenkins/tmp/tmp/"
BUILDPROJECTS="testProj"
currentFolders=`ls $REPOPATH`

#checks if pushes to the repos are made and triggers curl in case there are.
launchIfNeeded() {
cFolder=$1

if [[ $# -ne 1 ]]; then
    echo "Missing argument to function launchIfNeeded. Exacly 1 required. - folderName"
    exit
fi

ChangesDetected=0;
for project in $BUILDPROJECTS
do
 	
  echo  git -C $REPOPATH/$cFolder/ pull | grep -e "^Already up-to-date\.$"
set +e
  git -C $REPOPATH/$cFolder/ pull  | grep -e "^Already up-to-date\.$"
set -e  
  if [[ $? -ne 0 ]]; then
    ChangesDetected=1 
    echo "Changes detected!"
  fi
done

if [[ $ChangesDetected -eq 1 ]]; then
   echo curl "http://ulautomat:2a633d89702d42e402ff6920bc313d34@ulautomation2017.abilixsoft.eu:8080/job/testGraphPrj/buildWithParameters?token=asd&vTag=$cFolder"
fi 

}

for folder in $currentFolders
 do
  launchIfNeeded $folder
done
