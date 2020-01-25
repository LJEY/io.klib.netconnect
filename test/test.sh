#!/bin/bash
#set -u
#set -e
scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

printf "\n#\n# docker proxy container test\n#\n\n"

jarFile=./../build/libs/io.klib.netconnect-0.1.0-SNAPSHOT.jar

dockerName=proxy

proxyHost=127.0.0.1
proxyPort=8080

httpUrlWorking=http://www.httpvshttps.com/
httpUrlBroken=http://www.httpvshttp.com/

httpsUrlWorking=https://www.heise.de
httpsUrlBroken=https://gooogle.de

function proxyCheck {
 eval var='$'$1_proxy
 printf "%s" "checking for existing $1 proxy"
 if [ -z "$var" ]; then
   printf " - %s\n" "no proxy found"
 else
   printf " - %s\n" "existing proxy $var"
   exit 1
 fi
}

function testConnection {
for i in {1..5}; do
 java ${javaVMArgs} -jar ${jarFile} $1 >> ${scriptDir}/java_output.log 2>> ${scriptDir}/java_error.log
 if [ $? == 0 ]; then
   printf " %s\n" "$1 - working"
 else
   printf " %s\n" "$1 - not working"
 fi
done
printf " %s\n"
#printf " %s\n" "Success"
}

printf "\nchecking for existing docker container\n"

result=$( sudo docker ps -qaf "name=$dockerName" )

if [[ -n "$result" ]]; then
  echo "container exists removing it"
  docker rm -f $dockerName
else
  echo "no such container, proceeding..."
fi
       
printf "\n## checking for existing proxy\n\n"
proxyCheck http
proxyCheck https

printf "\n## without proxy\n\n"

printf "\n### testing connections\n\n"

testConnection ${httpUrlWorking}
testConnection ${httpUrlBroken}
testConnection ${httpsUrlWorking}
testConnection ${httpsUrlBroken}

printf "\n## with proxy\n\n"

printf "starting forwarding proxy server docker container with\n"
docker run --name ${dockerName} -d -p 8080:8080 klibio/io.klib.forwarding-ssl-proxy:master-latest  $1 >> ${scriptDir}/docker_output.log 2>> ${scriptDir}/docker_error.log
if [ $? == 0 ]; then
 printf "container successfully launched %s\n"
else
 printf "container launching failed - exiting"; exit 1;
fi

printf "\n## configuring proxy\n"

javaVMArgs="-Dhttp.proxyHost=127.0.0.1 -Dhttp.proxyPort=8080 -Dhttps.proxyHost=127.0.0.1 -Dhttps.proxyPort=8080"

export proxyHost=http://127.0.0.1
export proxyPort=8080

#Klappt würde danach bei proxyCheck wieder rausgehen, was jetzt machen?
#export http_proxy=$proxyHost:$proxyPort
#export https_proxy=$proxyHost:$proxyPort

proxyCheck http
proxyCheck https


printf "\n### testing connections\n\n"
testConnection ${httpUrlWorking}
testConnection ${httpUrlBroken}

testConnection ${httpsUrlWorking}
testConnection ${httpsUrlBroken}

printf "\nkilling docker container\n"
idProxy=`docker ps -f name=${dockerName} -q`
docker container kill ${idProxy} $1 >> ${scriptDir}/docker_output.log 2>> ${scriptDir}/docker_error.log
