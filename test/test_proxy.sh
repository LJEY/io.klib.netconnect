#!/bin/bash

#Check if a there's already a proxy configured (No out put means no proxy configured)
echo "$http_proxy"
echo "$https_proxy"

#Direct connection - no proxy

#HTTP

java -jar /home/lukas/klib/io.klib.netconnect/build/libs/io.klib.netconnect-0.1.0-SNAPSHOT.jar http://www.columbia.edu/~fdc/sample.html

if [ $? == 0 ]
then
    echo Success
fi

java -jar /home/lukas/klib/io.klib.netconnect/build/libs/io.klib.netconnect-0.1.0-SNAPSHOT.jar http://www.columba.edu/~fdc/sample.html

if [ $? == 1 ]
then
    echo Success
fi

#HTTPS

java -jar /home/lukas/klib/io.klib.netconnect/build/libs/io.klib.netconnect-0.1.0-SNAPSHOT.jar https://www.heise.de

if [ $? == 0 ]
then
    echo Success
fi

java -jar /home/lukas/klib/io.klib.netconnect/build/libs/io.klib.netconnect-0.1.0-SNAPSHOT.jar https://www.gooogle.de

if [ $? == 1 ]
then
    echo Success
fi

#Start a nginx proxy server in a docker container

sudo docker run --name temp -d -p 8080:8080 klibio/io.klib.forwarding-ssl-proxy:master-latest

#Configre proxy for java and try to download webpage

#HTTP

AVA_VMARGS="-Dhttp.proxyHost=<127.0.0.1> -Dhttp.proxyPort=<8080>" java ${JAVA_VMARGS} -jar /home/lukas/klib/io.klib.netconnect/build/libs/io.klib.netconnect-0.1.0-SNAPSHOT.jar http://www.columbia.edu/~fdc/sample.html

if [ $? == 0 ]
then
    echo Success
fi

AVA_VMARGS="-Dhttp.proxyHost=<127.0.0.1> -Dhttp.proxyPort=<8080>" java ${JAVA_VMARGS} -jar /home/lukas/klib/io.klib.netconnect/build/libs/io.klib.netconnect-0.1.0-SNAPSHOT.jar http://www.columba.edu/~fdc/sample.html

if [ $? == 1 ]
then
    echo Success
fi

#HTTPS

AVA_VMARGS="-Dhttp.proxyHost=<127.0.0.1> -Dhttp.proxyPort=<8080>" java ${JAVA_VMARGS} -jar /home/lukas/klib/io.klib.netconnect/build/libs/io.klib.netconnect-0.1.0-SNAPSHOT.jar https://www.heise.de

if [ $? == 0 ]
then
    echo Success
fi

AVA_VMARGS="-Dhttp.proxyHost=<127.0.0.1> -Dhttp.proxyPort=<8080>" java ${JAVA_VMARGS} -jar /home/lukas/klib/io.klib.netconnect/build/libs/io.klib.netconnect-0.1.0-SNAPSHOT.jar https://www.gooogle.de

if [ $? == 1 ]
then
    echo Success
fi

#Set OS wide proxy

#echo -e "http_proxy=http://127.0.0.1:8888/\nhttps_proxy=https://127.0.0.1:8888/" | sudo tee -a /etc/environment
#sudo netplan apply

export http_proxy=http://127.0.0.1:8080
export https_proxy=http://127.0.0.1:8080

#HTTP

java -jar /home/lukas/klib/io.klib.netconnect/build/libs/io.klib.netconnect-0.1.0-SNAPSHOT.jar http://www.columbia.edu/~fdc/sample.html

if [ $? == 0 ]
then
    echo Success
fi

java -jar /home/lukas/klib/io.klib.netconnect/build/libs/io.klib.netconnect-0.1.0-SNAPSHOT.jar http://www.columba.edu/~fdc/sample.html

if [ $? == 1 ]
then
    echo Success
fi

#HTTPS

java -jar /home/lukas/klib/io.klib.netconnect/build/libs/io.klib.netconnect-0.1.0-SNAPSHOT.jar https://www.heise.de

if [ $? == 0 ]
then
    echo Success
fi

java -jar /home/lukas/klib/io.klib.netconnect/build/libs/io.klib.netconnect-0.1.0-SNAPSHOT.jar https://www.gooogle.de

if [ $? == 1 ]
then
    echo Success
fi

#Delte proxy

sudo docker rm -f temp

echo Nice, everything works as intended!
