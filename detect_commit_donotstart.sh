#!/bin/bash
#set -x
set -eo pipefail
#source /home/graphbuildertmp/ULAutomation.jenkins/install/include.sh
REPOPATH="$HOME/ULAutomation.jenkins/tmp/tmp/"
BUILDPROJECTS="testProj"
currentFolders=`ls $REPOPATH`
committer=$1

#checks if pushes to the repos are made and triggers curl in case there are.
launchIfNeeded() {
cFolder=$1
sendMail=$2

if [[ $# -ne 2 ]]; then
    echo "Missing arguments to function launchIfNeeded. Exacly 2 required. - folderName & email"
    exit
fi

ChangesDetected=0;
for project in $BUILDPROJECTS
do
 set +eo pipefail
  echo  git -C $REPOPATH/$cFolder/ pull | grep -e "^Already up-to-date\.$"
  git -C $REPOPATH/$cFolder/ pull  | grep -e "^Already up-to-date\.$"
  if [[ $? -ne 0 ]]; then
	  set -eo pipefail
    ChangesDetected=1 
    echo "Changes detected!"
  fi
done

if [[ $ChangesDetected -eq 1 ]]; then
   curl "http://ulautomat:2a633d89702d42e402ff6920bc313d34@ulautomation2017.abilixsoft.eu:8080/job/testGraphPrj/buildWithParameters?token=asd&vTag=$cFolder&sendTo=$sendMail"
fi 

}

for folder in $currentFolders
 do
  launchIfNeeded $folder $committer
done
